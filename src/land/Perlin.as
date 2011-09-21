package land
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Perlin implements ITerrain
	{
		private var _maxSize:int;
		
		private var sbd:BitmapData;
		private var bbd:BitmapData;
		private var soffs:Array;
		private var boffs:Array;
		
		private var seed1:uint;
		private var seed2:uint;
		
		private var calculatedWavelength:Number;
		private var calculatedSpeed:Number;
		
		private var _wavelength:Number = .3;
		private var _speed:Number = 1;
		private var _steps:Number;
		
		private var _points:Vector.<Point> = new Vector.<Point>;
		
		public function Perlin()
		{
			// default params
			_maxSize = FP.height * 0.5;
			
			_steps = 50;
			
			sbd = new BitmapData(_steps, 1, false);
			bbd = new BitmapData(_steps, 1, false);
			soffs = [new Point(0, 0), new Point(0, 0)];
			boffs = [new Point(0, 0), new Point(0, 0)];
		}
		
		/* INTERFACE land.ITerrain */
		
		public function get maxSize():int
		{
			return _maxSize;
		}
		
		public function generate(rect:Rectangle):Vector.<Point>
		{
			_points = setPoints(0, rect.width);
			
			return _points;
		}
		
		private function setPoints(sx:int, ex:int, dir:int = 1):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			var p1:Point = new Point(sx, 0);
			var p2:Point = new Point(ex, 0);
			points[0] = p1;
			points[1] = p2;
			
			randomizeSeeds();
			
			//dx = endX - startX;
			//dy = endY - startY;
			//len = Math.sqrt(dx * dx + dy * dy);
			
			soffs[0].x += (_steps / 100) * _speed;
			soffs[0].y += (_steps / 100) * _speed;
			sbd.perlinNoise(_steps / 20, _steps / 20, 1, seed1, false, true, 7, true, soffs);
			
			calculatedWavelength = _steps * _wavelength;
			calculatedSpeed = (calculatedWavelength * .1) * _speed;
			boffs[0].x -= calculatedSpeed;
			boffs[0].y += calculatedSpeed;
			bbd.perlinNoise(calculatedWavelength, calculatedWavelength, 1, seed2, false, true, 7, true, boffs);
			
			/*if (smoothPercentage > 0)
			   {
			   var drawMatrix:Matrix = new Matrix();
			   drawMatrix.scale(steps / smooth.width, 1);
			   bbd.draw(smooth, drawMatrix);
			 }*/
			
			return points;
		}
		
		/*public function render():void
		   {
		   holder.graphics.clear();
		   holder.graphics.lineStyle(thickness, _color);
		
		   angle = Math.atan2(endY - startY, endX - startX);
		
		   for (var i:uint = 0; i < _steps; i++)
		   {
		   soff = (sbd.getPixel(i, 0) - 0x808080) / 0xffffff * len * multi2;
		   soffx = Math.sin(angle) * soff;
		   soffy = Math.cos(angle) * soff;
		
		   boff = (bbd.getPixel(i, 0) - 0x808080) / 0xffffff * len * amplitude;
		   boffx = Math.sin(angle) * boff;
		   boffy = Math.cos(angle) * boff;
		
		   tx = startX + dx / (steps - 1) * i + soffx + boffx;
		   ty = startY + dy / (steps - 1) * i - soffy - boffy;
		
		   if (i == 0)
		   holder.graphics.moveTo(tx, ty);
		   holder.graphics.lineTo(tx, ty);
		   }
		 }*/
		
		private function randomizeSeeds():void
		{
			seed1 = Math.random() * 100;
			seed2 = Math.random() * 100;
		}
	
	}

}