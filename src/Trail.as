package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Trail extends Emitter 
	{
		public static const MAX_PUFF:int = 20;
		
		private var _particle:BitmapData;
		private var _puffAmount:int;
		
		public function Trail() 
		{
			_particle = new BitmapData(1, 1, true, 0xFF999999);
			super(_particle);
			
			_puffAmount = 0;
			
			newType("step", [0]);
			setAlpha("step");
			setMotion("step", 135, 12, 15, 90, 4, 5);
			setGravity("step", 6, 3);
		}
		
		public function smoke(p:Point):void {
			for (var i:int = 0; i < _puffAmount; i++) 
			{
				emit("step", p.x - 4, p.y);
			}
		}
		
		public function get puffAmount():int 
		{
			return _puffAmount;
		}
		
		public function set puffAmount(value:int):void 
		{
			_puffAmount = value;
		}
		
	}

}