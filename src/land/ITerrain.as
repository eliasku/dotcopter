package land 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public interface ITerrain 
	{
		function generate(rect:Rectangle):Vector.<Point>;
		function get maxSize():int;
	}
	
}