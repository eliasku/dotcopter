package com.ek.core 
{
	import flash.events.Event;

	/**
	 * @author eliasku
	 */
	public class CoreEvent extends Event 
	{
		public static const SLOW_TICK:String = "core_interval";
		public static const TICK:String = "core_tick";
		public static const FPS:String = "core_fps";
		
		public function CoreEvent(type:String)
		{
			super(type, false, false);
		}
	}
}
