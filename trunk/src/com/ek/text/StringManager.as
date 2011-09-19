package com.ek.text 
{
	import com.ek.debug.Logger;
	import com.ek.utils.ParserUtil;

	import flash.text.StyleSheet;

	/**
	 * @author eliasku
	 */
	public class StringManager 
	{
		public static function initialize():void
		{
			_pforms["ru"] = pformRU;
			_pforms["en"] = pformEN;
		}
		
		public static function localize(text:String):String
		{
			if(_items.hasOwnProperty(text))
				return preprocess(_items[text].value);
			
			return preprocess(text);
		}
				
		public static function getText(id:String):String
		{
			if(_items.hasOwnProperty(id))
				return preprocess(_items[id].value);
			
			Logger.warning("[Strings] '" + id + "' not found");
			
			return "";
		}
		
		public static function getTextN(id:String, n:int):String
		{
			var item:StringItem;
			var pform:Function = _pforms[_lang];
			var i:int;
			
			if(_items.hasOwnProperty(id))
			{
				item = _items[id];
				if(pform && item.plurals && item.plurals.length > 0)
				{
					i = pform(n);
					if(i >= 0 && i < item.plurals.length)
					{
						return preprocess(item.plurals[i]);
					}
				}
				
				return preprocess(_items.value);
			}

			return "";
		}
		
		public static function format(text:String, ...rest):String
		{
			var len:uint = rest.length;
	        var args:Array;
			
			if(!text) return "";
			
			if (len == 1 && rest[0] is Array)
	        {
	            args = rest[0] as Array;
	            len = args.length;
	        }
	        else
	        {
	            args = rest;
	        }
				
			text = preprocess(text);
			
			if(len > 0)
				return substitute(text, args);
			
			return text; 
		}
		
		public static function hasText(id:String):Boolean
		{
			return _items.hasOwnProperty(id) && _items[id].value;
		}
		
		private static var _SUBREGEXP:Vector.<RegExp> = new Vector.<RegExp>();
		private static function substitute(str:String, args:Array):String
	    {
	        if(!str) return "";
	        
	        var len:uint = args.length;
	        var i:int;
	        
	        for ( ; i < len; ++i)
	        {
	        	if(_SUBREGEXP.length <= i)
	        		_SUBREGEXP.push( new RegExp("\\{"+i+"\\}", "g") );
	            str = str.replace(_SUBREGEXP[i], args[i]);
	        }
	
	        return str;
	    }
		
		private static function preprocess(text:String, depth:int = 0):String
		{
			var id:String;
			var ib:int = -1;
			var ie:int;
			
			if(depth >= REPLACE_DEPTH_MAX) return text;

			while(true)
			{
				ib = text.indexOf("{", ib + 1);
				ie = text.indexOf("}", ib + 1);
				if(ib >= 0 && ie > ib && ie < text.length)
				{
					id = text.substring(ib + 1, ie);
					if(_items.hasOwnProperty(id))
					{
						text = text.substring(0, ib) + 
								preprocess(_items[id].value, depth + 1) + 
								text.substring(ie + 1, text.length);
					}
				}
				else
				{
					break;
				}
			}
						
			return text;
		}
		
		private static const REPLACE_DEPTH_MAX:int = 3;
		
		public static function add(item:StringItem):void
		{
			if(!item.id) return;
			
			if(_items.hasOwnProperty(item.id))
				Logger.warning("[Strings] '" + item.id + "' already exists");
				
			_items[item.id] = item;
		}
		
		public static function addFromXML(xml:XML):void
		{
			var node:XML;
			var list:XMLList;
			var plur:XML;
			var item:StringItem;
			
			if(!xml) return;
			
			list = xml.children();
			
			for each (node in xml.string)
			{
				if(!node.hasOwnProperty("@id")) continue;
				
				item = new StringItem();
				item.id = node.@id;
				if(node.hasOwnProperty("@html"))
					item.html = ParserUtil.parseBoolean(node.@html);
				
				for each (plur in node.plural)
				{
					if(!item.plurals) item.plurals = new Vector.<String>();
					item.plurals.push(plur);
				}
				
				if(node.hasOwnProperty("@value")) item.value = node.@value;
				else item.value = node;
				
				add(item);
			}
			
			if(xml.hasOwnProperty("@lang")) _lang = xml.@lang;
			
			//XML.ignoreWhitespace = lastIgnoreWhitespaceSetting;
		}
		
		private static var _items:Object = new Object();
		private static var _lang:String = "ru";
		private static var _styleSheet:StyleSheet;
		//private static var _embedFonts:Object = new Object();
		
		public static function set styleSheet(value:StyleSheet):void
		{
			_styleSheet = value;
		}
		
		private static var _pforms:Object = new Object();
		
		private static function pformRU(n:int):int
		{
			return ( n%10==1 && n%100!=11 ) ? 0 : ( n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2 );
		}
		
		private static function pformEN(n:int):int
		{
			return ( n == 1 ? 0 : 1 );
		}

		public static function isHTML(id:String):Boolean
		{
			if(id && _items.hasOwnProperty(id))
				return _items[id].html;
			return false;
		}
		
		
	}
}
