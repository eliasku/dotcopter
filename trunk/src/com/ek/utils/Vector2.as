package com.ek.utils 
{
	import flash.geom.Point;

	/**
	 * @author �������������
	 */
	public class Vector2 extends Point
	{
		public function Vector2(x:Number = 0, y:Number = 0)
		{
			super(x, y);
		}
		
		public function distance(other:Point):Number
		{
			const dx:Number = x - other.x;
			const dy:Number = y - other.y;
			
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		public function cloneVector2():Vector2
		{
			return new Vector2(x, y);
		}
		
		public function trunc():void
		{
			x = int(x);
			y = int(y);
		}
		
		static public function getDirection(start:Vector2, end:Vector2):Number
		{
			var dx:Number = start.x - end.x;
			var dy:Number = start.y - end.y;
			var a:Number = -Math.atan2(dy, dx) * 180 / Math.PI  - 180;
			while(a < 0) a += 360;
			return a;
		}
	}
}
