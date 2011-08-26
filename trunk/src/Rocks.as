package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Rocks extends Entity 
	{	
		public static const BLACK:uint = 0x00000000;
		public static const WHITE:uint = 0xFFFFFFFF;
		
		private const STEP:int = 2;
		
		private var _hite:Number;
		private var _points:Array;
		
		private var _offX:int;
		private const BLOCK_W:int = 3;
		private const BLOCK_H:int = 18;
		
		private var _rocks:BitmapData;
		private var _t:int = 0;
		private var _lim:int = GameSize.X4;
		
		private var _blockTimer:int = 0;
		private var _blockAmt:int = GameSize.X3_4;
		private var _blockLim:int = GameSize.X1_2;
		
		private var _invader:Invader = new Invader();
		private var _blockPoint:Point = new Point();
		
		private var _hole:Shape = new Shape();
		
		private var _color:uint = 0;
		
		private var _rockData:Vector.<BitmapData>;
		private var _rockDataRect:Rectangle;
		
		private var _frameRect:Rectangle;
		private var _shiftRect:Rectangle;
		private var _mergeMatrix:Matrix;
		
		private var _cur:int = 0;
		private var _dest:Point = new Point();
		
		private var _dx:Number = 3;
		
		[Embed(source = '../assets/heightMap.png')] private const HEIGHT_MAP:Class;
		private var _heightMap:BitmapData;
		
		private var _colorData:BitmapData;
		
		public function Rocks()
		{
			_heightMap = FP.getBitmap(HEIGHT_MAP);
			
			_colorData = new BitmapData(GameSize.X4, GameSize.X3, true);
			var colorBox:Shape = new Shape();
			colorBox.graphics.beginBitmapFill(_heightMap);
			colorBox.graphics.drawRect(0, 0, GameSize.X4, GameSize.X3);
			colorBox.graphics.endFill();
			_colorData.draw(colorBox);
			
			var i:int;
			var data:BitmapData;
			
			_frameRect = new Rectangle(0, 0, GameSize.X1, GameSize.X3);
			_shiftRect = _frameRect.clone();
			_rockDataRect = new Rectangle(0, 0, GameSize.X4 + GameSize.X1, GameSize.X3);
			_mergeMatrix = new Matrix(1, 0, 0, 1, GameSize.X4, 0);
			
			_rockData = new Vector.<BitmapData>(3);
			for (i = 0; i < _rockData.length; i++) 
			{
				_rockData[i] = new BitmapData(GameSize.X8, GameSize.X3, true, BLACK);
			}
			
			_cur = 0;
			drawRock(_rockData[_cur]);
			generateNextRock();
			
			_rocks = new BitmapData(GameSize.X1, GameSize.X3, true, BLACK);
			updateRock(_shiftRect);
			
			graphic = new Image(_rocks);
			type = "rock";
		}
		
		private function generateNextRock():void
		{
			var next:int = step(_cur, 1);
			drawRock(_rockData[next]);
			_rockData[_cur].draw(_rockData[next], _mergeMatrix);
		}
		
		private function updateRock(shift:Rectangle):void
		{
			_rocks.fillRect(_frameRect, BLACK);
			_rocks.copyPixels(_rockData[_cur], shift, _dest);
			mask = new Pixelmask(_rocks);
		}
		
		private function drawRock(target:BitmapData):void
		{
			target.fillRect(target.rect, BLACK);
			Draw.setTarget(target);
			setPoints(0, GameSize.X2, 1);
			setPoints(GameSize.X2, GameSize.X4, -1);
		}

		override public function update():void 
		{
			if (CoptGame.pauseMode) return;
			if (CoptGame.started)
			{
				_shiftRect.x += _dx;
				if (_shiftRect.right > _rockDataRect.right)
				{
					_shiftRect.x -= GameSize.X4;
					
					_cur = step(_cur, 1);
					generateNextRock();
				}
				
				updateRock(_shiftRect);
				graphic = new Image(_rocks);
			}
			super.update();
		}
		
		private function step(val:int, dir:int):int
		{
			val += dir;
			if (val >= _rockData.length) 
			{
				val -= _rockData.length;	
			}
			return val;
		}
		
		public function reset():void
		{
			_blockAmt = GameSize.X3_4;
		}

		public function makeHole(p:Point, r:int = 15):void 
		{
			_hole.graphics.clear();
			_hole.graphics.beginFill(0);
			_hole.graphics.drawCircle(0, 0, r);
			
			var holeMatrix:Matrix = new Matrix();
			holeMatrix.translate(_shiftRect.x + p.x, p.y);
			_rockData[_cur].draw(_hole, holeMatrix, null, BlendMode.ERASE);
			if (_shiftRect.right > GameSize.X4)
			{
				holeMatrix = new Matrix();
				holeMatrix.translate(_shiftRect.x - GameSize.X4 + p.x, p.y);
				_rockData[step(_cur,1)].draw(_hole, holeMatrix, null, BlendMode.ERASE);
			}
			graphic = new Image(_rocks);
		}

		private function setPoints(sx:int, ex:int, dir:int = 1):void
		{
			_points = [];
			_points[0] = { x:sx, y:GameSize.X3_4 };
			_points[1] = { x:ex, y:GameSize.X3_4 };
			
			_hite = GameSize.X1_2 * dir;
			var p1:Object, p2:Object;
			var x:Number, y:Number, rand:Number;
			for (var q:int = 0; q < 5; q++) 
			{
				_hite *= 0.6;
				for (var i:int = _points.length - 1; i > 0; i--)
				{
					p1 = _points[i];
					p2 = _points[i-1];
					x = (p1.x - p2.x) * 0.5 + p2.x;
					rand = (q > 1) ? FP.random * _hite : Math.max(FP.random, FP.random) * _hite;
					y = (p1.y - p2.y) * 0.5 + p2.y - rand;
					_points.splice(i, 0, { x:x, y:y } );
				}
			}
			
			for (i = 1; i < _points.length; i++)
			{
				Draw.line(_points[i - 1].x, _points[i - 1].y - GameSize.X1_4, _points[i].x, _points[i].y - GameSize.X1_4, WHITE);
				Draw.line(_points[i - 1].x, GameSize.X1_2 + _points[i - 1].y, _points[i].x, GameSize.X1_2 + _points[i].y, WHITE);
			}
			
			var color:uint;
			var tx:int = sx;
			while (tx <= ex)
			{
				//color = int(Math.random() * 0xFFFFFF);
				Draw.line(tx, 0, tx, getRockMargin(tx, 1), WHITE);
				Draw.line(tx, getRockMargin(tx, -1), tx, GameSize.X3, WHITE);
				tx++;
			}
			
			//colorizeRock();
		}
		
		private function colorizeRock():void 
		{
			Draw.target.draw(_colorData, null, null, BlendMode.MULTIPLY);
		}
		
		public function getRockMargin(px:int, dir:int):int
		{
			var sy:int = (dir > 0) ? 0 : GameSize.X3;
			while (Draw.target.getPixel32(px, sy) != WHITE)
			{
				sy += dir;
			}
			return sy;
		}
	}
}