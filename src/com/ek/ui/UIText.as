package com.ek.ui 
{
	import com.ek.debug.Logger;
	import com.ek.gocs.IComponentContainer;
	import com.ek.text.StringManager;
	import com.ek.utils.StringUtil;

	import flash.display.MovieClip;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	/**
	 * @author eliasku
	 */
	public class UIText extends UIWrapper 
	{
		public function UIText(owner:IComponentContainer, content:MovieClip)
		{
			super(owner, content);
		}
		
		static public var aaSharpness:Number = -200.0;
		static public var aaThickness:Number = 0.0;
		static private var _styles:StyleSheet;
		
		
		static public function setup(textField:Object, advancedAntialiasing:Boolean = true):TextField
		{
			var tf:TextField = textField as TextField;
			var format:TextFormat;
			var font:String;
			
			if(!tf)
				return null;
			
			if(!_embedFonts)
				updateFonts();
			
			format = tf.getTextFormat();
			if(!format)
				format = tf.defaultTextFormat;
			
			if(format && format.font)
			{
				tf.defaultTextFormat = format;
				format = tf.defaultTextFormat;
				
				font = "_" + StringUtil.stripSpaces(format.font);
				if(format.bold)
				{
					if(_embedFonts.hasOwnProperty(font + "_bold"))
						font += "_bold";
				}
				else
				{
					if(!_embedFonts.hasOwnProperty(font) && _embedFonts.hasOwnProperty(font + "_bold"))
					{
						font += "_bold";
						format.bold = true;
					}
				}
				
				if(_embedFonts.hasOwnProperty(font))
				{
					//tf.autoSize = format.align;
					tf.embedFonts = true;
					
					if(advancedAntialiasing)
						tf.antiAliasType = AntiAliasType.ADVANCED;
					else
						tf.antiAliasType = AntiAliasType.NORMAL;
						
					format.font = font;
				}
				else
				{
					Logger.warning("[UIText] Font '" + format.font + "' not found. Continue with device font.")
				}

				tf.selectable = false;
				
				tf.setTextFormat(format);
				tf.defaultTextFormat = format;
				
				//tf.cacheAsBitmap = true;
			}
			else
			{
				Logger.warning("[UIText] Invalid TextFormat.");
			}
			
			tf.mouseEnabled = false;
			tf.mouseWheelEnabled = false;
			tf.tabEnabled = false;
			
			return tf;
		}
		
		static public function setHtml(textField:TextField, text:String):void
		{
			if(textField)
			{
				if(textField.embedFonts)
				{
					textField.htmlText = text;
					//if(textField.embedFonts)
						//setupHtmlFonts(textField);
				}
			}
		}
		
		static public function setLocaleString(textField:TextField, id:String, ...args):void
		{
			var text:String;
			
			if(textField)
			{
				text = StringManager.format(StringManager.getText(id), args);
				
				if(StringManager.isHTML(id))
					textField.htmlText = text;
				else
					textField.text = text;
			}
		}
			
		static public function registerFont(definition:Object):void
		{
			var fontCls:Class;
			if(definition is Class) fontCls = definition as Class;
			else if(definition is String) fontCls = getDefinitionByName(definition as String) as Class;
			
			if(fontCls)
			{
				Font.registerFont(fontCls);
			}
			
			updateFonts();
		}
		
		static private function updateFonts():void
		{
			var fonts:Array = Font.enumerateFonts();
			var font:Font;
			
			_embedFonts = new Object();
			
			for each (font in fonts)
			{
				if(font.fontName)
					_embedFonts[font.fontName] = font;
			}
		}

		static private var _embedFonts:Object;

		static public function get styles():StyleSheet
		{
			return _styles;
		}

		static public function set styles(value:StyleSheet):void
		{
			_styles = value;
		}
	}
}
