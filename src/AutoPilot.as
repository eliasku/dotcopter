package
{
	import flash.geom.Point;
	import land.Landscape;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class AutoPilot implements IPilotage
	{
		private var _maxLifes:int = 3;
		
		private const UP:int = 1;
		private const DOWN:int = -1;
		
		private var _controlUp:Boolean = false;
		private var _controlDown:Boolean = false;
		
		private var _terrain:Landscape;
		
		private const WARNING_DISTANCE:int = 40;
		
		public function AutoPilot()
		{
			_terrain = CoptGame.instance.terrain;
		}
		
		/* INTERFACE IPilotage */
		
		public function update(pos:Point, fpos:Point):void
		{
			var top:int = _terrain.getPlaceOffset(pos.x, 1);
			var bottom:int = _terrain.getPlaceOffset(pos.x, -1);
			
			var dt:int = pos.y - top;
			var db:int = bottom - pos.y;
			
			var ftop:int = _terrain.getPlaceOffset(fpos.x, 1);
			var fbottom:int = _terrain.getPlaceOffset(fpos.x, -1);
			
			var dir:int;
			if (dt < db)
			{
				dir = DOWN;
			}
			else
			{
				dir = UP;
			}
			
/*			if (fpos.y < ftop) 
			{
				trace("break UP");
				dir = DOWN;
			}*/
			
/*			if (fpos.y > fbottom)
			{
				trace("break DOWN");
				dir = UP;
			}*/
			
			toggleControl(dir);
		}
		
		private function toggleControl(dir:int):void
		{
			if (dir > 0)
			{
				_controlUp = true;
				_controlDown = false;
			}
			else
			{
				_controlUp = false;
				_controlDown = true;
			}
		}
		
		public function get maxLifes():int
		{
			return _maxLifes;
		}
		
		public function get controlUp():Boolean
		{
			return _controlUp;
		}
		
		public function get controlDown():Boolean
		{
			return _controlDown;
		}
	
	}

}