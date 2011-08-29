package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	public class Main extends Engine
	{
		public function Main():void 
		{
			GameSize.init();
			
			super(GameSize.X1, GameSize.X1, 30, true);
			FP.screen.color = 0;
			
			FP.world = new CoptGame();
		}
	}
}