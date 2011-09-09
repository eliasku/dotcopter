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
		
		public var copter:Copter;
		public var scenery:Landscape;
		public var shaker:Shaker;
		public var explode:Explode;
		public var hud:HUD;
		public var curtains:Curtains;
		
		private var _starLayer1:Starfield;
		private var _starLayer2:Starfield;
		private var _pause:Pause;
		private var _start:Start;
		private var _turret:Turret;
		
		private var _t:int = 0;
		
		public function CoptGame() 
		{
			if (_instance) return;
			_instance = this;     
			
			_starLayer1 = new Starfield(1, 0.3, 26); addGraphic(_starLayer1);
			_starLayer2 = new Starfield(2, 0.6, 13); addGraphic(_starLayer2);
			shaker = new Shaker();
			
			scenery = new Landscape();
			add(scenery);
			
			copter = new Copter(); add(copter);
			//_turret = new Turret(copter); add(_turret);
			explode = new Explode(); addGraphic(explode);
			
			_start = new Start(); add(_start);
			_pause = new Pause(); add(_pause); 
			curtains = new Curtains(); add(curtains);
			hud = new HUD(); add(hud);
		}
		
		override public function update():void 
		{	
			if (CoptGame.pauseMode)
			{
				if (Input.mousePressed && test.canClick)
				{
					_pause.visible = false;
					CoptGame.pauseMode = false;
				}
				return;
			} else {
				FP.camera.y = FP.clamp(copter.y - FP.height * 0.5, 0, FP.height);
				if (started)
				{
					_t++;
					if (_t % 2 == 0) HUD.score++;
					
					if (_turret)
					{
						if (_t == 15)
						{
							_t = 0;
							_turret.fire(1);
						}
					}
				} 
				else if (Input.mousePressed && test.canClick && CoptGame.clickable)
				{
					_start.visible = false;
					started = true;
				}
				
				shaker.update();
				super.update();
			}
		}
		
		public function stopGame():void
		{
			_pause.visible = true;
			CoptGame.pauseMode = true;
		}
		
		public function reset():void
		{
			CoptGame.clickable = true;
			_start.visible = true;
			copter.reset();
			
			scenery.reset();
			
			if (_turret) _turret.reset();
			
/*			if (HUD.score > HUD.best) {
				HUD.best = HUD.score;
				
				Data.writeInt("best", HUD.best);
				Data.save("score");
			}*/
			HUD.score = 0;
		}
		
		static public function get instance():CoptGame
		{
			return _instance;
		}
	}
}