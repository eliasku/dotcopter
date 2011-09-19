package com.ek.core 
{
	import flash.events.Event;

	/**
	 * @author eliasku
	 */
	public class CoreMouseEvent extends Event
	{
		public static const MOUSE_DOWN:String = "core_mouse_down";
		public static const MOUSE_UP:String = "core_mouse_up";
		public static const MOUSE_MOVE:String = "core_mouse_move";
		
		public var x:Number;
		public var y:Number;
		public var leaved:Boolean;
		
		public function CoreMouseEvent(type:String)
		{
			super(type);
		}
	}
}
