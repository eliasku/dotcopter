package  
{
	import flash.display.BlendMode;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Start extends Entity 
	{
		[Embed(source='../assets/GUI/start.png')] private const START:Class;
		private var offY:int = 48;
		
		public function Start() 
		{
			var img:Image = new Image(START);
			img.blend = BlendMode.DIFFERENCE;
			super(0, offY, img);
		}
		
		override public function update():void 
		{
			y = offY + FP.camera.y;
			super.update();
		}
	}
}