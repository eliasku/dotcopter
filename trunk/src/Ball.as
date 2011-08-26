package  
{
	import flash.display.BlendMode;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Ball extends Entity
	{
		private var _speed:int = 3;
		private var _dir:int = 1;
		
		private var _vx:Number = 0;
		private var _vy:Number = 1;
		
		private var _radius:int = 2;
		
		private var _left:Number = 0;
		private var _right:Number = GameSize.X1;
		private var _top:Number = 0;
		private var _bottom:Number = GameSize.X1 - 10;
		
		private var _target:Rocks;
		private var _contact:Point;
		
		[Embed(source = '../assets/ball.png')] private const BALL:Class;
		
		public function Ball(target:Rocks) 
		{
			_target = target;
			
			//_explode = explode;
			
			var image:Image = new Image(BALL);
			image.x = -2;
			image.y = -2;
			image.blend = BlendMode.INVERT;
			//image.scrollY = 0
			
			super(GameSize.X1+_radius, GameSize.X1_2, image);
			setHitbox(4, 4, 2, 2);
			
			type = "ball";
			
			_contact = new Point(x, y);
			
			_dir = -1;
			_vx = _speed * _dir;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (CoptGame.started && !CoptGame.pauseMode)
			{
	/*			if (collide("copter", x, y))
				{
					_target.destroy();
				}*/
				
				if(x + _radius > _right)
				{
					x = _right - _radius;
					
					_dir *= -1;
					_speed = 3;
					_vx = _speed * _dir;
				}
				else if(x + _radius < _left)
				{
					x = _left + _radius;
					
					_dir *= -1;
					_speed = 1;
					_vx = _speed * _dir;
					
					/*if (FP.random < 0.5)
					{
						_vy *= -1;
					}
					x = _right+2;
					y = _target.getFreeSpace() + 4 + FP.rand(GameSize.X3_4 - 10);*/
				}
				
				if (collide("rock", x, y))
				{
					_contact.x = x;
					_contact.y = y;
					_target.makeHole(_contact, 6);
					//_explode.burst(_contact);
					_vy *= -1;
				}
				
				x += _vx;
				y += _vy;
			}
		}
		
	}

}