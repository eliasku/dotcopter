package draw
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import land.ITerrain;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import land.Landscape;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Pencil
	{
		public static const BLACK:uint = 0x00000000;
		public static const WHITE:uint = 0xFFFFFFFF;
		
		private static const TOP:int = 1;
		private static const BOTTOM:int = -1;
		
		private var _target:BitmapData;
		private var _mode:String;
		private var _source:ITerrain;
		private var _points:Vector.<Point>;
		
		public function setDrawingSource(source:Class):void
		{
			_source = new source as ITerrain;
		}
		
		public function drawIn(target:BitmapData, targetRect:Rectangle):void
		{
			_target = target;
			
			target.fillRect(target.rect, BLACK);
			Draw.setTarget(_target);
			
			_points = _source.generate(targetRect);
			
			if (_mode == DrawingMode.DOUBLE)
				drawPart(TOP);
			drawPart(BOTTOM);
		}

		private function drawPart(dir:int):void
		{
			var sy:int = (dir > 0) ? _target.rect.top : _target.rect.bottom;
			
			for (var i:int = 1; i < _points.length; i++)
			{
				Draw.line(_points[i - 1].x, sy + dir*_source.maxSize - _points[i - 1].y, _points[i].x, sy + dir*_source.maxSize - _points[i].y, WHITE);
				Draw.line(_points[i - 1].x, sy + dir*_source.maxSize - _points[i - 1].y, _points[i-1].x, sy, WHITE);
			}
			
			var sp:Point = _points[0];
			var ep:Point = _points[_points.length - 1];
			
			//Draw.line(sp.x, sy, ep.x, sy, WHITE);
			Draw.line(ep.x, sy + dir*_source.maxSize - ep.y, ep.x, sy, WHITE);
			
			var line:int = sy + dir;
			for (i = 1; i < _points.length; i++)
			{
				// лишний второй чек
				if (_target.getPixel32(_points[i].x, line) == WHITE && _target.getPixel32(_points[i - 1].x, line) == WHITE)
				{
					_target.floodFill(_points[i].x - 1, line, WHITE);
				}
			}
		}
		
		public function set drawingMode(mode:String):void 
		{
			_mode = mode;
		}
		
/*		private function getDrawMargin(px:int, dir:int):int
		{
			var sy:int = (dir > 0) ? 0 : _targetRect.bottom;
			while (_target.getPixel32(px, sy) != WHITE)
			{
				sy += dir;
			}
			if (_target.getPixel32(px, sy + dir) == WHITE)
				sy += dir;
			return sy;
		}*/
	}
}