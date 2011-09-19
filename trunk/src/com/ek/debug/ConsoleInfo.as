package com.ek.debug 
{
	import com.ek.ui.minimal.UIMinimalSet;
	import com.ek.utils.easing.Cubic;

	import flash.display.BlendMode;
	import flash.text.TextField;

	/**
	 * @author �������������
	 */
	internal class ConsoleInfo 
	{
		private var _console:Console;
		private var _tf:TextField;
		//private var _tween:GTween;
		private var _showTween:Number = 0.0;
		private var _shown:Boolean;
		
		public function ConsoleInfo(console:Console)
		{
			_tf = UIMinimalSet.createLabel(0, 0, "", 0x77FF77, console, "info");
			_tf.multiline = true;
			_tf.x = Console.INDENT;
			_tf.y = Console.INDENT;
			_tf.filters = [UIMinimalSet.getStroke()];
			_tf.mouseEnabled = false;
			_tf.visible = false;
			_tf.alpha = 0.0;
			_tf.blendMode = BlendMode.LAYER;
			
			//_tween = new GTween(_tf, 0.3, null, {ease:Cubic.easeInOut});
			
			_console = console;
			
			_tf.mouseEnabled = false;
		}
		
		public function tick(dt:Number):void
		{
			var update:Boolean;
			
			if(_shown && _showTween < 1.0)
			{
				_showTween += dt*3;
				if(_showTween > 1.0)
					_showTween = 1.0;
				update = true;
			}
			else if(!_shown && _showTween > 0.0)
			{
				_showTween -= dt*3;
				if(_showTween <= 0.0)
				{
					_showTween = 0.0;
					onHideCompleted();
				}
				update = true;
			}
			
			if(update)
				updateShow();
		}
		
		public function set text(value:String):void
		{
			_tf.text = value;
		}
		
		public function get text():String
		{
			return _tf.text;
		}
		
		public function show():void
		{
			if(!_shown)
			{
				_shown = true;
				_tf.visible = true;
			}
		}
		
		public function hide():void
		{
			if(_shown)
			{
				_shown = false;
				_tf.visible = true;
			}
		}
		
		public function get shown():Boolean
		{
			return _shown;
		}
		
		private function updateShow():void
		{
			const t:Number = Cubic.easeInOut(_showTween, 0, 0, 0);
			_tf.alpha = t;
		}
		
		private function onHideCompleted():void
		{
			_tf.visible = false;
		}
		
	}
}
