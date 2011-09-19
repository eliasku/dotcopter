package com.ek.utils 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * @author eliasku
	 */
	public class SpriteUtil 
	{
		public static function testBitmaps(container:DisplayObjectContainer):Boolean
		{
			var i:int = container.numChildren - 1;
			var d:DisplayObject;
			var s:Shape;
			var bm:Bitmap;
			
			while(i >= 0)
			{
				
				d = container.getChildAt(i);
				if(d is Bitmap)
				{
					bm = d as Bitmap;
					if(bm.bitmapData)
					{
						if(bm.bitmapData.hitTest(new Point(), 0xFF, new Point(bm.mouseX, bm.mouseY)))
						{
							return true;
						}
					}
				}
				else if(d is Shape)
				{
					s = d as Shape;
					if(s.hitTestPoint(s.stage.mouseX, s.stage.mouseY, true))
						return true;
				}
				else if(d is DisplayObjectContainer)
				{
					if(testBitmaps(d as DisplayObjectContainer))
						return true;
				}
				--i;
			}
			
			return false;			
		}
	}
}
