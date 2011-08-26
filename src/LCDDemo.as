package
{
	import flash.filters.GlowFilter;
	import com.ek.core.CoreManager;
	import com.ek.gocs.GameObject;

	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	/**
	 * @author Ilya.Kuzmichev
	 */
	public class LCDDemo extends GameObject
	{
		private var _screen:LCDScreen;
		
		private var _testNoise:BitmapData = new BitmapData(96, 96, true, 0x0);
		
		
		private var cx:Number = 0.0;
		private var cy:Number = 0.0;
		
		private var shape:Shape = new Shape();
		
		public function LCDDemo()
		{
			_screen = new LCDScreen();
			_screen.x = 100;
			addChild(_screen);
			
			CoreManager.root.addChild(this);
			
			shape.graphics.beginFill(0x00ff00);
			shape.graphics.drawCircle(0, 0, 2);
			shape.graphics.drawRect(-4, -4, 2, 10);
			shape.graphics.endFill();
			shape.graphics.beginFill(0xffff00);
			shape.graphics.drawCircle(0, 0, 1);
			shape.graphics.drawRect(-4, -4, 1, 10);
			shape.graphics.endFill();
			shape.filters = [new GlowFilter(0xffffff, 1.0, 1.4, 1.4, 8, 2)];
		}
		
		public override function tick(dt:Number):void
		{
			super.tick(dt);
			var m:Matrix = new Matrix();
			
			cx += dt*8;
			cy += dt*8;
			
			if(cx > 96) cx = 0;
			if(cy > 96) cy = 0;
			
			shape.rotation += 90*dt;
			
			m.rotate(shape.rotation*Math.PI/180);
			m.translate(cx, cy);
			_testNoise.fillRect(_testNoise.rect, 0x0);
			_testNoise.noise(getTimer()*Math.random());
			_testNoise.draw(shape, m, null, null, null, true);
			_screen.draw(_testNoise, _testNoise.rect);
		}

		private static var _instance:LCDDemo;
		public static function initialize():void
		{
			_instance = new LCDDemo();
		}
		
	}
}
