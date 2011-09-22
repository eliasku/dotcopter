package draw
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import land.ITerrain;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Perlin implements ITerrain
	{
		private var _maxSize:int;
		
		private const SMOOTH_COLOR:uint=0x808080;
		private var _smooth:Sprite;
		private var _smoothPercentage:Number = 0.8;
		
		private var _sbd:BitmapData;
		private var _bbd:BitmapData;
		private var _soffs:Array;
		private var _boffs:Array;
		
		private var _wavelength:Number = 0.3;
		private var _multi:Number = .03;
		private var _amplitude:Number = 0.5;
		private var _speed:Number = 1;
		private var _steps:Number = 50;
		
		public function Perlin()
		{
			// default params
			_maxSize = FP.height * 0.5;
			
			_sbd = new BitmapData(_steps, 1, false);
			_bbd = new BitmapData(_steps, 1, false);
			_soffs = [new Point(0, 0), new Point(0, 0)];
			_boffs = [new Point(0, 0), new Point(0, 0)];
			
			_smooth = new Sprite();
			var smoothmatrix:Matrix = new Matrix();
			smoothmatrix.createGradientBox(_steps, 1);
			var ratioOffset:uint = _smoothPercentage * 128;	
			_smooth.graphics.beginGradientFill("linear", [SMOOTH_COLOR, SMOOTH_COLOR, SMOOTH_COLOR, SMOOTH_COLOR], [1,0,0,1], [0,ratioOffset,255-ratioOffset,255], smoothmatrix);
			_smooth.graphics.drawRect(0, 0, _steps, 1);
			_smooth.graphics.endFill(); 
		}
		
		/* INTERFACE land.ITerrain */
		
		public function get maxSize():int
		{
			return _maxSize;
		}
		
		public function generate(rect:Rectangle):Vector.<Point>
		{
			return setPoints(0, rect.width, _steps);
		}
		
		private function setPoints(sx:int, dx:int, steps:int):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			
			var seed1:uint = FP.random * 100;
			var seed2:uint = FP.random * 100;
			
			_soffs[0].x += (steps / 100) * _speed;
			_soffs[0].y += (steps / 100) * _speed;
			_sbd.perlinNoise(steps / 20, steps / 20, 1, seed1, false, true, 7, true, _soffs);
			
			var calculatedWavelength:Number = steps * _wavelength;
			var calculatedSpeed:Number = (calculatedWavelength * .1) * _speed;
			_boffs[0].x -= calculatedSpeed;
			_boffs[0].y += calculatedSpeed;
			_bbd.perlinNoise(calculatedWavelength, calculatedWavelength, 1, seed2, false, true, 7, true, _boffs);
			
			if (_smoothPercentage > 0)
			{
			   var drawMatrix:Matrix = new Matrix();
			   drawMatrix.scale(steps / _smooth.width, 1);
			   _sbd.draw(_smooth, drawMatrix); 
			   _bbd.draw(_smooth, drawMatrix); 
			}
			
			var p:Point = new Point();	
			var soff:Number, boff:Number;
			for (var i:int = 0; i < steps; i++)
			{
				soff = (_sbd.getPixel(i, 0) - 0x808080) / 0xffffff * dx * _multi;
				boff = (_bbd.getPixel(i, 0) - 0x808080) / 0xffffff * dx * _amplitude;
				
				p.x = sx + dx / (steps - 1) * i;
				p.y = 0 - soff - boff;
				
				points.push(p.clone());
			}
			
			return points;
		}
	}
}