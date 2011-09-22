package  
{
	import draw.Pencil;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Invader
	{
		public var centre:Point;
		
		private const INVADER_WIDTH:int = 6;
		private const INVADER_HEIGHT:int = 6;
		private const MULT:Number = 2;
		
		private var _source:BitmapData;
		private var _sourceRect:Rectangle;
		
		private var _copy:BitmapData;
		private var _copyRect:Rectangle;
		private var _copyMatrix:Matrix;

		public function Invader() 
		{
			FP.randomizeSeed();
			
			_source = new BitmapData(INVADER_WIDTH, INVADER_HEIGHT, true, Pencil.BLACK);
			_sourceRect = new Rectangle(0, 0, INVADER_WIDTH, INVADER_HEIGHT);
			
			var newW:Number = _source.width * MULT;
			var newH:Number = _source.height * MULT;
			
			_copy = new BitmapData(newW, newH, true, Pencil.BLACK);
			_copyRect = new Rectangle(0, 0, newW, newH);
			
			_copyMatrix = new Matrix();
			_copyMatrix.scale(MULT, MULT);
			
			centre = new Point(INVADER_WIDTH * MULT * 0.5, INVADER_HEIGHT * MULT * 0.5);
		}
		
		private function generate():void
		{
			var color:uint = Pencil.WHITE;
			_source.lock();
			_source.fillRect(_sourceRect, Pencil.BLACK);
			var span:int = Math.ceil(INVADER_WIDTH * 0.5);
			for (var y:int = 0; y < INVADER_HEIGHT; ++y)
			{
				var r:int = FP.rand(32768); // 2^15
				for (var x:int = 0; x < span; ++x)
				{
					if (r & (1 << x))
					{
						_source.setPixel32(x, y, color);
						_source.setPixel32(INVADER_WIDTH - 1 - x, y, color);
					}
				}
			}
			_source.unlock();
			
			_copy.fillRect(_copyRect, Pencil.BLACK);
			_copy.draw(_source, _copyMatrix);
		}

		public function deploy(target:BitmapData, p:Point):void
		{
			generate();
			target.copyPixels(_copy, _copy.rect, p, null, null, true);
		}
		
		// BITMAP UTIL
/*		private function scale(bmd:BitmapData, mult:Number):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(mult, mult);
			
			var data:BitmapData = new BitmapData(bmd.width * mult,  bmd.height * mult, true, Fractals.BLACK);
			data.draw(bmd, matrix);
			
			return data;
		}*/
	
	}
}