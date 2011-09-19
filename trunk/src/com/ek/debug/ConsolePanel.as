package com.ek.debug 
{
	import com.ek.core.CoreManager;
	import com.ek.ui.UIButton;
	import com.ek.ui.UITextArea;
	import com.ek.ui.UITextBox;
	import com.ek.ui.minimal.UIMinimalSet;
	import com.ek.utils.easing.Cubic;

	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author �������������
	 */
	internal class ConsolePanel extends Sprite 
	{
		private var _console:Console;
		
		private var _rect:Rectangle = new Rectangle();
		private var _input:UITextBox;
		private var _output:UITextArea;
		private var _closeButton:UIButton;
		
		private var _shown:Boolean;
		private var _showTween:Number = 0.0;
		//private var _tween:GTween;
		//private var _opening:Object = {value:0.0};
		
		private var _buffer:String = "";
		
		private var _history:Vector.<String> = new Vector.<String>();
		private var _historyIndex:int;
		
		public function ConsolePanel(console:Console, width:int, height:int, title:String) 
		{
			const indent:int = Console.INDENT;
			const ih:int = Console.INPUT_HEIGHT;
			const th:int = Console.TITLE_HEIGHT;
			
			_console = console;
			
			UIMinimalSet.createPanelContent(0, 0, width, height, this, "panel");
			_closeButton = new UIButton(console, UIMinimalSet.createButtonContent(indent, indent, th, th, "x", this, "close"));
			_closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
			
			_output = new UITextArea(console, UIMinimalSet.createTextAreaContent(indent, th + 2 * indent, width - 2 * indent, height - th - ih - 4 * indent, 0x222222, this, "output"));
			_output.selectable = true;
			_output.html = true;
			_output.textField.styleSheet = console.styleSheet;
			_output.textField.filters = [UIMinimalSet.getStroke(0)];
			_input = new UITextBox(console, UIMinimalSet.createTextBoxContent(indent, height - ih - indent, width - 2 * indent, ih, 0x222222, this, "input"));
			_input.textField.textColor = 0xffffff;
			_input.textField.filters = [UIMinimalSet.getStroke(0)];
			_input.textField.addEventListener(KeyboardEvent.KEY_DOWN, inputHandler);
			UIMinimalSet.createLabel(th + 3 * indent, indent, title, 0x333333, this, "title");
			
			console.addChild(this);
			
			_rect.width = width;
			_rect.height = height;

			visible = false;
			blendMode = BlendMode.LAYER;
			
			//_tween = new GTween(_opening, 0.3, null, {ease:Cubic.easeInOut});
			//_tween.onChange = updateConsole;
			
			CoreManager.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			placeConsole();
			updateConsole();
		}
		
		public function tick(dt:Number):void
		{
			var update:Boolean;
			
			if(_shown && _showTween < 1.0)
			{
				_showTween += dt*3;
				if(_showTween >= 1.0)
				{
					_showTween = 1.0;
					onShowCompleted();
				}
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
				updateConsole();
		}
		
		private function closeHandler(event:MouseEvent):void 
		{
			hide();
		}

		private function resizeHandler(event:Event):void 
		{
			placeConsole();
			updateConsole();
		}

		private function updateConsole():void 
		{
			const t:Number = Cubic.easeInOut(_showTween, 0, 0, 0);
			alpha = t;
			x = Console.INDENT;
			y = _rect.y + (1-t)*(_rect.height+1);
		}
		
		private function placeConsole():void
		{
			_rect.x = Console.INDENT;
			_rect.y = CoreManager.displayHeight - Console.INDENT - _rect.height;
		}
		
		private function updateOutput():void
		{
			_output.text = "<body>" + _buffer + "<br></body>";
		}
		
		public function get shown():Boolean
		{
			return _shown;
		}
		
		public function show():void
		{
			if(!_shown)
			{
				_shown = true;
				visible = true;
				blendMode = BlendMode.LAYER;
				cacheAsBitmap = true;
			}
			
		}
		
		public function hide():void
		{
			if(_shown)
			{
				_shown = false;
				mouseChildren = 
				mouseEnabled = false;
				visible = true;
				blendMode = BlendMode.LAYER;
				cacheAsBitmap = true;
			}
		}
		
		public function print(text:String):void
		{
			_buffer += text;
			updateOutput();
		}
				
		public function clear():void 
		{
			_buffer = "";
			updateOutput();
		}
		
		
		private function onHideCompleted() : void
		{
		 	visible = false;
		}
		
		private function onShowCompleted():void 
		{
			blendMode = BlendMode.NORMAL;
			cacheAsBitmap = false;
			mouseChildren = 
			mouseEnabled = true;
			stage.focus = _input.textField;
		}

		private function inputSelectAllHandler(event:Event):void 
		{
			_input.textField.removeEventListener(Event.ENTER_FRAME, inputSelectAllHandler);
			_input.textField.setSelection(0, _input.text.length);
			event.stopImmediatePropagation();
		}
	
		private function inputHandler(event:KeyboardEvent):void 
		{
			var stop:Boolean;
			
			switch(event.keyCode)
			{
				case Keyboard.ENTER:
					if(_input.text.length > 0)
					{
						_console.executeString(_input.text);
						_history.push(_input.text);
						_input.text = "";
						_historyIndex = _history.length;
					}
					stop = true;
					break;
						
				case Keyboard.UP:
					_historyIndex--;
					if( _historyIndex < 0) _historyIndex = 0;
					else if(_historyIndex < _history.length) setHistoryCommand();
					stop = true;
					break;
					
				case Keyboard.DOWN:
					_historyIndex++;
					if(_historyIndex < _history.length)	setHistoryCommand();
					else _historyIndex = _history.length - 1;
					stop = true;
					break;
			}
			
			if(stop)
				event.stopImmediatePropagation();
		}
		
		private function setHistoryCommand():void
		{
			_input.text = _history[_historyIndex];
			_input.textField.addEventListener(Event.ENTER_FRAME, inputSelectAllHandler);
		}

		
	}
}
