package ui
{
	import draw.Pencil;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.utils.setTimeout;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class LevelCompleteScreen extends Entity
	{
		[Embed(source='../../bin/asset/fonts/PrStart.ttf',embedAsCFF='false',fontFamily='press_start')]
		private const FONT:Class;
		
		private var _game:CoptGame = CoptGame.instance;
		
		private var _active:Boolean = false;
		
		public function LevelCompleteScreen()
		{
			var display:Graphiclist = new Graphiclist();
			display.scrollX = 0;
			display.scrollY = 0;
			
			var darken:Image = Image.createRect(FP.width, FP.height, 0x000000);
			darken.alpha = 0.2;
			display.add(darken);
			
			var completeText:Text = new Text("LEVEL COMPLETE", 25, 40, 200, 50);
			completeText.font = "press_start";
			completeText.color = 0xffffff;
			completeText.size = 8;
			
			var textSource:BitmapData = new BitmapData(completeText.width, completeText.height, true, Pencil.BLACK);
			var ct:ColorTransform = new ColorTransform();
			ct.color = 0x000000;
			textSource.draw(completeText.source, null, ct);
			
			var textShadow:Image = new Image(textSource);
			textShadow.x = completeText.x + 1;
			textShadow.y = completeText.y + 1;
			display.add(textShadow);
			
			display.add(completeText);
		
			graphic = display;
			
			layer = Layer.GUI;
			
			visible = false;
		}
		
		public function show():void
		{
			this.visible = true;
			
			setTimeout(activate, 2000);
		}
		
		private function activate():void
		{
			_active = true;
		}
		
		override public function update():void 
		{
			if (_active)
			{
				if (Input.mousePressed || Input.pressed(Key.SPACE))
				{
					GameState.emulation = false;
					_game.curtains.close();
					hide();
				}
			}
			super.update();
		}
		
		public function hide():void
		{
			this.visible = false;
			_active = false;
		}
	}
}