package  
{
	import draw.Pencil;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import land.Landscape;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Background extends Backdrop 
	{
		[Embed(source = '../assets/bg.png')] private const BG:Class;
		
		private var _shift:Point = new Point();
		private var _terrain:Landscape;
		private var _copter:Heli;
		
		public function Background() 
		{
			_terrain = CoptGame.instance.terrain;
			_copter = CoptGame.instance.copter;
			
			var top:BitmapData = FP.getBitmap(BG);
			var bottom:BitmapData = FP.getBitmap(BG);
			
			var back:BitmapData = new BitmapData(top.width, top.height * 2, true, Pencil.BLACK);
			
			var matrix:Matrix = new Matrix();
			matrix.rotate(Math.PI);
			matrix.translate(top.width, top.height);
			back.draw(top, matrix);
			
			matrix = new Matrix();
			matrix.translate(0, top.height);
			back.draw(bottom, matrix);
			
			super(back);
			
			scrollY = 1;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			if (CoptGame.started && !CoptGame.pauseMode)
			{
				_shift.x -= _terrain.vx;
			} 
			super.render(target, _shift, camera);
		}
		
	}

}