package  
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Splasher
	{
		private var _top:Shutter;
		private var _bottom:Shutter;
		protected var _world:World;
		
		private var _isSplashing:Boolean;
		private var _t:Number;
		private var _dt:int;
		protected var _mult:Number;
			
		public function Splasher(world:World) 
		{
			_world = world;
			_top = new Shutter(-FP.height); _world.addGraphic(_top);
			_bottom = new Shutter(FP.height); _world.addGraphic(_bottom);
		}
		
		public function update():void
		{
			if (_isSplashing) {
				_t += _dt * _mult;
				if (_t > FP.halfHeight + 3) {
					_dt *= -1;
					_mult = 1.25;
					onClose();
				}
				if (_t < 0) {
					_t = 0;
					_dt *= -1;
					_isSplashing = false;
					onOpen();
				}
				_top.dy = _t;
				_bottom.dy = _t * -1;
			}
		}
		
		public function splash():void
		{
			_t = 0; _dt = 2; _mult = 0.75;
			_isSplashing = true;
		}
		
		public function intro():void
		{
			_t = FP.halfHeight + 3;
			_dt = -2;
			_mult = 1.25;
			_isSplashing = true;
		}
		
		public function onClose():void
		{ 
			CoptGame(_world).reset();
		}
		
		public function onOpen():void
		{
			//if (CoptGame(_world).firstRun)
				//CoptGame(_world).firstRun = false;
			CoptGame.clickable = true;
		}
	}
}