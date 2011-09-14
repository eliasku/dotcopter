package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Ilya.Kuzmichev
	 */
	public class LCDScreen extends Sprite
	{
		private static const BACKGROUND_COLOR:uint = 0xff000000;
		
		private static const CELL_WIDTH:int = 2;
		private static const CELL_HEIGHT:int = 2;
		
		private static const SPACE_X:int = 1;
		private static const SPACE_Y:int = 1;
		
		private var _cols:int;
		private var _rows:int;
		private var _size:Rectangle;
		
		private var _bufferBitmap:Bitmap;
		
		private var _buffer:BitmapData;
		private var _intermediate:BitmapData;
		private var _final:BitmapData;
		
		private var _motionBlurEnabled:Boolean = true;
		private var _motionBlurAlpha:Number = 0.4;
		
		private var _grainEnabled:Boolean = true;
		private var _grainDepth:Number = 0.0175;
		private var _grain:BitmapData;
		private var _grainSkip:int;
		
		private var _gridBitmapData:BitmapData;
		private var _gridBitmap:Bitmap;
		private var _legoMode:Boolean;
		
		
		
		public function LCDScreen(columns:int = 96, rows:int = 96)
		{
			initialize(columns, rows);
		}

		private function initialize(columns:int, rows:int):void
		{
			const w:int = columns*(CELL_WIDTH + SPACE_X);
			const h:int = rows*(CELL_HEIGHT + SPACE_Y);
			
			// initialize consts
			_cols = columns;
			_rows = rows;
			_size = new Rectangle(0, 0, w, h);
			
			// setup display
			opaqueBackground = BACKGROUND_COLOR;
			//scrollRect = _size;
			//cacheAsBitmap = true;
			
			// create buffers
			_buffer = new BitmapData(_cols, _rows, false, 0);
			_intermediate = new BitmapData(_cols, _rows, false, 0);
			_final = new BitmapData(_cols, _rows, false, 0);
			_grain = new BitmapData(_cols, _rows, false, 0);
			
			_bufferBitmap = new Bitmap(_final, PixelSnapping.NEVER, false);
			_bufferBitmap.scaleX = CELL_WIDTH + SPACE_X;
			_bufferBitmap.scaleY = CELL_HEIGHT + SPACE_Y;
			
			addChild(_bufferBitmap);
			
			// create grid
			
			_gridBitmapData = new BitmapData(w, h, true, 0x00000000);
			_gridBitmap = new Bitmap(_gridBitmapData, PixelSnapping.NEVER, false);
			addChild(_gridBitmap);
			_gridBitmap.alpha = 0.5;
			
			redrawGrid();
		}
		
		private function redrawGrid():void
		{
			const w:int = _cols*(CELL_WIDTH + SPACE_X);
			const h:int = _rows*(CELL_HEIGHT + SPACE_Y);
			const gridColor:uint = BACKGROUND_COLOR;
			var i:int;
			var rc:Rectangle = new Rectangle();
			
			_gridBitmapData.lock();
			_gridBitmapData.fillRect(_gridBitmapData.rect, 0x00000000);
			
			rc.height = 1;
			if(_legoMode) rc.height += 1;
			rc.width = w;
			rc.x = 0;
			
			for(i = 0; i < _rows; ++i)
			{
				rc.y = (i+1)*(CELL_HEIGHT+SPACE_X) - 1;
				_gridBitmapData.fillRect(rc, gridColor);
			}
			
			rc.height = h;
			rc.width = 1;
			if(_legoMode) rc.width += 1;
			rc.y = 0;
			
			for(i = 0; i < _cols; ++i)
			{
				rc.x = (i+1)*(CELL_WIDTH+SPACE_Y) - 1;
				_gridBitmapData.fillRect(rc, gridColor);
			}
			
			_gridBitmapData.unlock();
		}
		
		public function get screenWidth():int
		{
			return _size.width;
		}
		
		public function get screenHeight():int
		{
			return _size.height;
		}

		public function draw(source:BitmapData, rect:Rectangle):void
		{
			if(!source)
			{
				_buffer.fillRect(_buffer.rect, BACKGROUND_COLOR);
				return;
			}
			
			if(!rect) rect = source.rect;
			if(rect.width > _cols) rect.width = _cols;
			if(rect.height > _rows) rect.height = _rows;
			
			var p:Point = new Point();
			var ct:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, _motionBlurAlpha);
			
			_final.lock();
			_buffer.lock();
			_intermediate.lock();
			source.lock();
			
			
			if(_motionBlurEnabled)
			{
				_intermediate.copyPixels(source, source.rect, p);
				_buffer.draw(_intermediate, null, ct);
				_final.copyPixels(_buffer, _buffer.rect, p);
			}
			else
			{
				_final.copyPixels(source, rect, p);
			}
				
			if(_grainEnabled && _grainDepth > 0.0)
			{
				_grain.lock();
				
				if(_grainSkip > 0)
				{
					_grain.noise(_t*30.0, 0, _grainDepth*255, 7, true);
					_grainSkip = 0;
				}
				else
				{
					_grainSkip = 1;
				}
				
				_final.draw(_grain, null, null, BlendMode.ADD);
				
				_grain.unlock();
			}
			
			_final.unlock();
			_buffer.unlock();
			_intermediate.unlock();
			source.unlock();
			
			_t += 0.1;
			_gridBitmap.alpha = 0.5+0.5*Math.sin(_t*0.05);
		}
		
		private static var _t:Number = 0.0; 
		
		public function get motionBlurAlpha():Number
		{
			return _motionBlurAlpha;
		}

		public function set motionBlurAlpha(value:Number):void
		{
			if(value < 0.4)
			{
				value = 0.4;
			}
			else if(value > 1.0)
			{
				value = 1.0;
			}
			
			_motionBlurAlpha = value;
		}

		public function get motionBlur():Boolean
		{
			return _motionBlurEnabled;
		}

		public function set motionBlur(value:Boolean):void
		{
			_motionBlurEnabled = value;
		}

		public function get grainEnabled():Boolean
		{
			return _grainEnabled;
		}

		public function set grainEnabled(value:Boolean):void
		{
			_grainEnabled = value;
		}

		public function get grainDepth():Number
		{
			return _grainDepth;
		}

		public function set grainDepth(value:Number):void
		{
			_grainDepth = value;
		}

		public function get legoMode():Boolean
		{
			return _legoMode;
		}

		public function set legoMode(value:Boolean):void
		{
			if(_legoMode != value)
			{
				_legoMode = value;
				redrawGrid();
			}
		}
	}
}
