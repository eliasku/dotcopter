package
{
	import bonus.Coin;
	import com.ek.asset.AssetManager;
	import com.ek.audio.AudioLazy;
	import com.ek.audio.Music;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	
	/**
	 * ...
	 * @author Gleb Volkov 
	 */
	public class Copter extends Entity
	{
		public const SPRITE_WIDTH:Number = 12;
		public const SPRITE_HEIGHT:Number = 10;
		
		private var _copter:Spritemap;
		private var _copterMask:Pixelmask;
		private var _maskBitmapData:BitmapData;
		private var _dummy:Image;
		
		public var lifes:int;
		
		private var _vy:Number = 0;
		private var _ay:Number = -0.35;
		private var _gravity:Number = 0.2;
		private var _maxUp:Number = 2;
		private var _maxDown:Number = 2.5;
		
		private var boost:Boolean = false;
		private var amt:Number = 0.05;
		
		private var fraged:Boolean = false;
		private var fragTime:int = 0;
		private var fragAmt:int = 10;
		private var fragLim:int = 3;
		
		private var _t:int = 0;
		private var _godTime:int = -1;
		
		private var _game:CoptGame;
		private var _centre:Point = new Point();
		
		private var _upLim:int = 0;
		private var _downLim:int = Landscape.PIECE_HEIGHT;
		private var _screen:LCDScreen;
		private var _grainStep:Number;
		
		private var _chLiftUp:SoundChannel;
		private var _chLiftDown:SoundChannel;
		
		private var _pilot:IPilotage;
		
		public function Copter()
		{
			_game = CoptGame.instance;
			_screen = LCDScreen.instance;
			
			x = FP.width * 0.3;
			
			_copter = new Spritemap(AssetManager.getBitmapData("gfx_copter"), SPRITE_WIDTH, SPRITE_HEIGHT);
			_copter.add("fly", [0, 1, 2, 3, 4], 2, true);
			_copter.play("fly");
			_copter.centerOrigin();
			graphic = _copter;
			
			// TODO: insert in Spritemap render
			var dummyBitmapData:BitmapData = new BitmapData(SPRITE_WIDTH, SPRITE_HEIGHT, true, 0);
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0xFFFFFF;
			dummyBitmapData.draw(_copter.source, null, ct);
			_dummy = new Image(dummyBitmapData);
			_dummy.centerOrigin();
			
			var size:int = Math.ceil(Math.sqrt(_copter.width * _copter.width + _copter.height * _copter.height));
			_maskBitmapData = new BitmapData(size, size, true, 0);
			var offset:Point = new Point(size * 0.5, size * 0.5);
			_copterMask = new Pixelmask(_maskBitmapData, -offset.x, -offset.y);
			_copter.render(_maskBitmapData, offset, FP.zero);
			
			mask = _copterMask;
			
			type = "copter";
			
			layer = Layer.HERO;
			
			_chLiftUp = AudioLazy.loop("sfx_lift_up");
			_chLiftDown = AudioLazy.loop("sfx_lift_down");
			
			reset();
		}
		
		override public function update():void
		{
			if (GameState.pauseMode) return;
			if (GameState.started || GameState.emulation)
			{
				if (_pilot.controlUp)
				{
					boost = true;
					AudioLazy.setVolume(_chLiftUp, 0.2);
					AudioLazy.setVolume(_chLiftDown, 0.0);
				}
				if (_pilot.controlDown)
				{
					boost = false;
					AudioLazy.setVolume(_chLiftUp, 0.0);
					AudioLazy.setVolume(_chLiftDown, 0.2);
				}
				
				_vy += (boost) ? _ay : _gravity;
				if (_vy > _maxDown) _vy = _maxDown;
				if (_vy < -_maxUp) _vy = -_maxUp;
				
				rotateCopter();
				
				_t++;
				
				if (lifes < _pilot.maxLifes)
					_game.effects.trail.smoke(centre, lifes, _pilot.maxLifes);
				
				updateGod();
				
				if (!isGod())
				{
					if (collide("land", x, y))
					{
						dodge();
					}
					
					var bullet:Bullet = collide("bullet", x, y) as Bullet;
					if (bullet)
					{
						bullet.destroy();
						damage();
					}
					
				}
				
				var coin:Coin = collide("coin", x, y) as Coin;
				if (coin)
				{
					AudioLazy.playAt("sfx_coin_collect", coin.centerX, coin.centerY, 0.2);
					world.remove(coin);
				}
				
				y += _vy;
				
				if (isGod())
				{
					var up:int =  _game.terrain.getPlaceOffset(centre.x, 1);
					var down:int = _game.terrain.getPlaceOffset(centre.x, -1);
					
					if (y + 8 > down)
						y = down - 8;
					if (y - 8 < up)
						y = up + 8;
				}
				
				if (y - 2 < _upLim)
					y = _upLim + 2;
				if (y + 10 > _downLim)
					y = _downLim - 10;
					
				if (GameState.emulation)
				{
					_pilot.update(centre);
				}
			}
			
			if (fraged)
			{
				fragTime++;
				if (fragTime == fragAmt)
				{
					fragTime = 0;
					fraged = false;
					this.visible = false;
					fatality();
				}
			}
			
			super.update();
		}
		
		private function rotateCopter(k:Number = 4):void 
		{
			_copter.angle = -_vy * k;
			
			// updatePixelMask
			_maskBitmapData.fillRect(_maskBitmapData.rect, 0);
			FP.point.x = _maskBitmapData.width * 0.5;
			FP.point.y = _maskBitmapData.height * 0.5;
			_copter.render(_maskBitmapData, FP.point, FP.zero);
		}
		
		private function dodge():void
		{
			var up:int = _game.terrain.getPlaceOffset(centre.x, 1);
			var down:int = _game.terrain.getPlaceOffset(centre.x, -1);
			var middle:int = (up + down) * 0.5;
			
			if (y + 5 > middle)
			{
				// вниз
				if (_vy > 0)
					_vy *= -1;
			}
			else
			{
				// вверх
				if (_vy < 0)
					_vy *= -1;
			}
			
			damage();
		}
		
		public function destroy():void
		{
			GameState.started = false;
			GameState.active = false;
			
			Music.getMusic("sfx_tune").stop();
			
			AudioLazy.setVolume(_chLiftUp, 0.0);
			AudioLazy.setVolume(_chLiftDown, 0.0);
			
			AudioLazy.playAt("sfx_explosion", centre.x, centre.y);
			
			godMode(-1);
			
			fraged = true;
		}
		
		public function reset():void
		{
			_pilot = (GameState.emulation) ? new AutoPilot(this) : new Pilot(this);
			
			if (fragAmt > fragLim)
				fragAmt--;
				
			_t = 0;
			visible = true;	
			
			_copter.angle = 0;
			
			AudioLazy.setVolume(_chLiftUp, 0.0);
			AudioLazy.setVolume(_chLiftDown, 0.0);
			
			var up:int = _game.terrain.getPlaceOffset(centre.x, 1);
			var down:int = _game.terrain.getPlaceOffset(centre.x, -1);
			
			y = up + (down - up) * 0.5;
			_vy = 0;
			
			if (isGod()) godMode(-1);
			
			if (_game.hud) _game.hud.resetHearts();
			lifes = _pilot.maxLifes;
		}
		
		public function changePilot():void
		{
			_pilot = (GameState.emulation) ? new AutoPilot(this) : new Pilot(this);
		}
		
		public function damage():void
		{
			if (!GameState.emulation)
			{
				lifes--;
				_game.hud.changeHearts(-1);
			}
			
			if (lifes == 0)
			{
				destroy();
			}
			else
			{
				AudioLazy.playAt("sfx_kick", centre.x, centre.y);
				
				_game.effects.explode.detonate("small", centre, 25);
				_game.terrain.makeHole(centre, 10);
				Shaker.perform(0.02, 6);
				
				godMode();
			}
		}
		
		private function fatality():void
		{
			_game.terrain.makeHole(centre);
			
			_game.effects.explode.blast(centre);
			
			_game.curtains.close();
		}
		
		private function updateGod():void
		{
			if (isGod())
			{
				if (_godTime > 0)
				{
					_godTime--;
					if (_godTime == 0)
						_godTime = -1;
				}
				
				if (_godTime < 0)
					godMode(-1);
				else
				{
					_dummy.angle = _copter.angle;
					graphic = (_t % 4 == 0) ? _dummy : _copter;
					
					_screen.grainDepth -= _grainStep;
				}
			}
		}
		
		private function godMode(duration:int = 60):void
		{
			_godTime = duration;
			if (_godTime < 0)
			{
				_screen.grainDepth = LCDScreen.NORMAL_GRAIN;
				
				graphic = _copter;
			}
			else
			{
				_screen.grainDepth = LCDScreen.HITTED_GRAIN;
				_grainStep = 6.0 * LCDScreen.DELTA_GRAIN / _godTime;
			}
		}
		
		private function isGod():Boolean
		{
			return _godTime >= 0;
		}
		
		public function get centre():Point
		{
			_centre.x = x + 6;
			_centre.y = y + 5;

			return _centre;
		}
		
		public function get pilot():IPilotage 
		{
			return _pilot;
		}

		public function get vy():Number
		{
			return _vy;
		}
	}
}