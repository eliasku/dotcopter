package com.ek.ui 
{
	import com.ek.gocs.IComponentContainer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author �������������
	 */
	public class UISlider extends UIWrapper 
	{
		
		
		public function UISlider(owner:IComponentContainer, content:Sprite)
		{
			super(owner, content);
			
			var handle:Sprite = content.getChildByName("handle") as Sprite;
			
			if(handle)
			{
				_handle = new UIButton(this, handle);
				_handle.content.addEventListener(MouseEvent.MOUSE_DOWN, dragHandler); 
			}
			
			_back = content.getChildByName("back") as Sprite;
			if(_back)
			{
				_back.addEventListener(MouseEvent.MOUSE_DOWN, backClickHandler); 
			}
			
			if(content.width > content.height)
				_orientation = UIOrientation.HORIZONTAL;
			else
				_orientation = UIOrientation.VERTICAL;
		}

		private function backClickHandler(event:MouseEvent):void 
		{
			if(_orientation == UIOrientation.HORIZONTAL)
			{
				_handle.content.x = content.mouseX - content.height / 2;
				_handle.content.x = Math.max(_handle.content.x, 0);
				_handle.content.x = Math.min(_handle.content.x, content.width - content.height);
				_value = _handle.content.x / (content.width - content.height) * (_max - _min) + _min;
			}
			else
			{
				_handle.content.y = content.mouseY - content.width / 2;
				_handle.content.y = Math.max(_handle.content.y, 0);
				_handle.content.y = Math.min(_handle.content.y, content.height - content.width);
				_value = (content.height - content.width - _handle.content.y) / (content.height - content.width) * (_max - _min) + _min;
			}
			
			dispatchEvent(new Event(Event.CHANGE)); 
		}

		private function dragHandler(event:MouseEvent):void 
		{
			content.stage.addEventListener(MouseEvent.MOUSE_UP, dropHandler);
			content.stage.addEventListener(MouseEvent.MOUSE_MOVE, slideHandler);
			
			if(_orientation == UIOrientation.HORIZONTAL)
			{
				_handle.content.startDrag(false, new Rectangle(0, 0, content.width - content.height, 0));
			}
			else
			{
				_handle.content.startDrag(false, new Rectangle(0, 0, 0, content.height - content.width));
			}
			
			_dragged = true;
		}

		private function dropHandler(event:MouseEvent):void
		{
			content.stage.removeEventListener(MouseEvent.MOUSE_UP, dropHandler);
			content.stage.removeEventListener(MouseEvent.MOUSE_MOVE, slideHandler);
			content.stopDrag();
			
			_dragged = false;
		}
		
		private function slideHandler(event:MouseEvent):void
		{
			var last:Number = _value;
			
			if(_orientation == UIOrientation.HORIZONTAL)
			{
				_value = _handle.content.x / (content.width - content.height) * (_max - _min) + _min;
			}
			else
			{
				_value = (content.height - content.width - _handle.content.y) / (content.height - content.width) * (_max - _min) + _min;
			}
			
			if(_value != last)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function correctValue():void
		{
			if(_max > _min)
			{
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}
			else
			{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}
		
		private function updateHandle():void
		{
			var range:Number;
			
			if(_dragged) return;
			
			if(_orientation == UIOrientation.HORIZONTAL)
			{
				range = content.width - content.height;
				_handle.content.x = (_value - _min) / (_max - _min) * range;
			}
			else
			{
				range = content.height - content.width;
				_handle.content.y = range - (_value - _min) / (_max - _min) * range;
			}
			
			
		}
		
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		} 
		
		public function set value(v:Number):void
		{
			_value = v;
			correctValue();
			updateHandle();
			
			// This has the potential to set up an infinite loop if two sliders are listening to each other's change
			// events to sync to each other. Tentitively trying it out... 
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value():Number
		{
			return Math.round(_value / _ticker) * _ticker;
		}
		
		public function set maximum(value:Number):void
		{
			_max = value;
			correctValue();
			updateHandle();
		}
		
		public function get maximum():Number
		{
			return _max;
		}
		
		public function set minimum(value:Number):void
		{
			_min = value;
			correctValue();
			updateHandle();
		}
		
		public function get minimum():Number
		{
			return _min;
		}
		
		public function set ticker(value:Number):void
		{
			_ticker = value;
		}
		public function get ticker():Number
		{
			return _ticker;
		} 
		
		private var _handle:UIButton;
		private var _back:Sprite;
		private var _value:Number = 0;
		private var _max:Number = 100;
		private var _min:Number = 0;
		private var _orientation:String = UIOrientation.VERTICAL;
		private var _ticker:Number = 1;
		private var _dragged:Boolean;
		
		public function get orientation():String
		{
			return _orientation;
		} 
	}
}
