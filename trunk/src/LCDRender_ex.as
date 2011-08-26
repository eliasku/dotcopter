package  
{
	import flash.display.*;
	import flash.geom.*;
	import flash.filters.*;
	/**
	 * Display the BitmapData like a old-school LCD display.
	 */
	public class LCDRender extends Bitmap
	{
		private var _data:BitmapData = new BitmapData(96, 96, true, 0);
		private var _screen:BitmapData = new BitmapData(384, 384, true, 0);
		private var _display:BitmapData = new BitmapData(400, 400, false, 0);
		private var _cls:BitmapData = new BitmapData(400, 400, false, 0);
		private var _matS2D:Matrix = new Matrix(1, 0, 0, 1, 8, 8);
		
		private var _shadow:DropShadowFilter = new DropShadowFilter(4, 45, 0, 0.6, 6, 6);
		//private var _glow:GlowFilter = new GlowFilter(0xffffff, 0.4, 8, 8, 2);
		private var _blur:BlurFilter = new BlurFilter(3, 3, 2);
		
		private var _blured:BitmapData = new BitmapData(384, 384, true, 0);
		
		private var _residueMap:Vector.<Number> = new Vector.<Number>(9216, true);
		private var _toneFilter:uint;
		private var _dotColor:uint;
		private var _residue:Number;
		private var dot:Rectangle = new Rectangle(0,0,3,3);
		private var mat:Matrix = new Matrix();
		
		/**
		 *  Create a new instance of the LCDBitmapOldSkool with setting.
		 *  @param bit The bit count of shades of gray scale. the bit=2 sets 4 shades of gray scale.
		 *  @param backColor The background color of display.
		 *  @dot0Color The color for the pixel of 0.
		 *  @dot0Color The color for the pixel of 1.
		 *  @residue The ratio of residual image for 1 update.
		 */
		function LCDRender(residue:Number = 0.5,
						   backColor:uint = 0xb0c0b0, 
						   dot0Color:uint = 0xb0b0b0, 
						   dot1Color:uint = 0x000000, 
						   bit:int=2) {
			_toneFilter = 0xff00 >> bit;
			_dotColor = dot1Color;
			_cls.fillRect(_cls.rect, backColor);
			_residue = residue;
			for (dot.x=8; dot.x<392; dot.x+=4)
				for (dot.y=8; dot.y<392; dot.y+=4)
					_cls.fillRect(dot, backColor);
			super(_display);
		}
		
		/** 
		 *  Rendering LCD Bitmap.
		 *  @param source Source BitmapData rendering on the old-school LCD display.
		 */
		public function render(src:BitmapData) : void {
			var x:int, y:int, rgb:uint, mask:uint, i:int, gray:int, color:uint, alpha:uint;
			_data.lock();
			_screen.lock();
			_data.fillRect(_data.rect, 0x00000000);
			_data.draw(src, mat, null, null, null, true);
			_screen.fillRect(_screen.rect, 0);
			
			for (i = 0, dot.y = 0, y = 0; y < 96; dot.y += 4, y++)
			{
				for (dot.x = 0, x = 0; x < 96; dot.x += 4, x++, i++) 
				{
					color = rgb = _data.getPixel(x, y);
					alpha = int(((_data.getPixel32(x, y) >> 24) & 0xff));// * _residueMap[i]);
					rgb = ((((rgb>>18)&63)+((rgb>>9)&127)+((rgb>>3)&31)) & _toneFilter) + int(_residueMap[i]);
					mask = rgb & 0x100;
					rgb |= mask - (mask>>8);
					//_residueMap[i] = (rgb&0xff) * _residue;
					//_residueMap[i] = alpha * _residue;
					//alpha = 255 - alpha;
					if (alpha > 0) _screen.fillRect(dot, (alpha << 24) | color);
					
/*					gray = ((_data.getPixel(x, y) & _toneFilter)>>1) + int(_residueMap[i]);
					if (gray > 255) gray = 255;
					_residueMap[i] = gray * _residue;
					if (gray) _screen.fillRect(dot, (gray<<24) | _dotColor);*/

				}
			}
			
			_blured.applyFilter(_screen, _screen.rect, _screen.rect.topLeft, _blur);
			//_screen.applyFilter(_screen, _screen.rect, _screen.rect.topLeft, _blur); //_shadow
			_display.copyPixels(_cls, _cls.rect, _cls.rect.topLeft);
			
			
			_display.draw(_screen, _matS2D, null, BlendMode.ADD);
			_display.draw(_blured, _matS2D, null, BlendMode.ADD);
			
			_data.unlock();
			_screen.unlock();
			
		}
		
/*      
*/
	}
}