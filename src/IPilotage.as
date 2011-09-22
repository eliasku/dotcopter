package  
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public interface IPilotage 
	{
		function get maxLifes():int;
		
		function get controlUp():Boolean;
		function get controlDown():Boolean;
		
		function update(pos:Point, vy:Number):void;
	}
	
}