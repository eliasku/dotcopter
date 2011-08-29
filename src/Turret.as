package  
{
	import flash.geom.Point;
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
		[Embed(source = '../assets/turret_base.png')] private const BASE:Class;
		
		public static const DISAPPEAR_OFFSET:int = -72;
		public static const APPEAR_OFFSET:int = 24;
		public static const HALF_WIDTH:int = 10;
		
		public static const GUN_LENGTH:int = 8;

		public var launchDirection:Number = 0;
		
		private var _target:Copter;
		private var _gun:Image;
		private var _base:Image;
		
		private var _degree:Number = 180;
		private var _speed:int = 2;
		
		private var _flipped:Boolean;
		private var _dir:int;
		
		private var _t:int = 0;
		private var _line:int = 0;
		
		public function Turret(target:Copter, flipped:Boolean = true)
		{
			_target = target;
			
			_base = new Image(BASE);
			_base.x = -HALF_WIDTH;
			
			_gun = Image.createRect(2, GUN_LENGTH);
			_gun.originX = 1;
			_gun.x = -1;
			
			var turret:Graphiclist = new Graphiclist(_base, _gun);
			
			super(CoptGame.SCREEN_SIZE + APPEAR_OFFSET, CoptGame.SCREEN_SIZE, turret);
			
			type = "turret";
			
			flip(flipped);
		}
		
		private function flip(value:Boolean):void
		{
			_flipped = value;
			_base.scaleY = (_flipped) ? -1 : 1;
			_base.y = (_flipped) ? 3 : -3;

			setHitbox(4, 5, 3, (_flipped) ? 5 : 0);
			
			_dir = (_flipped) ? -1 : 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (CoptGame.started && !CoptGame.pauseMode)
			{
				x -= _speed;
				if (x < DISAPPEAR_OFFSET)
					reset();
				
				if (x > HALF_WIDTH) y += 10 * _dir;
				var loopCounter:int = 0;
				while (loopCounter++ != 20) 
				{
					if (collide("rock", x, y))
						y -= 1*_dir;
					else 
						break;
				}
				
				_degree = 90 - Math.atan2(_target.centre.y - y, _target.centre.x - x) / Math.PI * 180;
				if (_flipped)
				{
					if (_degree >= 90 && _degree <= 180) _degree = 90;
					if (_degree > 180 && _degree <= 270) _degree = -90;
				}
				else
				{
					if (_degree <= 90) _degree = 90;
					if (_degree >= 270) _degree = 270;
				}
				_gun.angle = _degree;
				
				if (_line > 0)
				{
					_t++;
					if (_t == 3)
					{
						_t = 0;
						
						shoot();
						_line--;
					}
				}
				
			}
		}
		
		public function fire(line:int):void
		{
			_line = line;
		}
		
		public function shoot():void
		{
			if (_flipped)
			{
				if (_target.centre.y < y) return;
			}
			else
			{
				if (_target.centre.y > y) return;
			}
			
			launchDirection = Math.atan2(_target.centre.y - y, _target.centre.x - x);
			
			var bulletEntry:Point = Point.polar(GUN_LENGTH + 1, launchDirection);
			
			FP.world.add(new Bullet(this, bulletEntry));
		}
		
		public function reset():void 
		{
			x = CoptGame.SCREEN_SIZE + APPEAR_OFFSET;
			y = CoptGame.SCREEN_SIZE;
			
			_degree = 90;
			
			if (FP.random < 0.5)
				flip(!_flipped);
		}
		
		public function get flipped():Boolean 
		{
			return _flipped;
		}
	}

}