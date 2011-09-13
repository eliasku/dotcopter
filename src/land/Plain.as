package land 
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Plain implements ITerrain 
	{
		private var _maxHeight:int;
		private var _points:Vector.<Point>;
		
		private var _segments:int;
		private var _roughness:int;
		private var _screenOffset:int;
		
		public function Plain() 
		{
			// default params
			_maxHeight = FP.halfHeight * 0.5;
			_segments = 4;
			_roughness = 10;
			_screenOffset = FP.halfHeight * 1;
		}
		
		/* INTERFACE land.ITerrain */
		
		public function generate(rect:Rectangle):Vector.<Point> 
		{
			var partSize:int = int(rect.width / _segments);
			for (var i:int = 0; i < _segments; i++) 
			{
				_points = (i == 0) ? setPoints(0, partSize) : _points.concat(setPoints(i * partSize , partSize));
			}
			return _points;
		}
		
		private function setPoints(sx:Number, dx:int):Vector.<Point> 
		{
			var points:Vector.<Point> = new Vector.<Point>();
			
			var hillStartY:Number = (_points) ? _points[_points.length - 1].y : 0;
			var hillSlices:Number = dx / _roughness;
			
			var randomHeight:Number = _maxHeight * 0.5 + FP.random * _maxHeight;
			if (_points)
				hillStartY -= randomHeight;
			
			var hillPoint:Point;
			for (var i:int = 0; i <= hillSlices; i++)
			{
				hillPoint = new Point(sx + i * _roughness, hillStartY + randomHeight * Math.cos(2 * Math.PI / hillSlices * i));
				points.push(hillPoint);
			}
			hillStartY = hillStartY + randomHeight;
			
			return points;
		}
		
		public function get maxSize():int 
		{
			return _screenOffset;
		}
		
	}

}