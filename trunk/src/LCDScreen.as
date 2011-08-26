package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * @author Ilya.Kuzmichev
	 */
	public class LCDScreen extends Sprite
	{
		private static const COLS:int = 96;
		private static const ROWS:int = 96;
		
		private static const CELL_WIDTH:int = 3;
		private static const CELL_HEIGHT:int = 3;
		
		private static const SPACE_X:int = 1;
		private static const SPACE_Y:int = 1;
		
		private var _backData:BitmapData;
		private var _blurData:BitmapData;
		private var _trails:Array = new Array();
		
		private var _bitmap:Bitmap;
		
		
		
		public function LCDScreen()
		{			
			opaqueBackground = 0x222222;
			scrollRect = new Rectangle(0, 0, COLS*(CELL_WIDTH+SPACE_X), ROWS*(CELL_HEIGHT+SPACE_Y));
			
			_backData = new BitmapData(scrollRect.width, scrollRect.height, true, 0x00);
			_blurData = new BitmapData(scrollRect.width, scrollRect.height, true, 0);
			_bitmap = new Bitmap(_backData, PixelSnapping.NEVER, false);
			
			addChild(_bitmap);
			
			var i:int;
			var offset:int;
			var g:Graphics = graphics;
			g.lineStyle(SPACE_Y, 0);
			while (i < ROWS)
			{
				offset = i*(CELL_HEIGHT+SPACE_X) - 1;
				g.moveTo(0, offset);
				g.lineTo(scrollRect.width, offset);
				++i;
			}
			
			g.lineStyle(SPACE_X, 0);
			i = 0;
			while(i < COLS)
			{
				offset = i*(CELL_WIDTH+SPACE_Y) - 1;
				g.moveTo(offset, 0);
				g.lineTo(offset, scrollRect.height);
				++i;
			}
			
			i = 0;
			while(i < COLS*ROWS)
			{
				_trails[i] = 0.0;
				++i;
			}
		}
			
		public function draw(source:BitmapData, sourceRect:Rectangle):void
		{
			var ba:ByteArray;
			var color:uint;
			var trail:uint;
			var i:int;
			var pixels:int;
			var rc:Rectangle = new Rectangle(0, 0, CELL_WIDTH, CELL_HEIGHT);
			var p:Point = new Point();
			var a:int, r:int, g:int, b:int;
			
			if(!sourceRect) sourceRect = source.rect;
			if(sourceRect.width > COLS) sourceRect.width = COLS;
			if(sourceRect.height > ROWS) sourceRect.height = ROWS;
			
			_backData.lock();
			_blurData.lock();
			source.lock();
			
			_backData.fillRect(_backData.rect, 0x00000000);
			_blurData.fillRect(_blurData.rect, 0x00000000);
			
			ba = source.getPixels(sourceRect);
			ba.position = 0;
			pixels = ba.length / 4;
			
			while(i < pixels)
			{
				//color = ba.readUnsignedInt();
				_trails[i] = color = trailPixel(_trails[i], ba.readUnsignedInt());
			
				rc.x = int(i % COLS)*(CELL_WIDTH+SPACE_X);
				rc.y = int(i / COLS)*(CELL_HEIGHT+SPACE_Y);
				
				
				
				if(((color >> 24) & 0xff) > 0)
				{
					_blurData.fillRect(rc, color);
				}
				
				++i;
			}
			
			//var shape:Shape = new Shape();
			//shape.graphics.beginFill(0x000000, 1.0, );
			//shape.graphics.drawRect(0, 0, _backData.rect.width, _backData.rect.height);
			_backData.draw(_blurData);//, null, null, BlendMode.ADD);
			_blurData.applyFilter(_blurData, _blurData.rect, p, new BlurFilter(4.0, 4.0, BitmapFilterQuality.LOW));
			_backData.draw(_blurData, null, null, BlendMode.ADD);
			_blurData.applyFilter(_backData, _blurData.rect, p, new BlurFilter(8.0, 8.0, BitmapFilterQuality.LOW));
			_backData.draw(_blurData, null, new ColorTransform(1, 1, 1, 0.5), BlendMode.ADD);
			
						
			source.unlock();
			_blurData.unlock();
			_backData.unlock();
		}
		
		private function trailPixel(trail:uint, color:uint):uint
		{
			var ta:int = (trail >> 24) & 0xff;
			var tr:int = (trail >> 16) & 0xff;
			var tg:int = (trail >> 8) & 0xff;
			var tb:int = (trail) & 0xff;
			var ca:int = (color >> 24) & 0xff;
			var cr:int = (color >> 16) & 0xff;
			var cg:int = (color >> 8) & 0xff;
			var cb:int = (color) & 0xff;
			var t:Number = 0.6;
			var inv:Number = 0.0;
			
			//ta = (ta >> 1) | ca;
			//tr = (tr >> 1) | cr;
			//tg = (tg >> 1) | cg;
			//tb = (tb >> 1) | cb;
			
			/*if(ca < ta) ta = int(ta * n);
			else ta = ca;
			
			if(cr < tr) tr = int(tr * n);
			else tr = cr;
			
			if(cg < tg) tg = int(tg * n);
			else tg = cg;
			
			if(cb < tb) tb = int(tb * n);
			else tb = cb;*/
			
			//n = ca / 255.0;
			
			ta = Math.max(int(ta*t+ca*inv), ca);
			tr = Math.max(int(tr*t+cr*inv), cr);
			tg = Math.max(int(tg*t+cg*inv), cg);
			tb = Math.max(int(tb*t+cb*inv), cb);
			//tr = Math.max(int(cr*n)+int(tr), cr);
			//tg = Math.max(int(cg*n)+int(tg), cg);
			//tb = Math.max(int(cb*n)+int(tb), cb);
			//tr = Math.max(int(cr*n)+int(tr*b), cr);
			//tg = Math.max(int(cg*n)+int(tg*b), cg);
			//tb = Math.max(int(cb*n)+int(tb*b), cb);
			
			return ((ta & 0xff) << 24) | ((tr & 0xff) << 16) | ((tg & 0xff) << 8)| ((tb & 0xff));
		}
	}
}
