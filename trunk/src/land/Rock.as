package land 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Rock implements ITerrain 
	{
		private var _maxHeight:int;
		private var _reduction:Number;
		private var _roughness:Number;
		
		private var _points:Vector.<Point>;
		
		public function Rock() 
		{
			// default params
			_maxHeight = FP.height * 0.75;
			_reduction = 0.6;
			_roughness = 5;
		}
		
		/* INTERFACE land.ITerrain */
		
		public function generate(rect:Rectangle):Vector.<Point> 
		{
			var halfWidth:int = int(rect.width * 0.5);
			_points = setPoints(0, halfWidth, 1);
			_points = _points.concat(setPoints(halfWidth, rect.width, -1));
			return _points;
		}
		
		private function setPoints(sx:int, ex:int, dir:int = 1):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			var p1:Point = new Point(sx, 0);
			var p2:Point = new Point(ex, 0);
			points[0] = p1;
			points[1] = p2;
			
			var h:Number = _maxHeight * dir;
			var rand:Number;
			
			for (var q:int = 0; q < _roughness; q++)
			{
				h *= _reduction;
				for (var i:int = points.length - 1; i > 0; i--)
				{
					rand = (q > 1) ? FP.random * h : Math.max(FP.random, FP.random) * h;
					
					p1 = points[i];
					p2 = points[i - 1];
					
					points.splice(i, 0, new Point((p1.x - p2.x) * 0.5 + p2.x, (p1.y - p2.y) * 0.5 + p2.y - rand));
				}
			}
			
			return points;
		}
		
		public function get maxSize():int 
		{
			return _maxHeight;
		}
		
	}

}