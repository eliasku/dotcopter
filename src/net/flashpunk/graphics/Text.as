package net.flashpunk.graphics 
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	
	/**
	 * Used for drawing text using embedded fonts.
	 */
	public class Text extends Image
	{
		/**
		 * The font to assign to new Text objects.
		 */
		public static var font:String = "default";
		
		/**
		 * The font size to assign to new Text objects.
		 */
		public static var size:uint = 16;
		
		/**
		 * Constructor.
		 * @param	text		Text to display.
		 * @param	x			X offset.
		 * @param	y			Y offset.
		 * @param	width		Image width (leave as 0 to size to the starting text string).
		 * @param	height		Image height (leave as 0 to size to the starting text string).
		 */
		public function Text(text:String, x:Number = 0, y:Number = 0, width:uint = 0, height:uint = 0, dropShadow:Boolean = false)
		{
			_field.embedFonts = true;
			_field.defaultTextFormat = _form = new TextFormat(Text.font, Text.size, 0xFFFFFF);
			_field.text = _text = text;
			if (!width) width = _field.textWidth + 4;
			if (!height) height = _field.textHeight + 4;
			_source = new BitmapData(width, height, true, 0);
			super(_source);
			updateBuffer();
			this.x = x;
			this.y = y;
			
			_dropShadow = dropShadow;
			if (_dropShadow)
			{
				_shadowMatrix = new Matrix();
				_shadowMatrix.translate(1, 1);
				_shadowColorTransform = new ColorTransform();
				_shadowColorTransform.color = 0x000000;
			}
		}
		
		/** @private Updates the drawing buffer. */
		override public function updateBuffer(clearBefore:Boolean = false):void 
		{
			_field.setTextFormat(_form);
			_field.width = _width = _field.textWidth + 4;
			_field.height = _height = _field.textHeight + 4;
			_source.fillRect(_sourceRect, 0);
			
			if (_dropShadow)
				_source.draw(_field, _shadowMatrix, _shadowColorTransform);
			
			_source.draw(_field);
			
			
			super.updateBuffer(clearBefore);
		}
		
		/** @private Centers the Text's originX/Y to its center. */
		override public function centerOrigin():void 
		{
			originX = _width / 2;
			originY = _height / 2;
		}
		
		/**
		 * Text string.
		 */
		public function get text():String { return _text; }
		public function set text(value:String):void
		{
			if (_text == value) return;
			_field.text = _text = value;
			updateBuffer();
		}
		
		/**
		 * Font family.
		 */
		public function get font():String { return _font; }
		public function set font(value:String):void
		{
			if (_font == value) return;
			_form.font = _font = value;
			updateBuffer();
		}
		
		/**
		 * Font size.
		 */
		public function get size():uint { return _size; }
		public function set size(value:uint):void
		{
			if (_size == value) return;
			_form.size = _size = value;
			updateBuffer();
		}
		
		/**
		 * Width of the text image.
		 */
		override public function get width():uint { return _width; }
		
		/**
		 * Height of the text image.
		 */
		override public function get height():uint { return _height; }
		
		// Text information.
		/** @private */ private var _field:TextField = new TextField;
		/** @private */ private var _width:uint;
		/** @private */ private var _height:uint;
		/** @private */ private var _form:TextFormat;
		/** @private */ private var _text:String;
		/** @private */ private var _font:String;
		/** @private */ private var _size:uint;
		
		/** @private */ private var _dropShadow:Boolean;
		/** @private */ private var _shadowMatrix:Matrix;
		/** @private */ private var _shadowColorTransform:ColorTransform;
		
		// Default font family.
		// Use this option when compiling with Flex SDK 3 or lower
		// [Embed(source = '04B_03__.TTF', fontFamily = 'default')]
		// Use this option when compiling with Flex SDK 4
		[Embed(source = '04B_03__.TTF', embedAsCFF="false", fontFamily = 'default')]
		/** @private */ private static var _FONT_DEFAULT:Class;
	}
}