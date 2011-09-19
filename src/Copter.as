package  
{
	import com.ek.audio.AudioLazy;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Copter extends Entity
	{
		public const SPRITE_WIDTH:Number = 10;
		public const SPRITE_HEIGHT:Number = 9;
		
		[Embed(source = '../assets/copter_single.png')] private const HELI:Class;
		[Embed(source = '../assets/copter_mask.png')] private const COPTER_MASK:Class;
		
		public var maxLifes:int = 3;
		public var lifes:int;
		
		private var coptMask:Image;
		private var copt:Image;
		public var _rotor:Image;
		private var playerShip:Graphiclist;
		
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
		
		public function Copter() 
		{
			_game = CoptGame.instance;
			
			x = FP.width * 0.3;
			var down:int = _game.terrain.getPlaceOffset(x + 5);
			y = down - _game.terrain.spaceGap * 0.5;
			
			copt = new Image(HELI);
			_rotor = Image.createRect(9, 1); _rotor.x = 1;
			playerShip = new Graphiclist(copt, _rotor); 
			graphic = playerShip;
			
			coptMask = new Image(COPTER_MASK);
			mask = new Pixelmask(coptMask.source);
			type = "copter";
			
			lifes = maxLifes;
			
		}
		
		override public function update():void
		{
			if (CoptGame.pauseMode) return;
			
			if (CoptGame.started) {
				if (Input.mousePressed) {
					boost = true;
				}
				if (Input.mouseReleased) {
					boost = false;
				}
				
				/*if (boost) {
					if (up.volume < 1) 
						up.volume += amt;
					else 
						up.volume = 1;
				} else {
					if (up.volume > 0)
						up.volume -= amt;
					else 
						up.volume = 0;
				}*/
				
				vy += (boost) ? ay : gravity;
				
				if (vy > maxspeed + 0.5)
					vy = maxspeed + 0.5;
				else if (vy < -maxspeed)
					vy = -maxspeed;
					
				copt.angle = -vy * 5;
				_rotor.angle = -vy * 5;
				// update pixelmask
				coptMask.angle = copt.angle;
				mask = new Pixelmask(coptMask.source);
				
				_t ++;
				
				updateGod();
				
				if (!isGod())
				{
					_rotor.visible = (_t % 2 == 0) ? true : false;
					if (collide("land", x, y))
					{
						dodge();
					}
					if (collide("bullet", x, y))
						damage();
				}
				
				y += vy;
				
				if (isGod())
				{
					var down:int = _game.terrain.getPlaceOffset(x + 5);
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
			
			if (fraged) {
				fragTime++;
				if (fragTime == fragAmt) {
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
			var down:int = _game.terrain.getPlaceOffset(x + 5);
			var up:int = down - _game.terrain.spaceGap;
			
			var middle:int = (up + down) * 0.5;
			if (y + 5 > middle)
			{
				// вниз
				if (vy > 0) vy *= -1;
			}
			else
			{
				// вверх
				if (vy < 0) vy *= -1;
			}
			
			damage();
		}
		
		public function destroy():void
		{	
			CoptGame.started = false;
			CoptGame.clickable = false;
			
			godMode(-1);
			
			fraged = true;
			_rotor.visible = true;
		}
		
		public function reset():void
		{
			if (fragAmt > fragLim) fragAmt--;
			copt.angle = 0;
			_rotor.angle = 0;
			visible = true;
			_rotor.visible = true;
			_t = 0;
			
			var down:int = _game.terrain.getPlaceOffset(x + 5);
			y = down - _game.terrain.spaceGap * 0.5;
			vy = 0;
			
			godMode(-1);
			
			_game.hud.resetHearts();
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
				AudioLazy.play("sfx_kick");
				
				_game.explode.detonate("small", centre, 25);
				_game.terrain.makeHole(centre);
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
				if(_godTime > 0)
				{
					_godTime --;
					if (_godTime == 0)
						_godTime = -1;
				}
				
				if (_godTime < 0)
					godMode(-1);
				else
				{
					visible = (_t % 4 == 0) ? true : false;
					_rotor.visible = true;
				}
			}
		}
		
		private function godMode(duration:int = 60):void
		{
			_godTime = duration;
			if (_godTime < 0)
			{
				visible = true;
			}
		}
		
		private function isGod():Boolean
		{
			return _godTime >= 0;
		}
		
		public function get centre():Point
		{ 
			_centre.x = x + 5;
			_centre.y = y + 5;
			return _centre;
		}
	}
}