package
{
	import bonus.Coin;
	import com.ek.audio.AudioLazy;
	import com.ek.audio.AudioManager;
	import com.ek.audio.Music;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Heli extends Entity
	{
		public const SPRITE_WIDTH:Number = 12;
		public const SPRITE_HEIGHT:Number = 10;
		
		[Embed(source='../assets/heli.png')]
		private const HELI:Class;
		[Embed(source='../assets/heli_mask.png')]
		private const COPTER_MASK:Class;
		
		private var _copterSpriteMap:Spritemap;
		
		public var maxLifes:int = 3;
		public var lifes:int;
		
		private var coptMask:Image;
		private var copt:Image;
		
		private var vy:Number = 0;
		private var ay:Number = -0.35;
		private var gravity:Number = 0.2;
		private var maxspeed:Number = 2;
		
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
		
		public function Heli()
		{
			_game = CoptGame.instance;
			_screen = LCDScreen.instance;
			
			x = FP.width * 0.3;
			
			_copterSpriteMap = new Spritemap(HELI, SPRITE_WIDTH, SPRITE_HEIGHT);
			_copterSpriteMap.add("fly", [0, 1, 2, 3, 4], 2, true);
			graphic = _copterSpriteMap;
			
			_copterSpriteMap.play("fly");
			
			coptMask = new Image(COPTER_MASK);
			mask = new Pixelmask(coptMask.source);
			type = "copter";
			
			layer = ZSort.COPTER;
			
			_chLiftUp = AudioLazy.loop("sfx_lift_up");
			_chLiftDown = AudioLazy.loop("sfx_lift_down");
			
			reset();
		}
		
		override public function update():void
		{
			if (CoptGame.pauseMode)
				return;

			if (CoptGame.started)
			{
				if (Input.mousePressed || Input.pressed(Key.SPACE))
				{
					boost = true;
					
					AudioLazy.setVolume(_chLiftUp, 0.2);
					AudioLazy.setVolume(_chLiftDown, 0.0);
				}
				if (Input.mouseReleased || Input.released(Key.SPACE))
				{
					boost = false;
					
					AudioLazy.setVolume(_chLiftUp, 0.0);
					AudioLazy.setVolume(_chLiftDown, 0.2);
				}
				
				vy += (boost) ? ay : gravity;
				
				if (vy > maxspeed + 0.5)
					vy = maxspeed + 0.5;
				else if (vy < -maxspeed)
					vy = -maxspeed;
				
				_copterSpriteMap.angle = -vy * 4;
				// update pixelmask
				coptMask.angle = _copterSpriteMap.angle;
				mask = new Pixelmask(coptMask.source);
				
				_t++;
				
				if (lifes < maxLifes)
					_game.trail.smoke(centre);
				
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
					
/*					var block:Block = collide("block", x, y) as Block;
					if (block)
					   {
					   _game.terrain.stamp(block.clone(), block.pos);
					
					   block.destroy();
					
					   damage();
					}*/
				}
				
				var coin:Coin = collide("coin", x, y) as Coin;
				if (coin)
				{
					AudioLazy.playAt("sfx_coin_collect", coin.centerX, coin.centerY);
					world.remove(coin);
				}
				
				y += vy;
				
				if (isGod())
				{
					var down:int = _game.terrain.getPlaceOffset(x + 6);
					var up:int = down - _game.terrain.spaceGap;
					
					if (y + 8 > down)
						y = down - 8;
					if (y - 8 < up)
						y = up + 8;
				}
				
				if (y - 2 < _upLim)
					y = _upLim + 2;
				if (y + 10 > _downLim)
					y = _downLim - 10;
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
		
		private function dodge():void
		{
			var down:int = _game.terrain.getPlaceOffset(x + 6);
			var up:int = down - _game.terrain.spaceGap;
			
			var middle:int = (up + down) * 0.5;
			if (y + 5 > middle)
			{
				// вниз
				if (vy > 0)
					vy *= -1;
			}
			else
			{
				// вверх
				if (vy < 0)
					vy *= -1;
			}
			
			damage();
		}
		
		public function destroy():void
		{
			CoptGame.started = false;
			CoptGame.clickable = false;
			
			Music.getMusic("sfx_tune").stop();
			
			AudioLazy.setVolume(_chLiftUp, 0.0);
			AudioLazy.setVolume(_chLiftDown, 0.0);
			
			AudioLazy.playAt("sfx_explosion", centre.x, centre.y);
			
			godMode(-1);
			
			fraged = true;
		}
		
		public function reset():void
		{
			if (fragAmt > fragLim)
				fragAmt--;
				
			_t = 0;
			visible = true;	
			
			_copterSpriteMap.angle = 0;
			
			AudioLazy.setVolume(_chLiftUp, 0.0);
			AudioLazy.setVolume(_chLiftDown, 0.0);
			
			var down:int = _game.terrain.getPlaceOffset(x + 6);
			y = down - _game.terrain.spaceGap * 0.5;
			vy = 0;
			
			if (isGod()) godMode(-1);
			
			if (_game.hud) _game.hud.resetHearts();
			lifes = maxLifes;
		}
		
		public function damage():void
		{
			lifes--;
			_game.hud.changeHearts(-1);
			
			if (lifes == 0)
			{
				destroy();
			}
			else
			{
				_game.trail.puffAmount = int(Trail.MAX_PUFF * (1 - lifes / maxLifes));
				
				//trace("[copter]", "taking damage");
				
				AudioLazy.playAt("sfx_kick", centre.x, centre.y);
				
				_game.explode.detonate("small", centre, 25);
				_game.terrain.makeHole(centre, 10);
				_game.shaker.perform(0.02, 6);
				
				godMode();
			}
		}
		
		private function fatality():void
		{
			_game.terrain.makeHole(centre);
			_game.explode.blast(centre);
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
					visible = (_t % 4 == 0) ? true : false;
					_screen.grainDepth -= _grainStep;
				}
			}
		}
		
		private function godMode(duration:int = 10):void
		{
			_godTime = duration;
			if (_godTime < 0)
			{
				_screen.grainDepth = LCDScreen.NORMAL_GRAIN;
				visible = true;
			}
			else
			{
				_screen.grainDepth = LCDScreen.HITTED_GRAIN;
				_grainStep = LCDScreen.DELTA_GRAIN / _godTime;
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
	}
}