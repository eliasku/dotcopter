package
{
	import com.ek.asset.AssetManager;
	import draw.DrawingMode;
	import draw.Pencil;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Background extends Entity
	{		
		private var _gfxList:Graphiclist;
		
		public function Background()
		{
			_gfxList = new Graphiclist();
			
			reset();
			
			graphic = _gfxList;
			
			layer = Layer.BG;
		}
		
		public function reset():void 
		{
			if (_gfxList.count > 0)
				_gfxList.removeAll();
				
			var bg:BitmapData;
			var back:Back;
			
			bg = AssetManager.getBitmapData(Level.background);
			back = new Back(bg, 0.2, 0.0);
			_gfxList.add(back);
			
			if (Level.stars)
			{
				bg = generateStars(26, 0.3);
				back = new Back(bg, 0.2, 0.0);
				_gfxList.add(back);
				
				bg = generateStars(13, 0.6);
				back = new Back(bg, 0.4, 0.0);
				_gfxList.add(back);
			}
			
			// TODO: insert middle plane if any
			
			bg = mirror(AssetManager.getBitmapData(Level.foreground));
			back = new Back(bg, 1.0, 1.0);
			_gfxList.add(back);
		}
		
		private function mirror(source:BitmapData):BitmapData
		{
			var top:BitmapData = source;
			var bottom:BitmapData = source;
			
			var back:BitmapData = new BitmapData(top.width, top.height * 2, true, Pencil.BLACK);
			
			if (Level.drawingMode == DrawingMode.DOUBLE)
			{
				var matrix:Matrix = new Matrix();
				matrix.rotate(Math.PI);
				matrix.translate(top.width, top.height);
				back.draw(top, matrix);
			}
			
			matrix = new Matrix();
			matrix.translate(0, top.height);
			back.draw(bottom, matrix);
			
			return back;
		}
		
		private function generateStars(num:int, alpha:Number):BitmapData
		{
			var color:uint = (0xFF * alpha) << 24 | 0xFFFFFF;
			var stars:BitmapData = new BitmapData(FP.width, FP.height * 2, true, Pencil.BLACK);
			for (var i:int = 0; i < num; i++)
			{
				stars.setPixel32(FP.random * FP.width, FP.random * FP.height * 2, color);
			}
			return stars;
		}
	}
}