package com.ek.ui 
{
	import com.ek.gocs.IComponentContainer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author �������������
	 */
	public class UITextArea extends UIWrapper 
	{
		public function UITextArea(owner:IComponentContainer, content:Sprite)
		{
			super(owner, content);
			
			_back = content.getChildByName("back") as Sprite;
			_tf = content.getChildByName("text") as TextField;
			
			_tf.selectable = false;
			_tf.type = TextFieldType.DYNAMIC;
			_tf.wordWrap = true;
			_tf.multiline = true;
			_tf.addEventListener(Event.CHANGE, changeHandler);
			_tf.addEventListener(Event.SCROLL, textScrollHandler);
			_text = _tf.text;
			
			var scrollBar:Sprite = content.getChildByName("scrollbar") as Sprite;
			if(scrollBar)
			{
				_scrollBar = new UIScrollBar(this, scrollBar);
				_scrollBar.addEventListener(Event.CHANGE, barScrollHandler);
			}
		}

		private function barScrollHandler(event:Event):void 
		{
			_tf.scrollV = Math.round(_scrollBar.value); 
		}

		private function textScrollHandler(event:Event):void 
		{
			_scrollBar.value = _tf.scrollV;
			updateScrollBar(); 
		}
		
		private function changeHandler(event:Event):void 
		{
			updateScrollBar();
			dispatchEvent(event);
		}
		
		private function updateScrollBar():void
		{
			//var visibleLines:int = _tf.numLines - _tf.maxScrollV + 1;
			//var percent:Number = visibleLines / _tf.numLines;
			_scrollBar.setSliderParams(1, _tf.maxScrollV, _tf.scrollV);
			//_scrollBar.setThumbPercent(percent);
			//_scrollBar.pageSize = visibleLines; 
		}

		private var _html:Boolean = false;
		private var _selectable:Boolean = false;
		private var _back:Sprite;
		private var _tf:TextField;
		private var _text:String = "";
		
		private var _scrollBar:UIScrollBar;
		
		public function get html():Boolean
		{
			return _html;
		}
		
		public function set html(value:Boolean):void
		{
			_html = value;
			
			if(_html)
				_tf.htmlText = _text;
			else
				_tf.text = _text;
		}
		
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			
			_tf.mouseEnabled = _selectable;
			_tf.selectable = _selectable;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			var format:TextFormat;
			var prevScroll:int = _tf.scrollV;
			var bottomScroll:Boolean = (_tf.scrollV == _tf.maxScrollV);

			_text = value;
			
			if(_html)
			{
				format = _tf.defaultTextFormat;
				_tf.htmlText = _text;
				if(!_tf.styleSheet)
				{
					_tf.setTextFormat(format);
					_tf.defaultTextFormat = format;
				}
			}
			else
				_tf.text = _text;
				
			if(_tf.numLines > _tf.maxScrollV - _tf.scrollV)
			{
				if(bottomScroll)
					_tf.scrollV = _tf.maxScrollV;
				else 
					_tf.scrollV = prevScroll;
			}
		}
		
		public function get textField():TextField
		{
			return _tf;
		}
	}
}
