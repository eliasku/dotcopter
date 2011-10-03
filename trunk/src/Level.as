package  
{
	import draw.DrawingMethod;
	import draw.DrawingMode;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Level 
	{
		private static var _background:Array = ["gfx_bg_forest0"];
		private static var _foreground:Array = ["gfx_bg_forest1"];
		private static var _drawingMode:Array = [DrawingMode.DOUBLE, DrawingMode.SINGLE];
		private static var _drawingMethod:Array = [DrawingMethod.FRACTAL, DrawingMethod.COSINE, DrawingMethod.PERLIN];
		private static var _tile:Array = ["gfx_tile_mountain", "gfx_tile_sand", "gfx_tile_snow", "gfx_tile_stone", "gfx_tile_swamp"];
		private static var _outline:Array = ["gfx_outline_grass", "gfx_outline_ground", "gfx_outline_lava", "gfx_outline_snow", "gfx_outline_stone"];
		
		public static var background:String;
		public static var foreground:String;
		public static var stars:Boolean;
		public static var drawingMode:String;
		public static var drawingMethod:Class;
		public static var tile:String;
		public static var outline:String;
		public static var coins:Boolean;
		public static var turrets:Boolean;
		
		public static function randomize():void
		{
			background = FP.choose(_background);
			foreground = FP.choose(_foreground);
			
			stars = Math.random() < 0.5;
			
			drawingMode = FP.choose(_drawingMode);
			drawingMethod = FP.choose(_drawingMethod);
			
			tile = FP.choose(_tile);
			outline = FP.choose(_outline);
			
			coins =  Math.random() < 0.5;
			turrets =  Math.random() < 0.5;
		}
		
		public static function initialize():void
		{
			background = _background[0];
			foreground = _foreground[0];
			
			stars = true;
			
			drawingMode = _drawingMode[0];
			drawingMethod = _drawingMethod[0];
			
			tile = _tile[0];
			outline = _outline[0];
			
			coins =  true;
			turrets =  false;
		}
	}
}