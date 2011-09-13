﻿package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	public class Main extends Engine
	{
		public function Main():void 
		{
			super(test.COLS, test.ROWS, 30, true);
			FP.screen.color = 0xff333355;
			FP.screen.scale = 4;
			
			SoundManager.initialize();
			
			FP.world = new CoptGame();
		}
	}
}