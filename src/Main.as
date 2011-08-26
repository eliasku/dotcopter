package 
{
	import help.Help;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	public class Main extends Engine
	{
		public function Main():void 
		{
			super(GameSize.X1, 96, 30, true);
			FP.screen.color = 0;
			
			//FP.screen.scale = 4;
			
			FP.world = new CoptGame();
		}
	}
}