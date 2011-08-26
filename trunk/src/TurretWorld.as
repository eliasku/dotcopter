package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class TurretWorld extends World
	{
		private var _turret:Turret;
		private var _copter:Copter;
		
		public function TurretWorld() 
		{
			_copter = new Copter(); add(_copter);
			_copter.y -= 48;
			_copter.x += 24;
			_turret = new Turret(_copter); add(_turret);
		}
		
		override public function update():void 
		{
			if (Input.check(Key.LEFT)) 	_turret.x -= 2;
			if (Input.check(Key.RIGHT)) _turret.x += 2;
			if (Input.check(Key.UP)) 	_turret.y -= 2;
			if (Input.check(Key.DOWN))	_turret.y += 2;
			if (Input.check(Key.SPACE))	_turret.shoot();
			
			super.update();
		}
		
	}

}