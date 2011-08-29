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
		private var _shakeTime:int = -1;
		
		private function shake(time:int):void
		{
			_shakeTime = time;
			if (_shakeTime < 0)
			{
				updateShake(0, 0);
			}
		}
		
		public function update():void
		{
			if (isShaking())
			{
				if (_shakeTime > 0)
				{
					_shakeTime--;
					if (_shakeTime == 0)
						_shakeTime = -1;
				}
				
				if (_shakeTime < 0)
					shake(-1);
				else
				{
					updateShake(int(_intensity * (FP.random * GameSize.X2 - GameSize.X1)),
								int(_intensity * (FP.random * GameSize.X2 - GameSize.X1)));
				}
			}
		}
		
		public function perform(intensity:Number = 0.06, duration:int = 24):void 
		{
			_intensity = intensity;
			shake(duration);
		}
		
		private function updateShake(dx:int, dy:int):void 
		{
			FP.camera.x = dx;
			FP.camera.y = FP.camera.y + dy;
		}
		
		private function isShaking():Boolean 
		{
			return _shakeTime >= 0;
		}
		
	}
}