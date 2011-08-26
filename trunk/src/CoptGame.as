package  
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Data;
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
		
		public var copter:Copter;
		public var rocks:Rocks;
		public var explode:Explode;
		public var hud:HUD;
		
		private var starLayer1:Starfield;
		private var starLayer2:Starfield;
		private var _pause:Pause;
		private var start:Start;
		private var blackBox:BlackBox;
		
		private var _t:int = 0;
		
		private var _shaker:Shaker;
		private var _firstRun:Boolean;
		private var _turret:Turret;
		private var _ball:Entity;
		private var _gameMode:String;
		private var _curtains:Curtains;
		
		public function CoptGame() 
		{
			_gameMode = GameMode.INVADERS;
			
			//starLayer1 = new Starfield(1, 0.3, 26); addGraphic(starLayer1);
			//starLayer2 = new Starfield(2, 0.6, 13); addGraphic(starLayer2);
			
			copter = new Copter(); add(copter);
			rocks = new Rocks(); add(rocks);
			explode = new Explode(); addGraphic(explode);
			
			if (_gameMode == GameMode.INVADERS)
			{
/*				_turret = new Turret(copter);
				add(_turret);*/
			}
			else 
			{
				_ball = new Ball(rocks);
				add(_ball);
			}
			
			hud = new HUD(copter); add(hud);
			
			_shaker = new Shaker();
			
			start = new Start();
			add(start);
			
			_pause = new Pause(); 
			_pause.visible = false;
			add(_pause); 
			
			_curtains = new Curtains();
			add(_curtains);
			_curtains.open();
			
			bringToFront(hud);
		}
		
		override public function update():void 
		{	
			if (CoptGame.pauseMode) {
				if (Input.mousePressed && test.canClick)
				{
					_pause.visible = false;
					CoptGame.pauseMode = false;
				}
				return;
			} else {
				FP.camera.y = FP.clamp(copter.y - FP.screen.width * 0.5, 0, FP.screen.width * 0.75);
				if (started)
				{
					_t++;
					if (_t % 2 == 0) HUD.score ++;
					
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
					start.visible = false;
					started = true;
					//music.loop();
				}
				
				_shaker.update();
				
				super.update();
			}
		}
		
		public function stopGame():void
		{
			_pause.visible = true;
			CoptGame.pauseMode = true;
		}
		
		public function fatality():void
		{
			_shaker.shake();
			
			_curtains.close();
			
			explode.blast(copter.centre);
			rocks.makeHole(copter.centre);
		}

		public function reset():void
		{
			CoptGame.clickable = true;
			start.visible = true;
			copter.reset();
			rocks.reset();
			if (_turret) _turret.reset();
			
			if (HUD.score > HUD.best) {
				HUD.best = HUD.score;
				
				Data.writeInt("best", HUD.best);
				Data.save("score");
			}
			HUD.score = 0;
		}
	}
}