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
		
		private var _controlUp:Boolean = false;
		private var _controlDown:Boolean = false;
		
		private var _terrain:Landscape;
		
		public function AutoPilot()
		{
			_terrain = CoptGame.instance.terrain;
		}
		
		/* INTERFACE IPilotage */
		
		public function update(pos:Point):void
		{
			var middle:int = _terrain.getPlaceOffset(pos.x) - _terrain.spaceGap * 0.5;
			
			if (pos.y < middle)
			{
				_controlUp = false;
				_controlDown = true;
			}
			else
			{
				_controlUp = true;
				_controlDown = false;
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