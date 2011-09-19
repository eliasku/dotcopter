package com.ek.core 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 * @author eliasku
	 */
	public class CoreKeyboardEvent extends Event
	{
		public static const KEY_DOWN:String = "core_key_down";
		public static const KEY_UP:String = "core_key_up";
		
		public var alt:Boolean;
		public var shift:Boolean;
		public var ctrl:Boolean;
		public var repeated:Boolean;
		public var code:uint;
		public var char:uint;
		public var location:uint;
		
		public function CoreKeyboardEvent(type:String)
		{
			super(type);
		}
		
		public function process(repeated:Boolean, keyboardEvent:KeyboardEvent):void
		{
			alt = keyboardEvent.altKey;
			ctrl = keyboardEvent.ctrlKey;
			shift = keyboardEvent.shiftKey;
			this.repeated = repeated;
			
			code = keyboardEvent.keyCode;
			char = keyboardEvent.charCode;
			location = keyboardEvent.keyLocation;
		}
	}
}
