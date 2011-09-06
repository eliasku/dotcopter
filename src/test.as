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
	[SWF(backgroundColor="#000000", width="784", height="784", frameRate="60")]
	public class test extends Sprite 
	{
		private static const COLS:int = 96*2;
		private static const ROWS:int = 96*2;
		
		public static var canClick:Boolean = true;
		
		private var _main:Main;
		private var _screen:LCDScreen;
		private var _sceenRect:Rectangle = new Rectangle(0, 0, COLS, ROWS);
		private var _debug:BitmapData;

		public function test() 
		{
			_screen = new LCDScreen(COLS, ROWS);
			_screen.x = _screen.y = 8;
			stage.addChild(_screen);
			
			_main = new Main(COLS);
			_main.visible = false;
			addChild(_main);
			
			SWFProfiler.init(stage, this);
			
			/*_debug = new BitmapData(400, 400, true, 0x00000000);
			var output:Bitmap = new Bitmap(_debug);
			addChild(output);*/
			
			trace(_screen.screenWidth + 16);
			trace(_screen.screenHeight + 16);
		
			stage.fullScreenSourceRect = new Rectangle(0, 0, _screen.screenWidth + 16, _screen.screenHeight + 16);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_screen.draw(FP.buffer, _sceenRect);
			//log("fps", SWFProfiler.currentFps.toFixed(2));
		}
		
		public function log(...msg):void
		{
			//_debug.fillRect(_debug.rect, 0x00000000);
			//var str:String = (msg.length > 0) ? msg.join(" ") : msg.toString();
			//DText.draw(_debug, str, 9, 8);
		}
	}
}