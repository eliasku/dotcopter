package  
{
	import flash.display.BlendMode;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Pause extends Entity 
	{
		[Embed(source='../assets/GUI/pause.png')] private const PAUSE:Class;
		private var offY:int = 31;
		
		public function Pause() 
		{
			var img:Image = new Image(PAUSE);
			//img.blend = BlendMode.DIFFERENCE;
			super(0, offY, img);
			
			visible = false;
		}
		
		override public function update():void 
		{
			x = FP.camera.x;
			y = offY+FP.camera.y;
			super.update();
		}
		
	}

}