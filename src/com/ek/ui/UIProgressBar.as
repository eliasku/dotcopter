package com.ek.ui 
{
	import com.ek.gocs.IComponentContainer;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author eliasku
	 */
	public class UIProgressBar extends UIWrapper 
	{
		private var _fillRC:Rectangle;
		private var _mask:Sprite;
		private var _fill:MovieClip;
		private var _tfText:TextField;
		private var _progress:Number;
		
		public function UIProgressBar(owner:IComponentContainer, content:MovieClip)
		{
			super(owner, content);
			
			var mask:Sprite = content["fill_mask"];
			
			_fill = content["fill"];
			
			if(mask)
			{
				_fillRC = new Rectangle(mask.x, mask.y, mask.width, mask.height);
				content.removeChild(mask);
			
				_mask = new Sprite();
				_mask.mouseChildren = false;
				_mask.mouseEnabled = false;
			
				content.addChild(_mask);
				
				_fill.mask = _mask;
			}
			else
			{
				_fillRC = new Rectangle(_fill.x, _fill.y, _fill.width, _fill.height);
			}

			_tfText = UIText.setup(content["tf_text"]);
			
			progress = 0.0;
		}
		
		public function set progress(value:Number):void
		{
			_progress = value;
			if(_mask)
			{
				_mask.graphics.clear();
				_mask.graphics.beginFill(0xffffff);
				_mask.graphics.drawRect(_fillRC.x, _fillRC.y, _fillRC.width * value, _fillRC.height);
				_mask.graphics.endFill();
			}
			else
			{
				if(_fill)
				{
					_fill.width = _fillRC.width * value;
				}
			}
		}
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set text(value:String):void
		{
			if(_tfText)
				_tfText.text = value;
		}
		
		public function get textField():TextField
		{
			return _tfText;
		}
		
		public function get fill():MovieClip
		{
			return _fill;
		}
	}
}
