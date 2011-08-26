package help
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Anykey extends Entity 
	{
		[Embed(source='../../assets/GUI/invert.png')] private const LABEL:Class;
		private var label:Spritemap = new Spritemap(LABEL, 96, 9);
		private var _t:int = 0;
		
		public function Anykey() 
		{
			label.add("black", [0], 0, false);
			label.add("white", [1], 0, false);
			label.play("black");
			
			super(0, 84, label);
		}
		
		override public function update():void 
		{
			_t++;
			if (_t % 15 == 0) {
				(label.currentAnim == "black") ? label.play("white") : label.play("black");
			}
			super.update();
		}
		
	}
}