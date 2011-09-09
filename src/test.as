package  
{
	import net.flashpunk.FP;

	import com.flashdynamix.utils.SWFProfiler;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author Gleb Volkov
	 */
	[SWF(backgroundColor="#000000", width="480", height="360", frameRate="30")]
	public class test extends Sprite 
	{
		public static const COLS:int = 120;
		public static const ROWS:int = 90;
		
		public static var canClick:Boolean = true;
		
		private var _main:Main;
		private var _screen:LCDScreen;
		private var _sceenRect:Rectangle = new Rectangle(0, 0, COLS, ROWS);
		private var _debug:BitmapData;

		public function test() 
		{
			_screen = new LCDScreen(COLS, ROWS);
			_screen.x = _screen.y;
			stage.addChild(_screen);
			
			_main = new Main();
			_main.visible = false;
			addChild(_main);
			
			SWFProfiler.init(stage, this);
			
			stage.fullScreenSourceRect = new Rectangle(0, 0, _screen.screenWidth, _screen.screenHeight);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_screen.draw(FP.buffer, _sceenRect);
		}
	}
}