package  
{
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import ui.HUD;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class CoptGame extends World
	{
		public static const SCREEN_SIZE:int = 96; 
		
		public static var clickable:Boolean = true;
		public static var started:Boolean = false;
		public static var pauseMode:Boolean = false;
		
		private static var _instance:CoptGame;
		
		public var copter:Heli;
		public var terrain:Landscape;
		public var shaker:Shaker;
		public var explode:Explode;
		public var hud:HUD;
		public var curtains:Curtains;
		public var trail:Trail;
		
		private var _dt:int = 0;
		private var _accelTime:Number;
		
		private var _accelDist:int = 100;
		private var _accelAmount:Number = 0.5;
		private var _t:int = 0;
		
		
		public function CoptGame() 
		{
			if (_instance) return;
			_instance = this;     
			
			shaker = new Shaker();
			
			terrain = new Landscape(); add(terrain); 
			
			copter = new Heli(); add(copter); 
			trail = new Trail(); addGraphic(trail, ZSort.COPTER);
			explode = new Explode(); addGraphic(explode, ZSort.BOOM);
			
			curtains = new Curtains(); add(curtains);
			hud = new HUD(); add(hud);
			
			new Background();
			
			_accelTime = _accelDist / terrain.vx;
			BonusLayout.replace();
		}
		
		override public function update():void 
		{	
			if (CoptGame.pauseMode)
			{
				if (Input.mousePressed || Input.pressed(Key.SPACE))
				{
					CoptGame.pauseMode = false;
				}
				return;
			} 
			else
			{
				FP.camera.y = FP.clamp(copter.y - FP.height * 0.5, 0, FP.height);
				if (started)
				{
					_t++;
					if (_t % 2 == 0) HUD.score++;
					
					if (_t % 5 == 0) create(Coin);
					if (_t % 60 == 0) BonusLayout.replace();
					
					//if (_t % 30 == 0) create(Block);
					if (_t % 60 == 0) create(Turret);
					
					_dt++;
					if (_dt >= _accelDist)
					{
						_dt = 0;
						terrain.vx += _accelAmount;
						_accelDist = terrain.vx * _accelTime;
						
						SoundManager.play("speed_up");
					}
				} 
				else if (Input.mousePressed || Input.pressed(Key.SPACE))
				{
					started = true;
				}
				
				shaker.update();
				super.update();
			}
		}
		
		public function stopGame():void
		{
			CoptGame.pauseMode = true;
		}
		
		public function reset():void
		{
			CoptGame.clickable = true;
			
			terrain.reset();
			copter.reset();
			
			resetBlocks();
			resetTurrets();
			
			resetCoins();
			
			_t = 0;
			_dt = 0;
			_accelDist = 100;
			_accelTime = _accelDist / terrain.vx;
			
			// save score
/*			if (HUD.score > HUD.best) {
				HUD.best = HUD.score;
				
				Data.writeInt("best", HUD.best);
				Data.save("score");
			}*/
			HUD.score = 0;
			
			BonusLayout.replace();
		}
		
		private function resetBlocks():void 
		{
			var blocks:Vector.<Block> = new Vector.<Block>();
			getClass(Block, blocks);
			for each (var block:Block in blocks) 
			{
				block.destroy();
			}
		}
		
		private function resetTurrets():void 
		{
			var turrets:Vector.<Turret> = new Vector.<Turret>();
			getClass(Turret, turrets);
			for each (var turret:Turret in turrets) 
			{
				turret.destroy();
			}
		}
		
		private function resetCoins():void 
		{
			var coins:Vector.<Coin> = new Vector.<Coin>();
			getClass(Coin, coins);
			for each (var coin:Coin in coins) 
			{
				coin.destroy();
			}
		}
		
		static public function get instance():CoptGame
		{
			return _instance;
		}
	}
}