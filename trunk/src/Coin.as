package  
{
	import flash.geom.Point;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Coin extends Entity 
	{
		private const WIDTH:int = 11;
		private const HEIGHT:int = 11;
		
		[Embed(source = '../assets/coin.png')] private const COIN:Class;
		
		private var _coin:Spritemap;
		private var _offset:int;
		
		private var _terrain:Landscape;
		
		private var _pos:Point = new Point();
		private var _place:Number;

		public function Coin() 
		{
			_terrain = CoptGame.instance.terrain;
			
			_coin = new Spritemap(COIN, WIDTH, HEIGHT);
			_coin.add("spin", [0, 1, 2, 3, 4, 5], 5);
			graphic = _coin;
			
			_coin.play("spin");
			
			reset();
			
			setHitboxTo(_coin);
			type = "coin";
			
			layer = ZSort.COPTER;
			
			_place = BonusLayout.place;
		}
		
		override public function update():void 
		{
			if (CoptGame.started && !CoptGame.pauseMode)
			{
				x -= _terrain.vx;
				y = _terrain.getPlaceOffset(x + _coin.width * 0.5) - _coin.height - _offset;
				
				if (x + _coin.width < 0)
				{
					destroy();
				}
				super.update();
			}
		}
		
		public function destroy():void
		{
			world.recycle(this);
			reset();
		}
		
		private function reset():void 
		{
			_place = BonusLayout.place;
			
			x = FP.width;
			_offset = (_terrain.spaceGap - _coin.height * 2) * _place;
			y = _terrain.getPlaceOffset(x + _coin.width * 0.5) - _coin.height - _offset;
		}
	}

}