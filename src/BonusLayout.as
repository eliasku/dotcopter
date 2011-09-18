package  
{
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class BonusLayout 
	{
		private static const TOP:Number = 0.9;
		private static const MIDDLE:Number = 0.5;
		private static const BOTTOM:Number = 0.1;
		
		static private var _placing:Array = [TOP, MIDDLE, BOTTOM];
		static private var _place:Number;
		
		public static function replace():void
		{
			_place = FP.choose(_placing);
		}
		
		static public function get place():Number 
		{
			return _place;
		}
	}

}