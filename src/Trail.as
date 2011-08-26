package  
{
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Trail extends Emitter 
	{
		private var particle:BitmapData;
		private var offY:Array = [ -1, 0, 1];
		
		public function Trail() 
		{
			particle = new BitmapData(1, 1, true, 0xFFFFFFFF);
			super(particle);
			
			newType("step", [0]);
			setAlpha("step", 1, 0);
			setMotion("step", 180, 36, 0.75);
		}
		
		public function step(px:int, py:int):void {
			emit("step", px, py + FP.choose(offY));
		}
		
	}

}