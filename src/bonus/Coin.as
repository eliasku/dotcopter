package bonus 
{
	import com.ek.asset.AssetManager;
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
		private const STEP:Number = 0.15;
		private const AMPLITUDE:Number = 4;
		
		private var _halfWidth:int;
		private var _doubleHeight:int;
		
		private var _coin:Image;
		
		private var _offset:int;
		
		private var _terrain:Landscape;
		
		private var _t:Number;
		private var _ty:Number;
		
		public function Coin() 
		{
			_terrain = CoptGame.instance.terrain;
			
			_coin = new Image(AssetManager.getBitmapData("gfx_coin"));
			_halfWidth = _coin.width * 0.5;
			_doubleHeight = _coin.height * 2;
			
			reset();
			graphic = _coin;
			
			setHitboxTo(_coin);
			type = "coin";
			
			layer = ZSort.COPTER;
		}
		
		override public function update():void 
		{
			if (GameState.started && !GameState.pauseMode)
			{
				x -= _terrain.deltaShift;
				
				_ty = _terrain.getPlaceOffset(x + _halfWidth) - _coin.height - _offset;
				y = _ty + Math.sin(_t += STEP) * AMPLITUDE;
				
				if (x + _coin.width < 0)
				{
					destroy();
				}
				super.update();
			}
		}
		
		public function destroy():void 
		{
			reset();
			if (world) world.recycle(this);
		}
		
		private function reset():void 
		{
			_t = 0;
			
			x = FP.width;	
			
			_offset = (_terrain.spaceGap - _doubleHeight) * BonusLayout.place;
			y = _ty = _terrain.getPlaceOffset(x + _halfWidth) - _coin.height - _offset;
		}
	}

}