package  
{
	import com.ek.audio.AudioLazy;
	import flash.geom.Point;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Turret extends Entity 
	{
		[Embed(source='../assets/turret_tower.png')] private const TOWER:Class;
		[Embed(source='../assets/turret_gun.png')] private const GUN:Class;
		
		public static const DISAPPEAR_OFFSET:int = -72;
		public static const APPEAR_OFFSET:int = 24;
		public static const HALF_WIDTH:int = 10;
		
		public static const GUN_LENGTH:int = 8;

		public var launchDirection:Number = 0;

		private var _degree:Number = 180;
		
		private var _terrain:Landscape;
		private var _copter:Heli;
		
		private var _tower:Image;
		private var _gun:Image;
		private var _offset:Number;
		
		private var _fireTime:int = 0;
		
		public function Turret()
		{
			_terrain = CoptGame.instance.terrain;
			_copter = CoptGame.instance.copter;
			
			_tower = new Image(TOWER);
			_gun = new Image(GUN);
			
			_gun.originX = 1;
			_gun.x = 4;
			_gun.y = 3;
			
			var turret:Graphiclist = new Graphiclist(_gun, _tower);
			graphic = turret;
			
			reset();
			
			setHitboxTo(_tower);
			
			type = "turret";
			
			layer = ZSort.TURRET;
		}
		
		override public function update():void 
		{
			if (CoptGame.started && !CoptGame.pauseMode)
			{
				x -= _terrain.deltaShift;
				
				y = _terrain.getPlaceOffset(x + _tower.width * 0.5) - _tower.height * 0.5;
				
				if (x + _tower.width < 0)
				{
					destroy();
				}
				
				_fireTime ++;
				if (_fireTime % 10 == 0)
					shoot();
				
				_degree = 90 - Math.atan2(_copter.centre.y - (y + _tower.height * 0.5), _copter.centre.x - (x + _tower.width * 0.5)) / Math.PI * 180;
				if (_degree<0) 
					_degree = 270;
				else if (_degree>0 && _degree <= 180) 
					_degree = 180;
				_gun.angle = _degree;
				
				super.update();
			}
		}
		
		public function destroy():void
		{
			world.recycle(this);
			reset();
		}
		
		private function reset():void 
		{
			x = FP.width;
			y = _terrain.getPlaceOffset(x + _tower.width * 0.5) - _tower.height * 0.5;
		}
		
		public function shoot():void
		{
			if (y + _tower.height * 0.5 < _copter.centre.y) return;
			if (x + _tower.width * 0.5 < _copter.centre.x) return;
			
			AudioLazy.playAt("sfx_turret_shoot", centerX, centerY);
			
			launchDirection = Math.atan2(_copter.centre.y - (y + _tower.height * 0.5), _copter.centre.x - (x + _tower.width * 0.5));
			var bulletEntry:Point = Point.polar(GUN_LENGTH, launchDirection);
			bulletEntry.offset(4, 2);
			FP.world.add(new Bullet(this, bulletEntry));
		}
	}

}