package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import land.Landscape;
	import net.flashpunk.graphics.Backdrop;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Back extends Backdrop 
	{
		private var _terrain:Landscape;
		private var _shift:Point = new Point();
		private var _kx:Number;
		
		public function Back(source:BitmapData, kx:Number, scrollFactorY:Number = 1) 
		{
			_terrain = CoptGame.instance.terrain;
			_kx = kx;
			
			super(source);
			
			scrollY = scrollFactorY;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			if (GameState.pauseMode) return;
			if (GameState.started || GameState.emulation)
			{
				_shift.x -= _terrain.vx * _kx;
			} 
			super.render(target, _shift, camera);
		}
		
	}

}