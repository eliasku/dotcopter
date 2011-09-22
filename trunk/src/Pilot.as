package  
{
	import flash.geom.Point;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Pilot implements IPilotage 
	{
		private var _maxLifes:int = 3;
		
		public function Pilot() 
		{
			
		}
		
		/* INTERFACE IPilotage */
		
		public function update(pos:Point, vy:Number):void 
		{
			
		}
		
		public function get controlUp():Boolean 
		{
			return Input.mousePressed || Input.pressed(Key.SPACE);
		}
		
		public function get controlDown():Boolean 
		{
			return Input.mouseReleased || Input.released(Key.SPACE);
		}
		
		/* INTERFACE IPilotage */
		
		public function get maxLifes():int 
		{
			return _maxLifes;
		}
		
	}

}