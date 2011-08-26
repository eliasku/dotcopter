package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class ColorLine extends Sprite 
	{
		private var _color:uint = 0;
		
		private var _shape:Shape;
		
		private var _ct:ColorTransform;
		
		public function ColorLine() 
		{
			_shape = new Shape();
			_shape.graphics.beginFill(_color);
			_shape.graphics.drawRect(50, 50, 50, 50);
			_shape.graphics.endFill();
			addChild(_shape);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_color++;
			
			_ct = _shape.transform.colorTransform;
			_ct.color = _color;
			_shape.transform.colorTransform = _ct;
		}
		
	}

}