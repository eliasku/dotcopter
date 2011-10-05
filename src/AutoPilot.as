package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import land.Landscape;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class AutoPilot implements IPilotage
	{
		private var _owner:Copter;
		
		private var _maxLifes:int = 3;
		
		private const UP:int = 1;
		private const DOWN:int = -1;
		
		private var _controlUp:Boolean = false;
		private var _controlDown:Boolean = false;
		
		private var _terrain:Landscape;
		
		//private var _dummy:Entity;
		
		public function AutoPilot(owner:Copter)
		{
			_owner = owner;
			_terrain = CoptGame.instance.terrain;
		
			//var img:Image = Image.createCircle(1.0);
			//_dummy = new Entity(0, 0, img);
			//CoptGame.instance.add(_dummy);
		}
		
		/* INTERFACE IPilotage */
		
		public function update(pos:Point):void
		{
			var safeArea:Rectangle = _terrain.getSafeRect(pos.x, _terrain.vx * 50);
			
			safeAreaMethod(pos, safeArea);
			
			_toogleTimeout++;
		}
		
		private function safeAreaMethod(pos:Point, rect:Rectangle):void
		{
			var mask_height:Number = 6;
			const pred_time:Number = 5;
			var pred_offset_y:Number = _owner.vy * pred_time;
			
			if (pos.y - mask_height + pred_offset_y < rect.y)
			{
				setControl(DOWN);
			}
			else if (pos.y + mask_height + pred_offset_y > rect.y + rect.height)
			{
				setControl(UP);
			}
			else
			{
				predMethod(pos);
			}
		}
		
		private function predMethod(pos:Point):void
		{
			var top:int = _terrain.getPlaceOffset(pos.x, 1);
			var bottom:int = _terrain.getPlaceOffset(pos.x, -1);
			
			var dt:int = pos.y - top;
			var db:int = bottom - pos.y;
			
			var dir:int;
			
			if (dt <= db)
			{
				dir = DOWN;
			}
			else
			{
				dir = UP;
			}
			
			suggestControl(dir);
		}
		
		private var _toogleTimeout:int = 0;
		
		private function suggestControl(dir:int):void
		{
			if ((dir > 0 && !_controlUp) || (dir < 0 && !_controlDown))
			{
				if (_toogleTimeout < 20)
				{
					return;
				}
			}
			
			setControl(dir);
		}
		
		private function setControl(dir:int):void
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
			
			_toogleTimeout = 0;
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