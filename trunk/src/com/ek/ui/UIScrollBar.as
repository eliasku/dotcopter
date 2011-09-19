package com.ek.ui 
{
	import com.ek.gocs.IComponentContainer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author �������������
	 */
	public class UIScrollBar extends UIWrapper 
	{
		public function UIScrollBar(owner:IComponentContainer, content:Sprite)
		{
			super(owner, content);
			
			var forward:Sprite = content.getChildByName("forward") as Sprite;
			var backward:Sprite = content.getChildByName("backward") as Sprite;
			var slider:Sprite = content.getChildByName("slider") as Sprite;
			
			if(forward)
			{
				_forward = new UIButton(this, forward);
				_forward.content.addEventListener(MouseEvent.MOUSE_DOWN, forwardHandler);
			}
			
			if(backward)
			{
				_backward = new UIButton(this, backward);
				_backward.content.addEventListener(MouseEvent.MOUSE_DOWN, backwardHandler);
			}
			
			if(slider)
			{
				_slider = new UISlider(this, slider);
				_slider.addEventListener(Event.CHANGE, sliderChangeHandler);
			}
		}

		private function sliderChangeHandler(event:Event):void 
		{
			dispatchEvent(event);
		}

		private function forwardHandler(event:MouseEvent):void 
		{
			_slider.value += _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function backwardHandler(event:MouseEvent):void 
		{
			_slider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			if(_slider.orientation == UIOrientation.HORIZONTAL)
				_slider.setSliderParams(min, max, value);
			else
				_slider.setSliderParams(max, min, value);
		}

		public function set value(v:Number):void
		{
			_slider.value = v;
		}
		
		public function get value():Number
		{
			return _slider.value;
		}
		
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}
		public function get lineSize():int
		{
			return _lineSize;
		}
 
		private var _forward:UIButton;		private var _backward:UIButton;
		private var _slider:UISlider;
		private var _lineSize:int = 1; 
	}
}
