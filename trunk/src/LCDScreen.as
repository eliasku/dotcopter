package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * @author Ilya.Kuzmichev
	 */
	public class LCDScreen extends Sprite
	{
		private static const CELL_COLOR:uint = 0x000000;
		private static const SPACE_COLOR:uint = 0x090909;
		
		private static const CELL_WIDTH:int = 3;
		private static const CELL_HEIGHT:int = 3;
		
		private static const SPACE_X:int = 1;
		private static const SPACE_Y:int = 1;
		
		private var _cols:int;
		private var _rows:int;
		
		private var _buffer:BitmapData;
		private var _screen:BitmapData;
		private var _trails:Vector.<uint>;
		private var _bitmap:Bitmap;
		
		private var _size:Rectangle;
		
		public function LCDScreen(columns:int = 96, rows:int = 96)
		{
			_cols = columns;
			_rows = rows;
			_size = new Rectangle(0, 0, _cols*(CELL_WIDTH+SPACE_X), _rows*(CELL_HEIGHT+SPACE_Y));
			
			opaqueBackground = CELL_COLOR;
			//scrollRect = _size;
			//cacheAsBitmap = true;
			
			_buffer = new BitmapData(_size.width, _size.height, true, 0);
			_screen = new BitmapData(_size.width, _size.height, true, 0);
			_bitmap = new Bitmap(_screen, PixelSnapping.NEVER, false);
			
			addChild(_bitmap);
			
			var i:int;
			var offset:int;
			var g:Graphics = graphics;
			
			g.lineStyle(SPACE_Y, SPACE_COLOR);
			while (i < _rows)
			{
				offset = i*(CELL_HEIGHT+SPACE_X) - 1;
				g.moveTo(0, offset);
				g.lineTo(_size.width, offset);
				++i;
			}
			
			g.lineStyle(SPACE_X, SPACE_COLOR);
			i = 0;
			while(i < _cols)
			{
				offset = i*(CELL_WIDTH+SPACE_Y) - 1;
				g.moveTo(offset, 0);
				g.lineTo(offset, _size.height);
				++i;
			}
			
			//graphics.clear();
		
			_trails = new Vector.<uint>(_cols*_rows, true);
			i = 0;
			while(i < _cols*_rows)
			{
				_trails[i] = 0x0;
				++i;
			}
		}
			
		public function draw(source:BitmapData, sourceRect:Rectangle):void
		{
			if(!sourceRect) sourceRect = source.rect;
			if(sourceRect.width > _cols) sourceRect.width = _cols;
			if(sourceRect.height > _rows) sourceRect.height = _rows;
			
			_buffer.lock();
			_screen.lock();
			source.lock();
			
			_buffer.fillRect(_buffer.rect, 0x00000000);
			
			var bytes:ByteArray = source.getPixels(sourceRect);
			bytes.position = 0;
			
			var i:int, j:int, k:int;
			const rc:Rectangle = new Rectangle(0, 0, CELL_WIDTH, CELL_HEIGHT);
			
			const spx:int = CELL_WIDTH + SPACE_X;
			const spy:int = CELL_HEIGHT + SPACE_Y;
			
			const t:Number = 0.65;
			
			var trail:uint, ta:uint, tr:uint, tg:uint, tb:uint;
			var color:uint, ca:uint, cr:uint, cg:uint, cb:uint;
			
			while(j < _rows)
			{
				rc.x = 0.0;
				i = 0;
				while(i < _cols)
				{
					trail = _trails[k];
					color = bytes.readUnsignedInt();
					
					ta = t * ((trail >> 24) & 0xff);
					tr = t * ((trail >> 16) & 0xff);
					tg = t * ((trail >> 8) & 0xff);
					tb = t * (trail & 0xff);
					
					ca = (color >> 24) & 0xff;
					cr = (color >> 16) & 0xff;
					cg = (color >> 8) & 0xff;
					cb = (color & 0xff);
					
					if(ca > ta) ta = ca;
					if(cr > tr) tr = cr;
					if(cg > tg) tg = cg;
					if(cb > tb) tb = cb;
					
					color = (ta << 24) | (tr << 16) | (tg << 8) | tb;
					
					_trails[k] = color;
					
					if(ta > 0)
						_buffer.fillRect(rc, color);
					
					rc.x += spx;
					
					++k;
					++i;
				}
				
				rc.y += spy;
				
				++j;
			}
			
			
			
			var p:Point = new Point();
			const blurSize:Number = 4.0;
			_screen.applyFilter(_buffer, _buffer.rect, p, new BlurFilter(blurSize, blurSize, BitmapFilterQuality.LOW));
			_screen.copyPixels(_buffer, _buffer.rect, p, null, null, true);
			
			source.unlock();
			_screen.unlock();
			_buffer.unlock();
		}
		
		public function get screenWidth():int
		{
			return _size.width;
		}
		
		public function get screenHeight():int
		{
			return _size.height;
		}
	}
}
