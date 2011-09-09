package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Bullet extends Entity 
	{
		private var _turret:Turret;
		private var _explode:Explode;
		
		private var _power:Number = 4;
		
		private var _g:Number;
		private var _vx:Number;
		private var _vy:Number;
		private var _dx:Number = 0;
		private var _dy:Number = 0;
		
		private var _startPos:Point;
		private var _targetOriginX:Number;
		
		public function Bullet(turret:Turret, startPos:Point) 
		{
			_turret = turret;
			_startPos = startPos;
			
			//_rocks = CoptGame(FP.world).land;
			_explode = CoptGame(FP.world).explode;
			
			var image:Image = Image.createRect(2, 2); 
			image.originX = 1;
			image.originY = 1;
			image.alpha = 0.8;
			
			super(_turret.x + _startPos.x, _turret.y + _startPos.y, image);
			
			_targetOriginX = _turret.x;
			
			setHitbox(2, 2);
			type = "bullet";
			
			_g = (turret.flipped) ? 0 : 0.1;
			_power = (turret.flipped) ? 3 : 4;
			_vx = _power * Math.cos(turret.launchDirection);
			_vy = _power * Math.sin(turret.launchDirection);
		}
		
		override public function update():void 
		{
			super.update();
			
			_vy += _g;
			
			_dx += _vx;
			_dy += _vy;
			
			x = _turret.x + _startPos.x + _dx;
			y = _turret.y + _startPos.y + _dy;
			
			if (_turret.x > _targetOriginX || x < 0)
				FP.world.remove(this);
				
			if (collide("land", x, y))
			{
				//_rocks.makeHole(getCentre(), 5);
				_explode.burst(getCentre());
				FP.world.remove(this);
			}
			
			if (collide("copter", x, y))
			{
				FP.world.remove(this);
			}
		}
		
		private function getCentre():Point
		{
			return new Point(x + 1, y + 1);
		}
	}
}