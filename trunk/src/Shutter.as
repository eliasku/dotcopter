package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Stamp;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Shutter extends Stamp
	{
		public var dy:Number = 0;
		
		public function Shutter(py:int) 
		{
			super(new BitmapData(FP.width, FP.height, true, 0xFFFFFFFF), 0, py);
			this.scrollX = 0;
			this.scrollY = 0;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			super.render(FP.buffer, new Point( 0, dy), FP.zero);
		}
		
	}

}