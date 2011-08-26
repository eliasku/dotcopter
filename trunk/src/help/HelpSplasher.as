package help
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class HelpSplasher extends Splasher 
	{
		public function HelpSplasher(world:World) 
		{
			super(world);
		}
		
		override public function splash():void 
		{
			super.splash();
			_mult = 1;
		}
		
		override public function onClose():void 
		{
			FP.world = new CoptGame();
			return;
		}
		
	}

}