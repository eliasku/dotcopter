package help 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Data;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Checkbox extends Entity 
	{
		[Embed(source = '../../assets/GUI/сheck.png')] private const CHECK:Class;
		private var check:Spritemap = new Spritemap(CHECK, 11, 11);
		
		public function Checkbox() 
		{
			check.add("off", [0], 0, false);
			check.add("on", [1], 0, false);
			check.play("on");
			super(5, 65, check);
		}
		
		public function toggleCheck():void {
			(check.currentAnim == "on") ? check.play("off") : check.play("on");
			Data.writeString("help", check.currentAnim);
			Data.save("firstRun");
		}
	}
}