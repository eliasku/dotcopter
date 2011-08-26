package utils
{
	
	public class ColorUtil
	{
		private var randArray:Array = new Array();
		private var randChar:String;
		private var randNum:Number;
		private var color:uint;
		private var finalProduct:String;
		private var twoHexVals:String;
		
		public function ColorUtil()
		{
			// left empty
		}
		
		public function getRandomColor(red:String = null, green:String = null, blue:String = null):uint
		{
			//trace("Red: " + red + ", Green: " + green + ", Blue: " + blue);
			
			if(red == null)
				red = getRandomDigit();
			if(green == null)
				green = getRandomDigit();
			if(blue == null)
				blue = getRandomDigit();
			
			finalProduct = "0x" + red + green + blue;

			//trace("Random Color: " + finalProduct);
			
			color = uint(finalProduct);
			
			return color;
		}
		
		function getRandomDigit():String
		{
			twoHexVals = new String();
			
			for(var j:int = 0; j < 2; j++)
			{
				randNum = Math.round(Math.random() * 15);
				
				if(randNum < 10)
					twoHexVals += String(randNum);
				else
				{
					switch(randNum)
					{
						case 10:
							randChar = 'A';
							break;
						case 11:
							randChar = 'B';
							break;
						case 12:
							randChar = 'C';
							break;
						case 13:
							randChar = 'D';
							break;
						case 14:
							randChar = 'E';
							break;
						case 15:
							randChar = 'F';
							break;
					}
					twoHexVals += String(randChar);
				}
			}
			
			return twoHexVals;
		}
		
	} //ends class
	
} //ends package