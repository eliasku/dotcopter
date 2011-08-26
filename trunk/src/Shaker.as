package  
{
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Shaker 
	{
		private var _intensity:Number;
		private var _timer:Number;
		private var dx:int;
		private var dy:int;
		
		public function Shaker() {}
		
		public function shake(intensity:Number = 0.06, duration:int = 24):void
		{
			_intensity = intensity;
			_timer = duration;
		}
		
		public function update():void
		{
			if (_timer > 0) {
				_timer --;
				if(_timer <= 0) {
					_timer = 0;
					dx = 0; dy = 0;
				} else {
					dx = (FP.random * _intensity * FP.screen.width * 2 - _intensity * FP.screen.width);
					dy = (FP.random * _intensity * FP.screen.height * 2 - _intensity * FP.screen.height);
				}
				FP.camera.x = dx;
				FP.camera.y = FP.camera.y + dy;
			}
		}
		
	}
}