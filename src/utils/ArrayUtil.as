package utils 
{
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class ArrayUtil 
	{
		public static function findLastMatch(arr:Array, match:int):int
		{
			var ind:int = -1;
			for (var i:int = 0; i < arr.length; i++) 
			{
				if (arr[i] == match) ind = i;
			}
			return ind;
		}
		
		public static function shuffle(arr:Array):Array
		{
			var shuffled:Array = [];
 
			while (arr.length > 0) 
			{
				shuffled.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}
			return shuffled;
		}
		
	}

}