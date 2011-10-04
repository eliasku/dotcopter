package ui
{
	import com.ek.asset.AssetManager;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class HUD extends Entity
	{
		public static var score:int = 0;
		public static var best:int = 0;
		
		private var _scoreText:Text;
		private var _bestText:Text;
		
		private static const HEIGHT:int = 10;
		
		[Embed(source = '../../bin/asset/fonts/Acme 5 Compressed Caps Outline.ttf', embedAsCFF = 'false', fontFamily = 'grixel')] private const FONT:Class;
		
		private const HEART_WIDTH:int = 7;
		private const HEART_HEIGHT:int = 7;
		
		private var _display:Graphiclist;
		
		private var t:int = 0;
		
		private var _hearts:Vector.<Spritemap> = new Vector.<Spritemap>();
		private var _heartsData:Array = [];
		
		private var _copter:Copter;
		
		public function HUD() 
		{
			_copter = CoptGame.instance.copter;
			
			super(0, FP.height - HEIGHT);
			
			_scoreText = new Text(String(score), 0, -5 , 200, 50);
			_scoreText.font = "grixel";
			_scoreText.color = 0xffffff;
			_scoreText.size = 8;
			
/*			Data.load("score");
			t = Data.readInt("best");
			best = t;
			
			bestText = new Text("BEST:"+intToStr(t), 41, -5 , 200, 50);
			bestText.font = "grixel";
			bestText.color = 0xffffff;
			bestText.size = 8;*/
			
			//image.blend = BlendMode.INVERT;
			
			_display = new Graphiclist(_scoreText); // bestText
			_display.scrollX = 0;
			_display.scrollY = 0;
			
			graphic = _display;
			
			layer = Layer.GUI;
			
			reset();
			
			setupHearts();
		}
		
		public function reset():void 
		{
			visible = !GameState.emulation;
		}
		
		public function setupHearts():void 
		{
			var i:int;
			_heartsData = new Array(5);
			for (i = 0; i < _heartsData.length; i++) 
			{
				_heartsData[i] = (i < _copter.pilot.maxLifes) ? 1 : -1;
			}
			
			var heart:Spritemap;
			for (i = 0; i < _heartsData.length; i++) 
			{
				heart = new Spritemap(AssetManager.getBitmapData("gfx_heart"), HEART_WIDTH, HEART_HEIGHT);
				heart.add("full", [0]);
				heart.add("empty", [1]);
				
				switch (_heartsData[i])
				{
					case -1:
						heart.play("full");
						heart.alpha = 0.4;
					break;
					
					case 0:
						heart.play("empty");
					break;
					
					case 1:
						heart.play("full");
					break;
				}
				
				heart.x = FP.width - 10 - 9 * i;
				heart.y = 2;
				
				_display.add(heart);
				_hearts[i] = heart;
			}
		}
		
		public function resetHearts():void 
		{
			for (var i:int = 0; i < _heartsData.length; i++) 
			{
				_heartsData[i] = (i < _copter.pilot.maxLifes) ? 1 : -1;
			}
			
			updateHearts();
		}
		
		private function updateHearts():void
		{
			var heart:Spritemap;
			for (var i:int = 0; i < _heartsData.length; i++) 
			{
				heart = _hearts[i];
				switch (_heartsData[i])
				{
					case -1:
						heart.play("full");
						heart.alpha = 0.4;
					break;
					
					case 0:
						heart.play("empty");
						heart.alpha = 1;
					break;
					
					case 1:
						heart.play("full");
						heart.alpha = 1;
					break;
				}
			}
			//trace("[HUD] hearts :: "+_heartsData.join(" "));
		}
		
		public function changeHearts(delta:int):void
		{
			var index:int = ArrayUtil.findLastMatch(_heartsData, 1);
			
			if (index >= 0)
			{
				if (delta < 0)
				{
					_heartsData[index] = 0;
				}
				else
				{
					// добавление жизни
					//if (index < _copter.maxLifes) _heartsData[index + 1] = 1;
				}
			}
			updateHearts();
		}
		
		override public function update():void
		{
			if (GameState.pauseMode) return;
			
			_scoreText.text = score.toString();
			
			/*	if (t < best)
			 * {
				t++
				bestText.text = "BEST:"+intToStr(t);
			}*/
		}
		
		private function intToStr(par:int):String {
			var prefix:String;
			if (int(par * 0.1) == 0) prefix = "000";
			else if (int(par * 0.01) == 0) prefix = "00";
			else if (int(par * 0.001) == 0) prefix = "0";
			else if (int(par * 0.0001) == 0) prefix = "";
			return prefix+String(par);
		}
	}
}
