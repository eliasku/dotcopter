package help
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class HelpText extends Entity
	{
		[Embed(source = '../../assets/fonts/pf_tempesta_seven_condensed.ttf', embedAsCFF = 'false', fontFamily = 'pf')]
		private static const FONT:Class;
		private var _textField:Text;
		private var _myText:String = "Click and hold mouse\nto go up, release -\nto go down.";
		private var _counter:int = 0;
		private var _startTyping:Boolean = false;
		
		public function HelpText() 
		{
			_textField = new Text("", 2, 20, 300, 200);
			_textField.font = "pf";
			_textField.color = 0xFFFFFFF;
			_textField.size = 8;
			graphic = _textField;
		}
		
		public function startTyping():void
		{
			_startTyping = true;
		}
		
		override public function update():void 
		{
			if (_startTyping) {
				if (_counter <= _myText.length){
					_textField.text = _myText.substr(0, _counter);
					_counter++;
				} else {
					_startTyping = false;
				}
			}
			super.update();
		}
		
	}

}