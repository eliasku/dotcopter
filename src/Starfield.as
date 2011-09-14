package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	
	/**
	 * implements a simple starfield
	 * @author Richard Marks
	 */
	public class Starfield extends Backdrop
	{
		private var stars:BitmapData;
		private var starNum:int;
		private var speed:int;
		private var t:int = 0;
		
		public function Starfield($speed:int, $alpha:Number, $starNum:int = 100) 
		{
			speed = $speed;
			starNum = $starNum;
			stars = new BitmapData(FP.width, FP.height*2, true, 0x00000000);
			for (var i:int = 0; i < starNum; i++) {
				stars.setPixel32(FP.random * FP.width, FP.random * FP.height*2, 0xFFFFFFFF);
			}
			super(stars, true);
			this.alpha = $alpha;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			if (CoptGame.pauseMode) {
				super.render(FP.buffer, new Point( t, 0), FP.zero);
				return;
			}
			if (CoptGame.started) {
				t -= speed;
				var p:Point = new Point( t, 0);
				super.render(FP.buffer, p, FP.zero);
			} else super.render(FP.buffer, new Point( t, 0), FP.zero);
		}
	}
}