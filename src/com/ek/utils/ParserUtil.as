package com.ek.utils
{
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	/**
	 * @author eliasku
	 */
	public class ParserUtil 
	{
		
		public static function parseMask(string:String):uint
		{
			var mask:uint = 0;
			var array:Array = string.split(" ");
			var ss:String;
			
			for each (ss in array)
				mask |= ( 1 << uint( parseInt(ss) ) );
			
			return mask;
		}
		
		public static function parseVector2(string:String, out:Vector2 = null):Vector2
		{
			var args:Array = string.split("; ");
			
			var x:Number = 0;
			var y:Number = 0;
			
			if(args.length > 0)
			{
				if(args.length > 1)
				{
					x = parseFloat(args[0]);
					y = parseFloat(args[1]);
				}
				else
				{
					x = y = parseFloat(args[0]);
				}
			}
			
			if(!out)
			{
				out = new Vector2();
			}
			
			out.x = x;
			out.y = y;
			
			return out;
		}
		
		
		public static function parseVector3(string:String, out:Vector3 = null):Vector3 
		{
			var args:Array = string.split("; ");
			
			var x:Number = 0;
			var y:Number = 0;
			var z:Number = 0;
			
			if(args.length > 0)
			{
				if(args.length > 1)
				{
					x = parseFloat(args[0]);
					y = parseFloat(args[1]);
					z = parseFloat(args[2]);
				}
				else
				{
					x = y = z = parseFloat(args[0]);
				}
			}
			
			if(!out)
			{
				out = new Vector3();
			}
			
			out.x = x;
			out.y = y;
			out.z = z;
			
			return out;
		}
		
		public static function parseColorTransform(string:String, out:ColorTransform = null):ColorTransform
		{
			var args:Array = string.split("; ");
			var arg:String;
			
			var mult:uint = 0xffffffff;
			var add:uint;
			
			const k:Number = 1/255;
			
			if(args.length > 0)
			{
				if(args.length > 1)
				{
					add = uint( parseInt(args[1]) );
				}
				
				arg = args[0];
				mult = uint( parseInt(arg) );
				
				if(arg.length < 9)
				{
					mult |= 0xff000000;
				}
			}
			
			if(!out)
			{
				out = new ColorTransform();
			}
			
			out.alphaMultiplier = k * ( 0xff & ( mult >> 24 ) );
			out.redMultiplier   = k * ( 0xff & ( mult >> 16 ) );
			out.greenMultiplier = k * ( 0xff & ( mult >> 8 ) );
			out.blueMultiplier  = k * ( 0xff & ( mult ) );
			
			out.alphaOffset     = 0xff & ( add >> 24 );
			out.redOffset       = 0xff & ( add >> 16 );
			out.greenOffset     = 0xff & ( add >> 8 );
			out.blueOffset      = 0xff & ( add );

			return out;
		}
		
		public static function parseRectangle(string:String, out:Rectangle = null):Rectangle
		{
			var args:Array = string.split("; ");
			
			var minx:Number = 0;
			var miny:Number = 0;
			var maxx:Number = 0;
			var maxy:Number = 0;
			
			if(args.length == 4)
			{
				minx = parseFloat(args[0]);
				miny = parseFloat(args[1]);
				maxx = parseFloat(args[2]);
				maxy = parseFloat(args[3]);
			}
			
			if(!out) out = new Rectangle();
			
			out.x = minx;
			out.y = miny;
			out.width = maxx - minx;
			out.height = maxy - miny;
			
			return out;
		}
		
		public static function parseBoolean(string:String):Boolean
		{			
			if(!string || string.length == 0) return false;

			const lcs:String = string.toLowerCase();
			
			return lcs=="true";
		}

	}
}
