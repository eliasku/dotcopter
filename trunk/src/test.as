package  
{
	import com.flashdynamix.utils.SWFProfiler;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import help.Help;
	import net.flashpunk.FP;
	import uk.co.soulwire.gui.SimpleGUI;

	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class test extends Sprite 
	{
		public static var canClick:Boolean = true;
		
		private var main:Main;
		private var _lcd:LCDRender;
		private var _screen:LCDScreen;
		private var _sceenRect:Rectangle = new Rectangle(0, 0, 96, 96);

		public function test() 
		{
			main = new Main();
			//main.visible = false;
			addChild(main);
			
			//_lcd = new LCDRender(0.2);
			//_lcd = new LCDRender(0.4, 0x000000, 0x203040, 0xc0c0c0);
			//addChild(_lcd);
			
			_screen = new LCDScreen();
			addChild(_screen);
			
			SWFProfiler.init(stage, this);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
/*		private function setupDebugOutput():void
		{
			var guiContainer:Sprite = new Sprite();
			addChild(guiContainer);
			guiContainer.x = 400;
			
			var gui:SimpleGUI = new SimpleGUI(guiContainer, "gameplay test", "C");
			gui.show();
			
			gui.addColumn("Instructions:");
			gui.addLabel("Press 'C' to toggle GUI");
		}*/
		
		private function enterFrameHandler(e:Event):void 
		{
			//_lcd.render(FP.buffer);
			_screen.draw(FP.buffer, _sceenRect);
		}
	}
}