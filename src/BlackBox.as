package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class BlackBox extends Entity
	{
		
		public function BlackBox() 
		{
			var image:Image = Image.createRect(96, 96, 0xFFFFFF); 
			image.scrollX = 0;
			image.scrollY = 0;
			super(0, 0, image);
		}
		
	}

}