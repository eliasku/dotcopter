package help
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Help extends World
	{
		public var helpSplasher:HelpSplasher;
		
		public function Help() 
		{
			add(new TestScreen());
			
			helpSplasher = new HelpSplasher(this);
		}
		
		override public function update():void 
		{	
			helpSplasher.update();
			super.update();
		}
	}
}