package draw
{
	import com.ek.asset.AssetManager;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
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
		public static const RED:uint = 0xFFFF0000;
		public static const BLUE:uint = 0xFF0000FF;
		
		private static const TOP:int = 1;
		private static const BOTTOM:int = -1;
		
		private var _target:BitmapData;
		private var _mode:String;
		private var _method:ITerrain;
		private var _points:Vector.<Point>;
		
		private var _pattern:BitmapData;
		private var _contour:BitmapData;
		private var _ground:Shape = new Shape();
		
		public function Pencil()
		{
			resetStyle();
		}
		
		public function set drawingMethod(method:Class):void
		{
			_method = new method as ITerrain;
		}
		
		public function drawIn(target:BitmapData, targetRect:Rectangle):void
		{
			_target = target;
			
			target.fillRect(target.rect, BLACK);
			Draw.setTarget(_target);
			
			_points = _method.generate(targetRect);
			
			if (_mode == DrawingMode.DOUBLE) drawPart(TOP);
			drawPart(BOTTOM);
		}
		
		public function resetStyle():void 
		{
			_pattern = AssetManager.getBitmapData(Level.tile);
			_contour = AssetManager.getBitmapData(Level.outline);
		}
		
		private function drawPart(dir:int):void
		{
			var sy:int = (dir > 0) ? _target.rect.top : _target.rect.bottom;
			
			var sp:Point = _points[0];
			var ep:Point = _points[_points.length - 1];
			
			_ground.graphics.clear();
			_ground.graphics.beginBitmapFill(_pattern);
			_ground.graphics.moveTo(sp.x, sy);
			
			for (var i:int = 0; i < _points.length; i++)
			{
/*				Draw.line(_points[i - 1].x, sy + dir*_source.maxSize - _points[i - 1].y, _points[i].x, sy + dir*_source.maxSize - _points[i].y, WHITE);
				Draw.line(_points[i - 1].x, sy + dir*_source.maxSize - _points[i - 1].y, _points[i-1].x, sy, WHITE);*/
				_ground.graphics.lineTo(_points[i].x, sy + dir * _method.maxSize - _points[i].y);
			}
			_ground.graphics.lineTo(ep.x, sy);
			_ground.graphics.lineTo(sp.x, sy);
			_ground.graphics.endFill();
			
			_ground.graphics.lineStyle(_contour.height);
			
			var matrix:Matrix = new Matrix();
			if (dir > 0) matrix.rotate(Math.PI);
			
			_ground.graphics.lineBitmapStyle(_contour, matrix);
			_ground.graphics.moveTo(sp.x, sy + dir * _method.maxSize - sp.y);
			for (i = 1; i < _points.length; i++)
			{
				_ground.graphics.lineTo(_points[i].x, sy + dir * _method.maxSize - _points[i].y);
			}
			
			//Draw.line(sp.x, sy, ep.x, sy, WHITE);
			//Draw.line(ep.x, sy + dir*_source.maxSize - ep.y, ep.x, sy, WHITE);
			
/*			var line:int = sy + dir;
			for (i = 1; i < _points.length; i++)
			{
				if (_target.getPixel32(_points[i].x, line) == WHITE && _target.getPixel32(_points[i - 1].x, line) == WHITE)
				{
					_target.floodFill(_points[i].x - 1, line, WHITE);
				}
			}*/
			
			_target.draw(_ground);
			
/*			for (i = 1; i < _points.length; i++)
			{
				Draw.linePlus(_points[i - 1].x, sy + dir*_source.maxSize - _points[i - 1].y, _points[i].x, sy + dir*_source.maxSize - _points[i].y, 0xFF00FF00, 1, 2);
			}*/
		}
		
		public function set drawingMode(mode:String):void 
		{
			_mode = mode;
		}
		
		public function get drawingMode():String 
		{
			return _mode;
		}
	}
}