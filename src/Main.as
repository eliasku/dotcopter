package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	public class Main extends Engine
	{
		public function Main():void 
		{
			super(test.COLS, test.ROWS, 30, true);
			FP.screen.color = 0xFF333333;
			FP.screen.scale = 4;
			
			FP.world = new TerraGen();
		}
	}
}