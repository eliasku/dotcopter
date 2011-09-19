package com.ek.utils 
{

	/**
	 * @author �������������
	 */
	public class Vector3 
	{
		public function Vector3(x:Number = 0.0, y:Number = 0.0, z:Number = 0.0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}

		
		public var x:Number;
		public var y:Number;
		public var z:Number;

		public function cloneVector2():Vector2 
		{
			return new Vector2(x, y);
		}

		public function clone():Vector3 
		{
			return new Vector3(x, y, z);
		}
	}
}
