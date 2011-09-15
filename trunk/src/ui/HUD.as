package ui
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.utils.getDefinitionByName;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Draw;
	import utils.ArrayUtil;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class HUD extends Entity
	{
		private var _display:Graphiclist;
		private var scoreText:Text;
		private var bestText:Text;
		public static var score:int = 0;
		public static var best:int = 0;
		private var t:int = 0;

		[Embed(source = '../../assets/fonts/Acme 5 Compressed Caps Outline.ttf', embedAsCFF = 'false', fontFamily = 'grixel')] private const FONT:Class;
		[Embed(source = '../../assets/GUI/heart_empty.png')] private const HEART_EMPTY:Class;
		[Embed(source = '../../assets/GUI/heart_full.png')] private const HEART_FULL:Class;
		
		private var _hearts:Vector.<Image> = new Vector.<Image>();
		private var _heartsData:Array = [];
		
		private var _copter:Heli;
		
		public function HUD() 
		{
			_copter = CoptGame.instance.copter;
			
			var panel:BitmapData = new BitmapData(FP.width, 10, true, 0x00000000);
			Draw.setTarget(panel);
			Draw.line(0, 0, FP.width, 0, 0xFFFFFFFFFF);
			Draw.line(0, 0, 0, 10, 0xFFFFFFFFFF);
			Draw.line(FP.width-1, 0, FP.width-1, 10, 0xFFFFFFFFFF);
			
			super(0, FP.height - 10);
			var image:Image = new Image(panel);
			
			scoreText = new Text(String(score), 0, -5 , 200, 50);
			scoreText.font = "grixel";
			scoreText.color = 0xffffff;
			scoreText.size = 8;
			
/*			Data.load("score");
			t = Data.readInt("best");
			best = t;
			
			bestText = new Text("BEST:"+intToStr(t), 41, -5 , 200, 50);
			bestText.font = "grixel";
			bestText.color = 0xffffff;
			bestText.size = 8;*/
			
			//image.blend = BlendMode.INVERT;
			
			_display = new Graphiclist(image, scoreText); // bestText
			_display.scrollX = 0;
			_display.scrollY = 0;
			
			graphic = _display;
			
			layer = 0;
			
			resetHearts();
		}
		
		public function resetHearts():void 
		{
			_heartsData = new Array(5);
			for (var i:int = 0; i < _heartsData.length; i++) 
			{
				_heartsData[i] = (i < _copter.maxLifes) ? 1 : -1;
			}
			
			updateHearts();
		}
		
		private function updateHearts():void
		{
			var heart:Image;
			
			if (_hearts.length > 0)
			{
				for each (heart in _hearts) 
				{
					_display.remove(heart);
				}
			}
			
			for (var i:int = 0; i < _heartsData.length; i++) 
			{
				switch (_heartsData[i])
				{
					case -1:
						heart = new Image(HEART_FULL);
						heart.alpha = 0.4;
					break;
					
					case 0:
						heart = new Image(HEART_EMPTY);
					break;
					
					case 1:
						heart = new Image(HEART_FULL);
					break;
				}
				
				heart.x = FP.width - 10 - 9 * i;
				heart.y = 2;
				
				_display.add(heart);
				_hearts[i] = heart;
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
		
/*		public function updateHearts(dir:int):void
		{
			var life:int = _copter.lifes;
			var fullHeart:Image = _hearts[life];
			_display.remove(fullHeart);
			
			var emptyHeart:Image = new Image(HEART_EMPTY);
			emptyHeart.x = fullHeart.x;
			emptyHeart.y = fullHeart.y;
			
			_display.add(emptyHeart);
			_hearts[life] = emptyHeart;
			_heartsData[life] = 0;
		}*/
		
/*		public function resetHearts(life:int):void 
		{
			var total:int = _copter.maxLifes;
			
			var emptyHeart:Image;
			var fullHeart:Image;
			
			for (var i:int = life; i < total; i++) 
			{
				emptyHeart = _hearts[i];
				_display.remove(emptyHeart);
				
				fullHeart = new Image(HEART_FULL);
				fullHeart.x = emptyHeart.x;
				fullHeart.y = emptyHeart.y;
				_display.add(fullHeart);
				_hearts[i] = fullHeart;
				
				_heartsData[i] = 1;
			}
		}*/
		
		override public function update():void
		{
			if (CoptGame.pauseMode) return;
			
			scoreText.text = score.toString();
			
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
