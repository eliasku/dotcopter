package  
{
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class GameSize
	{
		public static var X1_4:int;
		public static var X1_2:int;
		public static var X3_4:int;
		public static var X1:int;
		public static var X2:int;
		public static var X3:int;
		public static var X4:int;
		public static var X8:int;
		
		static public function init(size:int = 96):void
		{
			X1_4 = size * 0.25;
			X1_2 = size * 0.5;
			X3_4 = size * 0.75;
			X1 = size * 1;
			X2 = size * 2;
			X3 = size * 3;
			X4 = size * 4;
			X8 = size * 8;
		}
	}

}