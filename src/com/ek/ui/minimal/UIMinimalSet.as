package com.ek.ui.minimal 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author �������������
	 */
	public class UIMinimalSet
	{
		//U+0400-U+04CE,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183')]
		[Embed(source="../../../../../static/iFlash 705.ttf", fontName="iFlash 705", mimeType="application/x-font", embedAsCFF="false", unicodeRange='U+0400-U+04CE,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183,U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E')]
		static public var IFLASH705:Class;
		
		//[Embed(source="c:/WINDOWS/Fonts/MyriadPro-Semibold.otf", fontWeight="bold", fontName="_MyriadProLight", mimeType="application/x-font")]
        //public static var FONT_MYRIAD_PRO_L:Class;

		static public function getShadow(distance:Number = 2, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(distance, 45, SHADOW_COLOR, 1, distance, distance, 0.3, 1, knockout);
		}
		
		static public function getStroke(color:uint = 0x333333):BitmapFilter
		{
			return new DropShadowFilter(0.5, 90, color, 1.0, 1.2, 1.2, 30, 3);
		}
		
		static public function getStyleObject():Object
		{
			return { fontFamily:FONT_NAME, fontSize:FONT_SIZE, color:"#"+INPUT_TEXT };
		}
		
		static private var BACKGROUND:uint = 0xCCCCCC;
		static private var BUTTON_FACE:uint = 0xFFFFFF;
		static private var INPUT_TEXT:uint = 0x333333;
		static private var LABEL_TEXT:uint = 0x666666;
		static private var SHADOW_COLOR:uint = 0x000000;
		static private var PANEL:uint = 0xF3F3F3;
		static private var PROGRESS_BAR:uint = 0xFFFFFF;
		
		static private var EMBED_FONTS:Boolean = true;
		static private var FONT_NAME:String = "iFlash 705";
		static private var FONT_SIZE:Number = 8;
		
		static public function createLabel(x:int, y:int, text:String, color:uint, container:DisplayObjectContainer = null, name:String = null):TextField
		{
			var tf:TextField = new TextField();
			
			tf.name = "text";
			tf.selectable = false;
			setupTextField(tf, color);
			tf.text = text;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = x;
			tf.y = y;		
			
			if(name)
				tf.name = name;
				
			if(container)
				container.addChild(tf);
			
			return tf;
		}
		
		static public function createTextBoxContent(x:uint, y:uint, width:uint, height:uint, color:uint, container:DisplayObjectContainer = null, name:String = null):Sprite
		{
			var tf:TextField = new TextField();
			var back:Sprite = new Sprite();
			var result:Sprite = new Sprite();
			
			back.name = "back";
			back.filters = [getShadow(2, true)];
			back.graphics.clear();
			back.graphics.beginFill(color);
			back.graphics.drawRect(0, 0, width, height);
			back.graphics.endFill();
			
			tf.name = "text";
			tf.selectable = true;
			tf.type = TextFieldType.INPUT;
			setupTextField(tf, INPUT_TEXT);
			tf.text = "X";
			tf.width = width - 4;
			tf.height = Math.min(tf.textHeight + 4, height);
			tf.x = 2;
			tf.y = Math.round(height / 2 - tf.height / 2);
			tf.text = ""; 
						
			
			result.x = x;
			result.y = y;
			result.scrollRect = new Rectangle(0, 0, width, height);
			result.addChild(back);
			result.addChild(tf);
			
			
			if(name)
				result.name = name;
				
			if(container)
				container.addChild(result);
			
			return result;
		}
		
		static public function createSliderContent(x:uint, y:uint, width:uint, height:uint, container:DisplayObjectContainer = null, name:String = null):Sprite
		{
			var handle:Sprite = new Sprite();
			var back:Sprite = new Sprite();
			var result:Sprite = new Sprite();
			
			back.name = "back";
			back.filters = [getShadow(2, true)];
			back.graphics.clear();
			back.graphics.beginFill(BACKGROUND);
			back.graphics.drawRect(0, 0, width, height);
			back.graphics.endFill();
			
			handle.name = "handle";
			handle.filters = [getShadow(1, false)];
			handle.graphics.clear();
			handle.graphics.beginFill(BUTTON_FACE);
			if(width > height)
			{
				handle.graphics.drawRect(1, 1, height - 2, height - 2);
			}
			else
			{
				handle.graphics.drawRect(1, 1, width - 2, width - 2);
			}
			handle.graphics.endFill();			
			
			result.x = x;
			result.y = y;
			result.addChild(back);
			result.addChild(handle);
			
			if(name)
				result.name = name;
				
			if(container)
				container.addChild(result);
			
			return result;
		}
		
		static public function createButtonContent(x:uint, y:uint, width:uint, height:uint, text:String = null, container:DisplayObjectContainer = null, name:String = null):Sprite
		{
			var back:Sprite = new Sprite();
			var face:Sprite = new Sprite();
			var tf:TextField;
			var result:Sprite = new Sprite();
			
			back.name = "back";
			back.filters = [getShadow(2, true)];
			back.graphics.clear();
			back.graphics.beginFill(BACKGROUND);
			back.graphics.drawRect(0, 0, width, height);
			back.graphics.endFill();
			
			face.name = "face";
			face.filters = [getShadow(1, false)];
			face.graphics.clear();
			face.graphics.beginFill(BUTTON_FACE);
			face.graphics.drawRect(1, 1, width - 2, height - 2);
			face.graphics.endFill();
			face.mouseEnabled = false;
			
			if(text)
			{
				tf = new TextField();
				tf.name = "text";
				tf.selectable = false;
				tf.autoSize = TextFieldAutoSize.LEFT;
				setupTextField(tf, INPUT_TEXT);
				tf.text = text;
				tf.x = Math.round((width - tf.width) / 2);
				tf.y = Math.round((height - tf.height) / 2);
				//tf.border = true;
			}
			
			result.x = x;
			result.y = y;
			result.addChild(back);
			result.addChild(face);
			if(tf)
				result.addChild(tf);
			
			if(name)
				result.name = name;
				
			if(container)
				container.addChild(result);
			
			return result;
		}
		
		static public function createScrollBarContent(x:uint, y:uint, width:uint, height:uint, container:DisplayObjectContainer = null, name:String = null):Sprite
		{
			var result:Sprite = new Sprite();
			var button:Sprite;
			
			if(width > height)
			{
				createSliderContent(height, 0, width-height*2, height, result, "slider");
				
				button = createButtonContent(width-height, 0, height, height, null, result, "forward");
				addArrowIcon(button, 0.0);
				
				button = createButtonContent(0, 0, height, height, null, result, "backward");
				addArrowIcon(button, 180.0);
			}
			else
			{
				createSliderContent(0, width, width, height-width*2, result, "slider");
				
				button = createButtonContent(0, height-width, width, width, null, result, "forward");
				addArrowIcon(button, 90.0);
				
				button = createButtonContent(0, 0, width, width, null, result, "backward");
				addArrowIcon(button, -90.0);
			}
			
			result.x = x;
			result.y = y;
			
			if(name)
				result.name = name;
				
			if(container)
				container.addChild(result);
			
			return result;
		}

		static public function createTextAreaContent(x:int, y:int, width:int, height:int, color:uint, container:DisplayObjectContainer = null, name:String = null):Sprite 
		{
			var tf:TextField = new TextField();
			var back:Sprite = new Sprite();
			var result:Sprite = new Sprite();
			

			back.name = "back";
			//back.filters = [getShadow(2, true)];
			back.graphics.clear();
			back.graphics.beginFill(color);
			back.graphics.drawRect(0, 0, width-16, height);
			back.graphics.endFill();
			
			tf.name = "text";

			tf.selectable = true;
			tf.type = TextFieldType.DYNAMIC;
			setupTextField(tf, INPUT_TEXT);
			tf.width = width - 4;
			tf.height = height - 4;
			tf.x = 2;
			tf.y = 2;

			
			result.x = x;
			result.y = y;
			result.addChild(back);
			result.addChild(tf);
			
			createScrollBarContent(width-16, 0, 16, height, result, "scrollbar");
			
			if(name)
				result.name = name;
				
			if(container)
				container.addChild(result);
			
			return result;
		}
		
		static public function createPanelContent(x:int, y:int, width:int, height:int, container:DisplayObjectContainer = null, name:String = null):Sprite 
		{
			var result:Sprite = new Sprite();
			
			result.filters = [getShadow(2, false)];
			result.graphics.clear();
			result.graphics.lineStyle(1, 0, 0.1);
			result.graphics.beginFill(PANEL);
			result.graphics.drawRect(0, 0, width, height);
			result.graphics.endFill(); 

			result.x = x;
			result.y = y;
			
			if(name)
				result.name = name;
				
			if(container)
				container.addChild(result);
			
			return result;
		}
		
		static private function addArrowIcon(button:Sprite, angle:Number = 0.0):void
		{
			var icon:Sprite = new Sprite();
			
			icon.name = "icon";
			icon.filters = [getShadow(1, true)];
			drawArrow(icon.graphics, button.width, button.height, angle);
			button.addChild(icon);
		}
		
		static private function drawArrow(graphics:Graphics, width:int, height:int, angle:Number = 0.0):void
		{
			var rad:Number = angle*Math.PI/180;
			var i:int = 2;
			const hw:Number = width*0.5;
			const hh:Number = height*0.5;
			const size:Number = Math.min(hw, hh) - 4;
			const ox:Number = -Math.cos(rad)*size*0.2;
			const oy:Number = -Math.sin(rad)*size*0.2;
			
			graphics.beginFill(LABEL_TEXT);
			graphics.moveTo(hw + Math.cos(rad)*size + ox, hh + Math.sin(rad)*size + oy);
			while(i--)
			{
				rad += Math.PI*2.0/3.0;
				graphics.lineTo(hw + Math.cos(rad)*size + ox, hh + Math.sin(rad)*size + oy);
			}
			graphics.endFill();
		}
		
		static private function setupTextField(tf:TextField, color:uint):void
		{
			var format:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, color);
			
			tf.embedFonts = EMBED_FONTS;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.PIXEL;
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
		}
	}
}
