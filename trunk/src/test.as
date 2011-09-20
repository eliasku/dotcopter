package  
{
	import com.ek.asset.AssetLoader;
	import com.ek.asset.AssetManager;
	import com.ek.audio.Music;
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
	[SWF(backgroundColor="#000000", width="480", height="270", frameRate="30")]
	public class test extends Sprite 
	{
		public static const COLS:int = 160;
		public static const ROWS:int = 90;
		
		public static var canClick:Boolean = true;
		
		private var _main:Main;
		private var _screen:LCDScreen;
		private var _sceenRect:Rectangle = new Rectangle(0, 0, COLS, ROWS);
		private var _debug:BitmapData;
		
		private var _descriptionLoader:AssetLoader;
		private var _assetLoader:AssetLoader;
		
		public function test() 
		{
			SWFProfiler.init(stage, this);
			
			AssetManager.initialize();
			AssetManager.assetURL = "asset/";
			AssetManager.add("assets", "asset.xml");
			
			initialize();
			
			_descriptionLoader = AssetManager.load();
			_descriptionLoader.addEventListener(Event.COMPLETE, onDescLoaded);
			_descriptionLoader.load();
		}
		
		private function initialize():void 
		{
			_screen = new LCDScreen(COLS, ROWS);
			_screen.x = _screen.y;
			stage.addChild(_screen);
			
			stage.fullScreenSourceRect = new Rectangle(0, 0, _screen.screenWidth, _screen.screenHeight);
		}
		
		private function onDescLoaded(e:Event):void 
		{
			_descriptionLoader.removeEventListener(Event.COMPLETE, onDescLoaded);
			_descriptionLoader = null;
			
			AssetManager.addFromXML(AssetManager.getXML("assets"));
			AssetManager.remove("assets");
			
			_assetLoader = AssetManager.load();
			if (_assetLoader)
			{
				_assetLoader.addEventListener(Event.COMPLETE, onAssetLoaded);
				_assetLoader.load();
			}
			else
				onAssetLoaded(null);
		}
		
		private function onAssetLoaded(e:Event):void 
		{
			if (_assetLoader)
			{
				_assetLoader.removeEventListener(Event.COMPLETE, onAssetLoaded);
				_assetLoader = null;
			}
			
			_main = new Main();
			_main.visible = false;
			addChild(_main);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			_screen.draw(FP.buffer, _sceenRect);
			Music.update(0);
		}
	}
}