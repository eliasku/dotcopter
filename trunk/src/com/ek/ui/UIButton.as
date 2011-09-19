package com.ek.ui 
{
	import com.ek.gocs.IComponentContainer;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author eliasku
	 */
	public class UIButton extends UIWrapper
	{
		private var _over:Boolean;
		private var _pressed:Boolean;
		private var _enabled:Boolean = true;
		private var _selected:Boolean;
		
		private var _clickHandler:Function;
			

		public function UIButton(owner:IComponentContainer, content:Sprite, clickHandler:Function = null)
		{
			super(owner, content);
			
			if(content)
			{
				content.mouseEnabled = true;
				content.mouseChildren = false;
				content.buttonMode = true;
				content.useHandCursor = true;
				
				content.addEventListener(MouseEvent.CLICK, onClick);
				content.addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
				content.addEventListener(MouseEvent.MOUSE_OUT, onRollOut);
				content.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				content.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				// TODO: hit_area scan
				if(content.getChildByName("hit_area"))
				{
					hitArea = content.getChildByName("hit_area") as Sprite;
				}
			}
			
			if(clickHandler!=null)
				_clickHandler = clickHandler;
		}

		protected function onMouseUp(event:MouseEvent):void 
		{
			_pressed = false;
			//trace("mouse up");
		}

		protected function onMouseDown(event:MouseEvent):void 
		{
			_pressed = true;
			//trace("mouse down");
		}

		protected function onRollOut(event:MouseEvent):void 
		{
			_over = false;
			_pressed = false;
			//trace("roll out");
		}

		protected function onRollOver(event:MouseEvent):void 
		{
			_over = true;
			//trace("roll over");
		}

		protected function onClick(event:MouseEvent):void
		{
			if(hasEventListener(MouseEvent.CLICK))
				dispatchEvent(event);
			if(_clickHandler!=null)
				_clickHandler(this);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(!value)
				_pressed = false;
			content.mouseEnabled = value;
			content.useHandCursor = value;
			
			updateEnabledStyle();
		}

		protected function updateEnabledStyle():void 
		{

		}

		public function get pressed():Boolean
		{
			return _pressed;
		}
		
		public function get over():Boolean
		{
			return _over;
		}
		
		public function set hitArea(sprite:Sprite):void
		{
			content.hitArea = sprite;
			if(sprite)
			{
				sprite.mouseEnabled = false;
				sprite.visible = false;
			}
		}
		
		public function get hitArea():Sprite
		{
			return content.hitArea;
		}
		
		public function get clickHandler():Function
		{
			return _clickHandler;
		}
		
		public function set clickHandler(value:Function):void
		{
			_clickHandler = value;
		}
	
	}
}
