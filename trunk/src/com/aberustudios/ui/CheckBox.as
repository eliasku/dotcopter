package com.aberustudios.ui
{
	import flash.events.MouseEvent;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.utils.Input;
	
	/**
	 * A checkbox class that allows you to insert buttons that are checked or unchecked.
	 *  
	 * @author Rolpege
	 */	
	public class CheckBox extends Entity
	{
		/**
		 * This function will be called when the button is pressed. The function needs to have one parameter,
		 * which value will be the value of the checked property of the Checkbox.
		 * 
		 * @see #checked
		 */		
		public var callback:Function = null;
		/**
		 * This function will be called when the mouse overs the checkbox. 
		 */		
		public var overCall:Function = null;
		private var overCalled:Boolean = false;
		
		private var initialized:Boolean = false;
		
		private var _normal:Graphic = new Graphic;
		private var _normalChecked:Graphic = new Graphic;
		private var _hover:Graphic = new Graphic;
		private var _hoverChecked:Graphic = new Graphic;
		private var _down:Graphic = new Graphic;
		private var _downChecked:Graphic = new Graphic;
		private var _inactive:Graphic = new Graphic;
		private var _inactiveChecked:Graphic = new Graphic;
		
		private var _normalChanged:Boolean = false;
		private var _hoverChanged:Boolean = false;
		private var _downChanged:Boolean = false;
		private var _inactiveChanged:Boolean = false;
		
		/**
		 * This var manages if the checkbox is inactive or not. 
		 */		
		public var shouldCall:Boolean = true;
		
		/**
		 * This var manages if the checkbox is checked or not. 
		 */		
		public function get checked():Boolean{ return _checked; }
		public function set checked(value:Boolean):void
		{
			_checked = value;
			_normalChanged = _hoverChanged = _downChanged = _inactiveChanged = true;
		}
		private var _checked:Boolean = false;		
		
		/**
		 * Constructor.
		 *  
		 * @param x			X coordinate of the checkbox.
		 * @param y			Y coordinate of the checkbox.
		 * @param width		With of the checkbox's hitbox.
		 * @param height	Height of the checkbox's hitbox.
		 * @param callback	The function that will be called when the checkbox is toggled.
		 * @param checked	If the checkbox is checked by default.
		 */		
		public function CheckBox(x:Number=0, y:Number=0, width:int=0, height:int=0, callback:Function=null, checked:Boolean=false)
		{
			super(x, y);
			
			setHitbox(width, height);
			
			this.callback = callback;
			if(checked)
				graphic = _normalChecked;
			else
				graphic = _normal;
		}
		
		/**
		 * @private 
		 */		
		override public function update():void
		{
			if(!initialized)
			{
				if(FP.stage != null)
				{
					FP.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					initialized = true;
				}
			}
			
			super.update();
			
			if(!shouldCall)
			{
				if(graphic != _inactive || _inactiveChanged)
				{
					if(checked)
						graphic = _inactiveChecked;
					else
						graphic = _inactive;
					_inactiveChanged = false;
				}
			}
			else if(collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				if(Input.mouseDown)
				{
					if(graphic != _down || _downChanged)
					{
						if(checked)
							graphic = _downChecked;
						else
							graphic = _down;
						_downChanged = false;
					}
				}
				else if(graphic != _hover || _hoverChanged)
				{
					if(checked)
						graphic = _hoverChecked;
					else
						graphic = _hover;
					_hoverChanged = false;
					
					if(!overCalled)
					{
						if(overCall != null) overCall();
						overCalled = true;
					}
				}
			}
			else if(graphic != _normal || _normalChanged)
			{
				if(checked)
					graphic = _normalChecked;
				else
									
					graphic = _normal;
				_normalChanged = false;
				overCalled = false;
			}
		}
		
		private function onMouseUp(e:MouseEvent=null):void
		{
			if(!shouldCall || !Input.mouseReleased || (callback == null)) return;
			if(collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				callback(checked);
				checked = !checked;
			}
		}
		
		/** 
		 * @private
		 */		
		override public function removed():void
		{
			super.removed();
			
			if(FP.stage != null)
				FP.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		/**
		 * Graphic of the checkbox when active and not pressed nor overed AND NOT CHECKED.
		 * 
		 * @see #normalChecked
		 */		
		public function get normal():Graphic{ return _normal; }
		/**
		 * Graphic of the button when the mouse overs it and it's active AND NOT CHECKED.
		 * 
		 * @see #hoverChecked
		 */		
		public function get hover():Graphic{ return _hover; }
		/**
		 * Graphic of the button when the mouse is pressing it and it's active AND NOT CHECKED.
		 * 
		 * @see #downChecked
		 */		
		public function get down():Graphic{ return _down; }
		/**
		 * Graphic of the button when inactive AND NOT CHECKED.
		 * 
		 * @see #shouldCall
		 * @see #inactiveChecked
		 */		
		public function get inactive():Graphic{ return _inactive; }
		/**
		 * Graphic of the checkbox when active and not pressed nor overed AND CHECKED.
		 * 
		 * @see #normal
		 */		
		public function get normalChecked():Graphic{ return _normalChecked; }
		/**
		 * Graphic of the button when the mouse overs it and it's active AND CHECKED.
		 * 
		 * @see #hover
		 */		
		public function get hoverChecked():Graphic{ return _hoverChecked; }
		/**
		 * Graphic of the button when the mouse is pressing it and it's active AND CHECKED.
		 * 
		 * @see #down
		 */		
		public function get downChecked():Graphic{ return _downChecked; }
		/**
		 * Graphic of the button when inactive AND CHECKED.
		 * 
		 * @see #shouldCall
		 * @see #inactive
		 */		
		public function get inactiveChecked():Graphic{ return _inactiveChecked; }
		
		public function set normal(normal:Graphic):void{_normal = normal;_normalChanged = true;}
		public function set hover(hover:Graphic):void{_hover = hover;_hoverChanged = true;}
		public function set down(down:Graphic):void{_down = down;_downChanged = true;}
		public function set inactive(inactive:Graphic):void{_inactive = inactive;_inactiveChanged = true;}
		
		public function set normalChecked(normal:Graphic):void{_normalChecked = normal;_normalChanged = true;}
		public function set hoverChecked(hover:Graphic):void{_hoverChecked = hover;_hoverChanged = true;}
		public function set downChecked(down:Graphic):void{_downChecked = down;_downChanged = true;}
		public function set inactiveChecked(inactive:Graphic):void{_inactiveChecked = inactive;_inactiveChanged = true;}
	}
}