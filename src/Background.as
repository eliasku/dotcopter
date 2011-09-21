package  
{
	import com.ek.asset.AssetManager;
	import draw.Pencil;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Background
	{
		private var _game:CoptGame;
		
		public function Background() 
		{
			_game = CoptGame.instance;
			
			var bg:BitmapData = AssetManager.getBitmapData("gfx_bg_forest0");
			var back:Back = new Back(bg, 0.2, 0.0);
			_game.addGraphic(back, ZSort.BG);

			bg = generateStars(26);
			back = new Back(bg, 0.2, 0.0);
			back.alpha = 0.3;
			_game.addGraphic(back, ZSort.BG);
			
			bg = generateStars(13);
			back = new Back(bg, 0.4, 0.0);
			back.alpha = 0.6;
			_game.addGraphic(back, ZSort.BG);
			
			bg = mirror(AssetManager.getBitmapData("gfx_bg_forest1"));
			back = new Back(bg, 1.0, 1.0);
			_game.addGraphic(back, ZSort.BG);
		}
		
		private function mirror(source:BitmapData):BitmapData
		{
			var top:BitmapData = source;
			var bottom:BitmapData = source;
			
			var back:BitmapData = new BitmapData(top.width, top.height * 2, true, Pencil.BLACK);
			
			var matrix:Matrix = new Matrix();
			matrix.rotate(Math.PI);
			matrix.translate(top.width, top.height);
			back.draw(top, matrix);
			
			matrix = new Matrix();
			matrix.translate(0, top.height);
			back.draw(bottom, matrix);
			
			return back;
		}
		
		private function generateStars(num:int):BitmapData
		{
			var stars:BitmapData = new BitmapData(FP.width, FP.height * 2, true, Pencil.BLACK);
			for (var i:int = 0; i < num; i++) {
				stars.setPixel32(FP.random * FP.width, FP.random * FP.height * 2, Pencil.WHITE);
			}
			return stars;
		}
	}
}