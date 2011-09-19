package com.ek.utils 
{
	import com.ek.text.StringManager;

	import flash.utils.ByteArray;

	/**
	 * @author eliasku
	 */
	public class StringUtil 
	{
		static public function stripSpaces(text:String):String
		{
			var arr:Array = text.split(" ");
			return(arr.join(""));
		}

		static public function stripStrings(text:String, strings:Array):String
		{
			for each (var stripString:String in strings)
				text = text.split(stripString).join("");

			return text;
		}

		static private function itoaFixed2(value:int):String
		{
			if(value < 10) return "0" + value.toString();
			return value.toString();
		}

		static public function timeMMSS(time:Number):String
		{
			const mins:int = int(int(int(time) / 60) % 60);
			const secs:int = int(int(time) % 60);
					
			return itoaFixed2(mins) + ":" + itoaFixed2(secs);
		}

		static public function waitTime(sec:int):String
		{
			var strDay:String = " д. ";
			var strHour:String = " ч. ";
			var strMinute:String = " м. ";
			var strSecond:String = " с. ";
			
			if(StringManager.hasText("time_format_day"))
				strDay = " " + StringManager.getText("time_format_day") + " ";
				
			if(StringManager.hasText("time_format_hour"))
				strHour = " " + StringManager.getText("time_format_hour") + " ";
				
			if(StringManager.hasText("time_format_minute"))
				strMinute = " " + StringManager.getText("time_format_minute") + " ";
				
			if(StringManager.hasText("time_format_second"))
				strSecond = " " + StringManager.getText("time_format_second");
			
			if(sec < 0) sec = 0;
			const secs:int = int(sec % 60);
			const mins:int = int(int(sec / 60) % 60);
			const hours:int = int(int(sec / 3600) % 24);
			const days:int = int(int(sec / 3600) / 24);
			var result:String = "";
			
			if(days > 0) result += days.toString() + strDay;
			if(hours > 0) result += hours.toString() + strHour;			
			if(mins > 0) result += mins.toString() + strMinute;			
			if(secs >= 0) result += secs.toString() + strSecond;
		
			return result;
		}

		static public function escapeHTMLText(text:String):String
		{
			var newText:String = text;
			
			if(newText.indexOf("<") >= 0) newText = newText.replace(/</g, "&lt;");
			if(newText.indexOf(">") >= 0) newText = newText.replace(/\>/g, "&gt;");
			
			return newText;
		}

		public static function byteArrayString(ba:ByteArray):String 
		{
 			var pos:int = ba.position;
 			var result:String = "";
 			var hex:String;
 			
			ba.position = 0;
 			
 			result += "ByteArray.position = " + pos.toString() + "\n";
 			result += "ByteArray.length = " + ba.length.toString() + "\n\n";
 			result += "ByteArray.bytes = \n";
 			
			while (ba.position < ba.length) 
			{
				hex = ba.readUnsignedByte().toString(16);
 
				while (hex.length < 2) hex = "0" + hex;
 
				result += hex + " ";
			}
 
			ba.position = pos;
 
			return result;
		}
	}
}
