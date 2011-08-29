package  
{
	import com.flashdynamix.utils.SWFProfiler;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import utils.DText;

	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class test extends Sprite 
	{
		public static var canClick:Boolean = true;
		
		private var _main:Main;
		private var _screen:LCDScreen;
		private var _sceenRect:Rectangle = new Rectangle(0, 0, 96, 96);
		private var _debug:BitmapData;

		public function test() 
		{
			_main = new Main();
			_main.visible = false;
			addChild(_main);
			
			_screen = new LCDScreen();
			_screen.x = _screen.y = 8;
			addChild(_screen);
			
			SWFProfiler.init(stage, this);
			
			_debug = new BitmapData(400, 400, true, 0x00000000);
			var output:Bitmap = new Bitmap(_debug);
			addChild(output);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_screen.draw(FP.buffer, _sceenRect);
			//log("fps", SWFProfiler.currentFps.toFixed(2));
		}
		
		public function log(...msg):void
		{
			_debug.fillRect(_debug.rect, 0x00000000);
			var str:String = (msg.length > 0) ? msg.join(" ") : msg.toString();
			DText.draw(_debug, str, 9, 8);
		}
	}
}