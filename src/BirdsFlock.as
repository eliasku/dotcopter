package  
{
	import com.ek.asset.AssetManager;
	import flash.display.Graphics;
	import flash.geom.Point;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class BirdsFlock extends Entity
	{
		private const SPRITE_WIDTH:int = 3;
		private const SPRITE_HEIGHT:int = 3;
		
		private const Y_MIN:int = 0;
		private const Y_MAX:int = 3;
		
		private var _terrain:Landscape;
		
		private var _display:Graphiclist;
		
		private var _formation:Array = new Array(1, -1, 1);
		
		private var _tick:int = 0;
		
		public function BirdsFlock() 
		{
			_terrain = CoptGame.instance.terrain;
			
			_display = new Graphiclist();
			
			for (var i:int = 0; i < _formation.length; i++) 
			{
				addBird(i * SPRITE_WIDTH, (_formation[i] > 0) ? Y_MIN : Y_MAX); //, i%2 != 0);
			}
			
			graphic = _display;
		}
		
		private function addBird(px:int, py:int, invertAnim:Boolean = false):void
		{
			var bird:Spritemap = new Spritemap(AssetManager.getBitmapData("gfx_bird"), SPRITE_WIDTH, SPRITE_HEIGHT);
			var seq:Array = (invertAnim) ? [1, 0] : [0, 1];
			bird.add("fly", seq, 0.1, true);
			bird.play("fly");
			bird.x = px;
			bird.y = py;
			
			_display.add(bird);
		}
		
		override public function update():void 
		{
			super.update();
			
			_tick ++;
			if (_tick % 6 == 0)
			{
				var bird:Graphic;
				for (var i:int = 0; i < _display.count; i++) 
				{
					bird = _display.children[i];
					
					if (_formation[i] > 0) // летим вниз
					{
						if (bird.y < Y_MAX)
							bird.y ++;
						else _formation[i] *= -1;
					}
					else if (_formation[i] < 0) // летим вверх
					{
						if (bird.y > Y_MIN)
							bird.y --;
						else _formation[i] *= -1;
					}
				}
			}
		}
		
	}

}