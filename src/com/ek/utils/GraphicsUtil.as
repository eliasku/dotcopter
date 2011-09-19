package com.ek.utils 
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class GraphicsUtil 
	{
		public static function drawGradientEllipse(g:Graphics, rad:int):void 
		{
			var mat:Matrix = new Matrix();
			var colors:Array = [0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [1, 0];
			var ratios:Array = [200, 255];
			mat.createGradientBox(rad, rad, 0, -rad * 0.5, -rad * 0.5);
			
			g.clear();
			g.lineStyle();
			g.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, mat);
			g.drawEllipse(-rad*0.5, -rad*0.5, rad, rad);
			g.endFill();
		}

		/*
		* x,y the center position of the sector
		* r the radius of the sector
		* angle the angle of the sector
		* startFrom the start degree counting point : 270 top, 180 left, 0 right, 90 bottom ,
		* it is counting from top in this example.
		* color the fil lin color of the sector
		*/
		public static function drawSector(g:Graphics, x:Number, y:Number, r:Number, angle:Number = 0, startFrom:Number = 270, color:Number = 0x000000):void
		{
			g.clear();
			g.beginFill(color, 1);
			g.moveTo(x, y);
			
			angle = (Math.abs(angle) > 360) ? 360 : angle;
			
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			g.lineTo(x + r * Math.cos(startFrom), y + r * Math.sin(startFrom));
			
			var angleMid:Number, bx:Number, by:Number, cx:Number, cy:Number;
			for (var i:int = 1; i <= n; i++)
			{
				startFrom += angleA
				angleMid = startFrom - angleA * 0.5;
				bx = x + r / Math.cos(angleA * 0.5) * Math.cos(angleMid);
				by = y + r / Math.cos(angleA * 0.5) * Math.sin(angleMid);
				cx = x + r * Math.cos(startFrom);
				cy = y + r * Math.sin(startFrom);
				g.curveTo(bx, by, cx, cy);
			}
			if(angle != 360)
				g.lineTo(x, y);	
			g.endFill();
		}
		
		
	}

}