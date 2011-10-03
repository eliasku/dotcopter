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
		private var _target:IMoveable = CoptGame.instance.terrain;
		
		private var _shift:Point = new Point();
		private var _kx:Number;
		
		public function Back(source:BitmapData, kx:Number, scrollFactorY:Number = 1) 
		{
			_kx = kx;
			
			super(source);
			
			scrollY = scrollFactorY;
		}
		
		public function setTarget(target:IMoveable):void
		{
			_target = target;
		}
		
		override public function render(target:BitmapData, point:Point, camera:Point):void 
		{
			if (GameState.pauseMode) return;
			if (GameState.started || GameState.emulation)
			{
				_shift.x -= _target.vx * _kx;
			} 
			super.render(target, _shift, camera);
		}
		
	}

}