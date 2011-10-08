package ui
{
	import draw.Pencil;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
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
	public class Menu extends Entity
	{
		[Embed(source='../../bin/asset/fonts/PrStart.ttf',embedAsCFF='false',fontFamily='press_start')]
		private const FONT:Class;
		
		private var _introText:Text;
		private var _textShadow:Image;
		
		private var _display:Graphiclist;
		
		private var _t:int = 0;
		
		public function Menu()
		{
			_display = new Graphiclist();
			_display.scrollX = 0;
			_display.scrollY = 0;
			
			var darken:Image = Image.createRect(FP.width, FP.height, 0x000000);
			darken.alpha = 0.2;
			_display.add(darken);
			
			_introText = new Text("-ANY KEY TO START-", 7, 76, 200, 50, true);
			_introText.font = "press_start";
			_introText.color = 0xffffff;
			_introText.size = 8;
			
			_display.add(_introText);
			
			graphic = _display;
			
			layer = Layer.GUI;
			
			GameState.emulation = true;
		}
		
		override public function update():void
		{
			_t++;
			if (_t % 10 == 0)
			{
				_introText.visible = !_introText.visible;
			}
			
			if (GameState.emulation)
			{
				if (Input.mousePressed || Input.pressed(Key.SPACE))
				{
					GameState.emulation = false;
					CoptGame.instance.curtains.close();
					CoptGame.instance.remove(this);
				}
			}
			
			super.update();
		}
	
	}

}