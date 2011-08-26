package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Explode extends Emitter 
	{
		private var particle:BitmapData;
		
		public function Explode() 
		{
			particle = new BitmapData(1, 1, true, 0xFFFFFFFF);
			super(particle);
			
			newType("big", [0]);
			// fixed time stamp 18, 12 = 0.6, 0.4
			setMotion("big", 0, 8, 18, 360, 24, 12, Ease.expoOut);
			setAlpha("big", 1.0, 0.5); 
			
			newType("small", [0]);
			// fixed time stamp 9, 6 = 0.3, 0.2
			setMotion("small", 0, 4, 9, 360, 12, 6, Ease.sineOut);
			setAlpha("small", 1.0, 0.5); 
		}
		
		public function blast(p:Point):void
		{
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
		
	}

}