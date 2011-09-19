package com.ek.debug 
{
	import flash.events.Event;

	/**
	 * @author eliasku
	 */
	public class LogEvent extends Event 
	{
		public static const LOG_EVENT:String = "logger_event";
		
		private var _message:String;
		private var _level:String;
		
		public function LogEvent(message:String, level:String)
		{
			super(LOG_EVENT, false, false);
			
			_message = message;
			_level = level;
		}
		
		public function get message():String
		{
			return _message;
		}
		
		public function get level():String
		{
			return _level;
		}
	}
}
