package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Effects extends Entity 
	{
		public var trail:Trail;
		public var explode:Explode;
		
		private var _displayList:Graphiclist;
		
		public function Effects() 
		{
			_displayList = new Graphiclist();
			
			trail = new Trail();
			_displayList.add(trail);
			
			explode = new Explode();
			_displayList.add(explode);
			
			graphic = _displayList;
			
			layer = Layer.FX;
		}
		
	}

}