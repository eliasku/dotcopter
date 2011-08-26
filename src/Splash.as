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
	public class Splash extends Stamp
	{
		public static var speed:Number = 0;
		public static var timeStep:Number = 1;
		
		private var cover:BitmapData;
		private var t:Number;
		private var _dir:int;
		private var overlap:int = 4;
		
		public function Splash(px:int, py:int, dir:int) 
		{
			cover = new BitmapData(FP.width, FP.height, true, 0xFFFFFFFF);
			super(cover, px, py);
			_dir = dir;
			this.scrollX = 0;
			this.scrollY = 0;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
/*			if (CoptGame.pauseMode) {
				super.render(FP.buffer, new Point( 0, t), FP.zero);
				return;
			}*/
			if (_dir < 0) {
				if (t < _dir*(FP.height*.5+overlap)) { 
					speed *= -1;
					CoptGame(FP.world).reset();
				}
				if (t > 0) {
					CoptGame.clickable = true;
					speed = 0;
				}
			}
			if (speed == 0) t = 0;
			t += _dir * speed * timeStep;
			super.render(FP.buffer, new Point( 0, t), FP.zero);
		}
}