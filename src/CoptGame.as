package
{
	import bonus.BonusLayout;
	import bonus.Coin;

	import land.Landscape;

	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	import ui.HUD;
	import ui.Menu;

	import com.ek.audio.AudioLazy;
	import com.ek.audio.AudioManager;
	import com.ek.audio.Music;

	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class CoptGame extends World
	{
		public var copter:Copter;
		public var terrain:Landscape;
		public var shaker:Shaker;
		public var explode:Explode;
		public var hud:HUD;
		public var curtains:Curtains;
		public var trail:Trail;
		public var bg:Background;
		public var menu:Menu;
		
		private var _dt:int = 0;
		private var _accelTime:Number;
		
		private var _accelDist:int = 100;
		private var _accelAmount:Number = 2.0;
		private var _aceelLimit:int = 11;
		
		private var _dist:int = 0;
		private var _totalDist:int = 1000;
		
		private static var _instance:CoptGame;
		
		public function CoptGame()
		{
			if (_instance)
				return;
			_instance = this;
			
			Level.initialize();
			
			shaker = new Shaker();
			
			terrain = new Landscape();
			add(terrain);
			copter = new Copter();
			add(copter);
			
			trail = new Trail();
			addGraphic(trail, Layer.FX);
			explode = new Explode();
			addGraphic(explode, Layer.FX);
			
			hud = new HUD();
			add(hud);
			curtains = new Curtains();
			add(curtains);
			
			bg = new Background();
			add(bg);
			
			menu = new Menu();
			add(menu);

			_dt = 0;
			_accelDist = 100;
			
			reset();
			
			if (!Music.hasMusic("sfx_tune"))
				Music.add("sfx_tune");
			AudioManager.panorama = FP.width;
			AudioManager.update(0, 0);
		}
		
		override public function update():void
		{
			if (Input.pressed(Key.M))
			{
				AudioManager.muted = !AudioManager.muted;
			}
			
			if (GameState.pauseMode)
			{
				if (Input.mousePressed || Input.pressed(Key.SPACE))
				{
					GameState.pauseMode = false;
				}
				return;
			}
			else
			{
				FP.camera.y = FP.clamp(copter.y - FP.height * 0.5, 0, FP.height);
				if (GameState.started || GameState.emulation)
				{
					_dt++;
					 
					if (Level.coins)
					{
						if (_dt % 5 == 0)
							create(Coin);
						if (_dt % 60 == 0 && !GameState.emulation)
							BonusLayout.replace();
					}
					if (Level.turrets)
					{
						if (_dt % 60 == 0)
							create(Turret);
					}
					
					if (!GameState.emulation)
					{
						if (_dt >= _accelDist && terrain.vx < _aceelLimit)
						{
							_dt = 0;
							
							terrain.vx += _accelAmount;
							
							_accelDist = terrain.vx * _accelTime;
							
							LCDScreen.instance.motionBlurAlpha = 0.8 - 0.4*((terrain.vx-3.0) / 8.0);
							
							AudioLazy.play("sfx_speed_up");
						}
					}
					
					if (!GameState.emulation)
					{
						_dist += terrain.deltaShift;
						HUD.score = int(_dist * 0.1);
						
						if (_dist > _totalDist)
						{
							completeLevel();
						}
					}
				}
				else if ((Input.mousePressed || Input.pressed(Key.SPACE)) && GameState.active)
				{
					GameState.started = true;
					Music.getMusic("sfx_tune").play();
				}
				
				shaker.update();
				super.update();
			}
		}
		
		private function completeLevel():void 
		{
			GameState.emulation = true;
			hud.reset();
			copter.changePilot();
			
			var st:SoundTransform = new SoundTransform();
			st.volume = GameState.emulation ? 0.5 : 1;
			SoundMixer.soundTransform = st;
			
			Music.getMusic("sfx_tune").stop();
		}
		
		public function stopGame():void
		{
			GameState.pauseMode = true;
		}
		
		public function reset():void
		{
			GameState.active = true;
			
			if (!GameState.emulation)
			{
				_dist = 0;
				HUD.score = _dist;
			}
			
			Level.randomize();
			
			hud.reset();
			bg.reset();
			terrain.reset();
			copter.reset();
			
			resetTurrets();
			resetCoins();
			BonusLayout.firstPlace();
			
			_accelTime = _accelDist / terrain.vx;
			
			//save score
			/*if (HUD.score > HUD.best) {
			   HUD.best = HUD.score;
			   Data.writeInt("best", HUD.best);
			   Data.save("score");
			}*/
			HUD.score = 0;
			
			var st:SoundTransform = new SoundTransform();
			st.volume = GameState.emulation ? 0.5 : 1;
			SoundMixer.soundTransform = st;
		}
		
		/*private function resetBlocks():void
		   {
		   var blocks:Vector.<Block> = new Vector.<Block>();
		   getClass(Block, blocks);
		   for each (var block:Block in blocks)
		   {
		   block.destroy();
		   }
		 }*/
		
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