package  
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Ease;

	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */  
	public class Explode extends Emitter 
	{
		public static const SMALL:String = "small";
		
		private var _particle:BitmapData;
		
		public function Explode()
		{
			_particle = new BitmapData(15, 15, true, 0x00);
			_particle.setPixel32(7, 7, 0xffffffff);
			_particle.applyFilter(_particle, _particle.rect, new Point(), new GlowFilter(0xffffff, 1.0, 3.0, 3.0, 8, 3));
			super(_particle);
			
			newType("big", [0]);
			// fixed time stamp 18, 12 = 0.6, 0.4
			setMotion("big", 0, 8, 18, 360, 24, 12, Ease.expoOut);
			setAlpha("big", 1.0, 0.5); 
			
			newType("small", [0]);
			// fixed time stamp 9, 6 = 0.3, 0.2
			setMotion("small", 0, 15, 12, 360, 5, 3, Ease.quadOut);
			setAlpha("small", 1.0, 0.4);
			
			setVelocity("small", new Point( -3, 0), new Point());
		}
		
		public function blast(p:Point):void
		{
			Shaker.perform();
			
			for (var i:int = 0; i < 80; i++)
			{
				emit("big", p.x, p.y);
			}
		}
		
		public function burst(p:Point):void
		{
			for (var i:int = 0; i < 20; i++)
			{
				emit("small", p.x, p.y);
			}
		}
		
		public function detonate(type:String, pos:Point, num:int):void
		{
			resetColor(type);
			for (var i:int = 0; i < num; i++)
			{
				emit(type, pos.x, pos.y);
			}
		}
		
		private function resetColor(type:String):void 
		{
			var color:uint = FP.getColorHSV(FP.random, 1, 1);
			setColor(type, color, color);
		}
	}

}