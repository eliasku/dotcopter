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
		private const STEP:Number = 0.157*2;
		private const AMPLITUDE:Number = 1;
		
		private var _halfWidth:int;
		
		private var _coin:Image;
		private var _terrain:Landscape;
		
		private var _t:Number;
		
		private var _ty:Number;
		private var _px:Number;
		
		private var _place:Number;
		
		public function Coin() 
		{
			_terrain = CoptGame.instance.terrain;
			
			_coin = new Image(AssetManager.getBitmapData("gfx_coin"));
			_halfWidth = _coin.width * 0.5;
			
			reset();
			graphic = _coin;
			
			setHitboxTo(_coin);
			type = "coin";
			
			layer = Layer.ENEMY;
		}
		
		override public function update():void 
		{
			if (GameState.pauseMode) return;
			if (GameState.started || GameState.emulation)
			{
				//_t += STEP;
				x -= _terrain.deltaShift;
				//x = int(_px);
				//y = int(_ty + Math.sin(_t) * AMPLITUDE);
				
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
			
			_px = x = FP.width;
			
			_place = BonusLayout.place;
			var top:int = _terrain.getPlaceOffset(_px + _halfWidth, 1);
			var bottom:int = _terrain.getPlaceOffset(_px + _halfWidth, -1);
			var middle:int = top + (bottom - top) * _place;
			
			y = _ty = middle;// + FP.camera.y;
		}
	}

}