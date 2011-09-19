package com.ek.ui 
{
	import com.ek.gocs.IComponentContainer;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * @author �������������
	 */
	public class UITextBox extends UIWrapper 
	{
		public function UITextBox(owner:IComponentContainer, content:Sprite)
		{
			super(owner, content);
			
			_back = content.getChildByName("back") as Sprite;
			_tf = content.getChildByName("text") as TextField;
			
			_tf.selectable = true;
			_tf.type = TextFieldType.INPUT;
			_tf.addEventListener(Event.CHANGE, changeHandler);
			
		}

		private function changeHandler(event:Event):void 
		{
			_text = _tf.text;
			/*
			if(_gotoIndex >= 0)
			{
				_tf.setSelection(_gotoIndex, _gotoIndex);
				trace("selection setted to ", _gotoIndex);
				_gotoIndex = -1;
			}*/
		}
		
		public function set text(value:String):void
		{
			_text = value;
			if(!_text) _text = "";
			_tf.text = _text;
			//invalidate();
		}
		
		public function get text():String
		{
			return _text;
		} 

		private var _back:Sprite;
		private var _tf:TextField;
		private var _text:String = "";
		//private var _gotoIndex:int = -1;
		
		public function get textField():TextField
		{
			return _tf;
		}
		/*
		public function gotoIndex(index:int):void
		{
			_gotoIndex = index;
			trace("setted ", index);
		}*/
	}
}
