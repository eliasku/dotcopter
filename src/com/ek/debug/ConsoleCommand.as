package com.ek.debug 
{

	/**
	 * @author �������������
	 */
	internal class ConsoleCommand 
	{
		public var alias:String;
		public var desc:String;
		public var func:Function;
		public var trimArgs:Boolean;

		public function ConsoleCommand(alias:String, desc:String, func:Function, trimArgs:Boolean = true)
		{
			this.alias = alias;
			this.desc = desc;
			this.func = func;
			this.trimArgs = trimArgs;
		}
	}
}
