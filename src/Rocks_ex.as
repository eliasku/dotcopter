package  
{
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
		private var _lim:int = GameSize.X3;
		private var _firstRun:Boolean = true;
		
		private var _blockTimer:int = 0;
		private var _blockAmt:int = GameSize.X3_4;
		private var _blockLim:int = GameSize.X1_2;
		
		private var _invader:Invader = new Invader();
		private var _blockPoint:Point = new Point();
		
		private var _hole:Shape = new Shape();
		
		private var _color:uint = 0;
		
		public function Rocks()
		{
			reset();
			type = "rock";
		}
		
		public function reset():void
		{
			_blockAmt = GameSize.X3_4;
			_t = 0;
			_lim = GameSize.X3;
			_firstRun = true;
			drawRocks(_firstRun);
			graphic = new Image(_rocks);
		}
		
		override public function update():void 
		{
			if (CoptGame.pauseMode) return;
			if (CoptGame.started)
			{
				_blockTimer++;
				if (_blockTimer == _blockAmt) {
					_blockTimer = 0;
					
					if (!_firstRun)
					{
						if (_blockAmt > _blockLim) _blockAmt -= STEP;
					}
					
					for (var sy:int = 0; sy < GameSize.X1; sy++)
					{
						if (_rocks.getPixel32(GameSize.X1, sy) == 0)
						{
							//_rocks.fillRect(new Rectangle(GameSize.X1-1, sy + 3 + FP.rand(GameSize.X3_4 - BLOCK_H - 6), BLOCK_W, BLOCK_H), WHITE);
							
							_blockPoint.x = GameSize.X1 + 2; 
							_blockPoint.y = sy + 6 + FP.rand(GameSize.X3_4 - (12 + 12)); // _invader.height
							
							makeHole(_blockPoint.add(_invader.centre));
							
							_invader.deploy(_rocks, _blockPoint);
							
							break;
						}
					}
				}
				
				_rocks.scroll( -STEP, 0);
				_t += STEP;
				if (_t == _lim) {
					_t = 0;
					if (_firstRun) {
						_firstRun = false;
						_lim = GameSize.X4;
					}
					drawRocks();
				}
				graphic = new Image(_rocks);
			}
			super.update();
		}
		
		public function getFreeSpace():int
		{
			for (var sy:int = 0; sy < GameSize.X1; sy++)
			{
				if (_rocks.getPixel32(GameSize.X1, sy) == 0)
				{
					break;
				}
			}
			return sy;
		}

		public function makeHole(p:Point, r:int = 15):void 
		{
			_hole.graphics.clear();
			_hole.graphics.beginFill(0);
			_hole.graphics.drawCircle(0, 0, r);
			
			var holeMatrix:Matrix = new Matrix();
			holeMatrix.translate(p.x, p.y);
			_rocks.draw(_hole, holeMatrix, null, BlendMode.ERASE);
			graphic = new Image(_rocks);
		}
		
		private function drawRocks(firstRun:Boolean = false):void {
			
			var buffer:BitmapData;
			
			var rect:Rectangle = new Rectangle(0, 0, GameSize.X1, GameSize.X3);
			var p:Point = new Point();
			
			if (!firstRun) {
				buffer = new BitmapData(GameSize.X1, GameSize.X3, true, BLACK);
				buffer.copyPixels(_rocks, rect, p);
			}
			
			_offX = (firstRun) ? 0 : FP.width - 1;
			_rocks = new BitmapData((firstRun) ? GameSize.X4 : GameSize.X5, GameSize.X3, true, BLACK);
			if (!firstRun)
				_rocks.copyPixels(buffer, rect, p);
			
			Draw.setTarget(_rocks);
			
			setPoints(0, GameSize.X2, 1);
			trace(_color);
			setPoints(GameSize.X2, GameSize.X4, -1);
			trace(_color);
			
			//_rocks.floodFill(GameSize.X1 + 1, 1, WHITE);
			//_rocks.floodFill(GameSize.X1 + 1, GameSize.X3 - 1, WHITE);
			
			mask = new Pixelmask(_rocks);
		}
		
		private function setPoints(sx:int, ex:int, dir:int = 1):void
		{
			_points = [];
			_points[0] = { x:sx + _offX, y:GameSize.X3_4 };
			_points[1] = { x:ex + _offX, y:GameSize.X3_4 };
			
/*			if (dir == 1)
			{
				Draw.line(_points[0].x, GameSize.X1_2 + _points[0].y, _points[1].x, GameSize.X1_2 + _points[1].y, WHITE);
				//_rocks.fillRect(new Rectangle(_points[0].x, GameSize.X1_2 + _points[0].y, GameSize.X2, GameSize.X1_2), WHITE);
			} else {
				Draw.line(_points[0].x, _points[0].y - GameSize.X1_4, _points[1].x, _points[1].y - GameSize.X1_4, WHITE);
				//_rocks.fillRect(new Rectangle(_points[0].x, 0, GameSize.X2, GameSize.X1_2), WHITE);
			}*/
			
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
				// верхняя часть
				Draw.line(_points[i - 1].x, _points[i - 1].y - GameSize.X1_4, _points[i].x, _points[i].y - GameSize.X1_4, WHITE);
				// нижняя часть
				Draw.line(_points[i - 1].x, GameSize.X1_2 + _points[i - 1].y, _points[i].x, GameSize.X1_2 + _points[i].y, WHITE);
			}
			
			var end:int;
			
			var tx:int = sx;
			while (tx <= ex)
			{
				end = getLineEnd(tx);
				Draw.line(tx, 0, tx, end+1, _color);
				_color++;
				tx++;
			}
			
			if (dir == 1) {
				//_rocks.floodFill(_points[0].x + GameSize.X1, GameSize.X1_2 + _points[0].y - 1, WHITE);
			} else {
				//_rocks.floodFill(_points[0].x + GameSize.X1_2, _points[0].y - GameSize.X1_4 + 1, WHITE);
				//_rocks.floodFill(_points[0].x + GameSize.X3_2, _points[0].y - GameSize.X1_4 + 1, WHITE);
			}
		}
		
		public function getLineEnd(px:int):int
		{
			for (var sy:int = 0; sy < GameSize.X1; sy++)
			{
				if (_rocks.getPixel32(px, sy) == WHITE)
				{
					break;
				}
			}
			return sy;
		}
	}
}