package  
{
	import draw.Pencil;
	import flash.geom.Point;
	import land.Landscape;
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
		
		private var _g:Number = 0.1;
		private var _vx:Number;
		private var _vy:Number;
		private var _dx:Number = 0;
		private var _dy:Number = 0;
		
		private var _startPos:Point;
		private var _targetOriginX:Number;
		private var _terrain:Landscape;
		
		private var _pos:Point = new Point();
		
		public function Bullet(turret:Turret, startPos:Point) 
		{
			_turret = turret;
			_startPos = startPos;
			
			_terrain = CoptGame(FP.world).terrain;
			_explode = CoptGame(FP.world).explode;
			
			var image:Image = Image.createRect(2, 2, Pencil.RED); 
			image.alpha = 0.8;
			
			super(_turret.x + _startPos.x, _turret.y + _startPos.y, image);
			
			_targetOriginX = _turret.x;
			
			setHitbox(2, 2);
			type = "bullet";
			
			layer = ZSort.TURRET;
			
			//_g = (turret.flipped) ? 0 : 0.1;
			//_power = (turret.flipped) ? 3 : 4;
			_vx = _power * Math.cos(turret.launchDirection);
			_vy = _power * Math.sin(turret.launchDirection);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (_turret)
			{
				_vy += _g;
				
				_dx += _vx;
				_dy += _vy;
				
				x = _turret.x + _startPos.x + _dx;
				y = _turret.y + _startPos.y + _dy;
				
				if (_turret.x > _targetOriginX || x < 0)
					destroy();
					
				if (collide("land", x, y))
				{
					_terrain.makeHole(getPos(), 5);
					_explode.detonate(Explode.SMALL, getPos(), 20);
					destroy();
				}
			}
			else
				destroy();
		}
		
		public function destroy():void
		{
			FP.world.remove(this);
		}
		
		private function getPos():Point
		{
			_pos.x = x + 1;
			_pos.y = y + 1;
			return _pos;
		}
	}
}