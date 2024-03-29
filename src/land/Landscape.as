package land
{
	import draw.*;

	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Landscape extends Entity implements IMoveable
	{
		public static const PIECE_WIDTH:int = FP.width * 4;
		public static const PIECE_DOUBLE_WIDTH:int = FP.width * 8;
		public static const PIECE_HEIGHT:int = FP.height * 2;
		
		public static const INIT_SPEED:Number = 3;
		private var _maxSpeed:int = 10;
		
		private var _frame:BitmapData;
		private var _frameRect:Rectangle;
		private var _dest:Point = new Point(0, 0);
		
		private var _cur:int = 0;
		private var _pieces:Vector.<BitmapData>;
		private var _pieceRect:Rectangle;
		
		private var _tempShift:Number;
		private var _shiftRect:Rectangle;
		private var _threshold:int;
		private var _mergeMatrix:Matrix;
		
		private var _pencil:Pencil;
		private var _hole:Shape = new Shape();
		
		private var _vx:Number = INIT_SPEED;
		
		private var _prevShift:int;
		private var _deltaShift:int = 0;
		
		private var _land:Image;
		
		public function Landscape()
		{
			_frame = new BitmapData(FP.width, PIECE_HEIGHT, true, Pencil.BLACK);
			_frameRect = new Rectangle(0, 0, FP.width, PIECE_HEIGHT);
			
			_pieces = new Vector.<BitmapData>(3);
			for (var i:int = 0; i < _pieces.length; i++)
			{
				_pieces[i] = new BitmapData(PIECE_DOUBLE_WIDTH, PIECE_HEIGHT, true, Pencil.BLACK);
			}
			_pieceRect = new Rectangle(0, 0, PIECE_WIDTH, PIECE_HEIGHT);
			
			_shiftRect = _frameRect.clone();
			_tempShift = _shiftRect.x;
			_prevShift = _shiftRect.x;
			_threshold = PIECE_WIDTH + FP.width;
			_mergeMatrix = new Matrix(1, 0, 0, 1, PIECE_WIDTH, 0);
			
			_land = new Image(_frame);
			graphic = _land;
			
			_pencil = new Pencil();
			
			reset();
			
			mask = new Pixelmask(_frame);
			type = "land";
			
			layer = Layer.GROUND;
		}
		
		public function reset():void
		{
			_vx = INIT_SPEED;
			
			_pencil.resetStyle();
			_pencil.drawingMode = Level.drawingMode;
			_pencil.drawingMethod = Level.drawingMethod;
			
			_pencil.drawIn(_pieces[_cur], _pieceRect);
			nextPiece();
			
			_shiftRect.x = 0;
			_tempShift = _shiftRect.x;
			_prevShift = int(_shiftRect.x);
			updatePiece();
		}
		
		override public function update():void
		{
			if (GameState.pauseMode) return;
			if (GameState.started || GameState.emulation)
			{
				_tempShift += _vx;
				_shiftRect.x = int(_tempShift);
				
				if (_shiftRect.right > _threshold)
				{
					_tempShift -= PIECE_WIDTH;
					_shiftRect.x = int(_tempShift);
					
					_cur = step(_cur, 1);
					nextPiece();
				}
				
				_deltaShift = _shiftRect.x - _prevShift;
				_prevShift = _shiftRect.x;
				
				updatePiece();
			}
			super.update();
		}
		
		private function updatePiece():void
		{
			_frame.fillRect(_frameRect, Pencil.BLACK);
			_frame.copyPixels(_pieces[_cur], _shiftRect, _dest);
			
			_land.setSource(_frame);
		}
		
		private function nextPiece():void
		{
			var next:int = step(_cur, 1);
			_pencil.drawIn(_pieces[next], _pieceRect);
			_pieces[_cur].draw(_pieces[next], _mergeMatrix);
		}
		
		private function step(val:int, dir:int):int
		{
			val += dir;
			if (val >= _pieces.length)
				val -= _pieces.length;
			return val;
		}
		
		public function makeHole(p:Point, r:int = 15):void 
		{
			_hole.graphics.clear();
			_hole.graphics.beginFill(0);
			_hole.graphics.drawCircle(0, 0, r);
			
			var holeMatrix:Matrix = new Matrix();
			holeMatrix.translate(_shiftRect.x + p.x, p.y);
			_pieces[_cur].draw(_hole, holeMatrix, null, BlendMode.ERASE);
			if (_shiftRect.right > PIECE_WIDTH)
			{
				holeMatrix = new Matrix();
				holeMatrix.translate(_shiftRect.x - PIECE_WIDTH + p.x, p.y);
				_pieces[step(_cur, 1)].draw(_hole, holeMatrix, null, BlendMode.ERASE);
			}
			updatePiece();
		}
		
		public function getPlaceOffset(px:int, dir:int = -1):int
		{
			if (_pencil.drawingMode == DrawingMode.SINGLE && dir > 0) return 0;
			
			var curPiece:BitmapData = _pieces[_cur];
			
			px += _shiftRect.x;
			var sy:int = (dir < 0) ? _pieceRect.bottom - 1 : _pieceRect.top;
			
			var pixel:uint = curPiece.getPixel32(px, sy); 
			while (((pixel >> 24) & 0xFF) > 0) // && sy > 0 TODO: exit from loop condition
			{
				sy += dir;
				pixel = curPiece.getPixel32(px, sy);
			}
			
			return sy;
		}
		
		public function getSafeRect(x:int, distance:int):Rectangle
		{
			var result:Rectangle = new Rectangle(x, 0.0, 0.0, 0.0);
			var i:int = distance;
			var value:int;
			var top:int;
			var bottom:int = 99999999;
			
			while(i > 0)
			{
				value = getPlaceOffset(x, 1);
				if(value > top) top = value;
		
				value = getPlaceOffset(x, -1);
				if(value < bottom) bottom = value;
				
				if(bottom - top < 20)
				{
					i = 0;
				}
				
				--i;
				++x;
				result.width += 1.0;
			}
			
			result.y = top;
			result.height = bottom - top;
			
			return result;
		}
		
		public function stamp(source:BitmapData, pos:Point):void 
		{
			pos.x += _shiftRect.x;
			_pieces[_cur].copyPixels(source, source.rect, pos);
		}
		
		public function increaseSpeed(accelAmount:Number):void 
		{
			_vx += accelAmount;
			if (_vx > _maxSpeed)
				_vx = _maxSpeed;
		}
		
		/* INTERFACE IMoveable */
		
		public function get vx():Number 
		{
			return _vx;
		}
		
		public function set vx(value:Number):void 
		{
			// TODO: запомнить поэтапное увелечяение скорости
			_vx = value;
		}
		
		public function get deltaShift():int 
		{
			if (_deltaShift < 0)
				_deltaShift += PIECE_WIDTH;
			return _deltaShift;
		}
	}

}