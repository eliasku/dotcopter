package  
{
	import draw.Pencil;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Block extends Entity 
	{
		private var _terrain:Landscape;
		
		private const WIDTH:int = 4;
		private const HEIGHT:int = 12;
		
		private var _block:Image;
		private var _place:int;
		
		private var _pos:Point = new Point();
		
		public function Block() 
		{
			_terrain = CoptGame.instance.terrain;
			
			_block = Image.createRect(WIDTH, HEIGHT, Pencil.RED);
			graphic = _block;
			
			reset();
			
			setHitboxTo(_block);
			type = "block";
			
			layer = 3;
		}
		
		override public function update():void 
		{
			if (GameState.started && !GameState.pauseMode)
			{
				x -= _terrain.vx;
				y = _terrain.getPlaceOffset(x + _block.width * 0.5) - _block.height - _place;
				
				if (x + _block.width < 0)
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
			x = FP.width;
			//_place = (_terrain.spaceGap - _block.height * 2) * FP.random;
			y = _terrain.getPlaceOffset(x + _block.width * 0.5) - _block.height - _place;
		}
		
		public function clone():BitmapData
		{
			return _block.source;
		}
		
		public function get pos():Point 
		{
			_pos.x = x;
			_pos.y = y;
			return _pos;
		}
		
	}

}