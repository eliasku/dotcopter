package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;	
	/**
	 * ...
	 * @author ...
	 */
	public class TestScreen extends Entity 
	{
		[Embed(source = '../assets/GUI/test.png')] private const TEST:Class;
		
		public function TestScreen() 
		{
			super(0, 0, new Image(TEST));
		}
		
		override public function update():void 
		{
			super.update();
		}
		
	}
}