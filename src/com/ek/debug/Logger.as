package com.ek.debug 
{
	import mx.utils.StringUtil;

	import flash.events.EventDispatcher;

	/**
	 * @author eliasku
	 */
	public class Logger 
	{
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		
		private static var _traceEnabled:Boolean = true;
		
		private static var _ignoreMessages:Boolean;
		private static var _ignoreWarnings:Boolean;
		private static var _ignoreErrors:Boolean;
		
		private static var _throwErrors:Boolean;
		
		private static var _historyEnabled:Boolean = true;
		
		private static var _history:String = "";
		
		public static function log(level:String, message:String, ...rest:Array):void
		{
			
			// filter messages
			
			if(!level && !_ignoreMessages)
				level = LogLevel.MESSAGE;
			
			if(level == LogLevel.WARNING && _ignoreWarnings)
				level = null;
				
			if(level == LogLevel.ERROR && _ignoreErrors)
				level = null;

			// message not filtered
			if(level)
			{
				message = StringUtil.substitute(message, rest);
					
				// trace message
				if(_traceEnabled)
				{
					trace(message);
				}
				
				if(_historyEnabled)
				{
					_history += message + "\n";
				}
					
				// dispatch event
				_dispatcher.dispatchEvent(new LogEvent(message, level));
			}
		}
		
		public static function assert(expression:Boolean, message:String = "assert"):void
		{
			if(!expression)
				error(message);
		}
		
		public static function message(text:String, ...rest:Array):void
		{
			log(LogLevel.MESSAGE, text, rest);
		}
		
		public static function warning(text:String, ...rest:Array):void
		{
			log(LogLevel.WARNING, text, rest);
		}
		
		public static function error(text:String, ...rest:Array):void
		{
			log(LogLevel.ERROR, text, rest);
			
			if(_throwErrors)
				throw new Error(message);
		}

		
		
		static public function get ignoreMessages():Boolean
		{
			return _ignoreMessages;
		}
		
		static public function set ignoreMessages(value:Boolean):void
		{
			_ignoreMessages = value;
		}
		
		static public function get ignoreWarnings():Boolean
		{
			return _ignoreWarnings;
		}
		
		static public function set ignoreWarnings(value:Boolean):void
		{
			_ignoreWarnings = value;
		}
		
		static public function get ignoreErrors():Boolean
		{
			return _ignoreErrors;
		}
		
		static public function set ignoreErrors(value:Boolean):void
		{
			_ignoreErrors = value;
		}
		
		
		static public function get traceEnabled():Boolean
		{
			return _traceEnabled;
		}
		
		static public function set traceEnabled(value:Boolean):void
		{
			_traceEnabled = value;
		}
		
		
		
		static public function get throwErrors():Boolean
		{
			return _throwErrors;
		}
		
		static public function set throwErrors(value:Boolean):void
		{
			_throwErrors = value;
		}
		
		static public function get history():String
		{
			return _history;
		}
		
		public static function addEventListener(listener:Function, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_dispatcher.addEventListener(LogEvent.LOG_EVENT, listener, false, priority, useWeakReference);
		}
		
		public static function removeEventListener(listener:Function):void
		{
			_dispatcher.removeEventListener(LogEvent.LOG_EVENT, listener);
		}

	}
}
