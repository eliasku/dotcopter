package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Benchmark extends Sprite 
	{
		private var _begin:Number;
		private var _end:Number;
		
		public function Benchmark() 
		{
			init();
		}
		
		private function init():void 
		{
			var p:Point = new Point(50, 50);
			var newP:Point;
			var angle:Number = 45;
			var distance:Number = 10;
			var i:int;
			
			_begin = getTimer();
			for (i = 0; i < 1000000; i++) 
			{
				p.offset(20, 20);
			}
			_end = getTimer();
			trace("First case: " + (_end - _begin) + " ms");
			
			var px:Number;
			var py:Number;
			_begin = getTimer();
			for (i = 0; i < 1000000; i++) 
			{
				px += 20;
				py += 20;
			}
			_end = getTimer();
			trace("Second case: " + (_end - _begin) + " ms");
		}
		
	}

}