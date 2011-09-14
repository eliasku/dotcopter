package  
{
	import land.Landscape;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
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
		
		private var _starLayer1:Starfield;
		private var _starLayer2:Starfield;
		
		private var _t:int = 0;
		
		public function CoptGame() 
		{
			if (_instance) return;
			_instance = this;     
			
			shaker = new Shaker();
			
			terrain = new Landscape(); add(terrain); 
			
			copter = new Heli(); add(copter); 
			explode = new Explode(); addGraphic(explode);
			
			curtains = new Curtains(); add(curtains);
			hud = new HUD(); add(hud);
			
			var back:Background = new Background(); addGraphic(back, ZSort.BG);
			_starLayer1 = new Starfield(1, 0.3, 26); addGraphic(_starLayer1, ZSort.STARS);
			_starLayer2 = new Starfield(2, 0.6, 13); addGraphic(_starLayer2, ZSort.STARS);
		}
		
		override public function update():void 
		{	
			if (CoptGame.pauseMode)
			{
				if (Input.mousePressed && test.canClick)
				{
					CoptGame.pauseMode = false;
				}
				return;
			} else {
				FP.camera.y = FP.clamp(copter.y - FP.height * 0.5, 0, FP.height);
				if (started)
				{
					_t++;
					if (_t % 2 == 0) HUD.score++;
					//if (_t % 30 == 0) create(Block);
					if (_t % 60 == 0) create(Turret);
				} 
				else if (Input.mousePressed && test.canClick && CoptGame.clickable)
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
			
			// save score
/*			if (HUD.score > HUD.best) {
				HUD.best = HUD.score;
				
				Data.writeInt("best", HUD.best);
				Data.save("score");
			}*/
			HUD.score = 0;
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
			for each (var turret:Block in turrets) 
			{
				turret.destroy();
			}
		}
		
		static public function get instance():CoptGame
		{
			return _instance;
		}
	}
}