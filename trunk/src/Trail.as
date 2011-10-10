package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Trail extends Graphiclist 
	{
		private var _smokeBlackEmitter:Emitter;
		private var _smokeWhiteEmitter:Emitter;
		
		private var _t:int = 0;
		
		public function Trail() 
		{
			var smokeParticle:Image = Image.createCircle(3, 0x333333);
			_smokeBlackEmitter = new Emitter(smokeParticle.source);
			
			_smokeBlackEmitter.newType("smoke", [0]);
			_smokeBlackEmitter.setAlpha("smoke");
			_smokeBlackEmitter.setMotion("smoke", 180-30, 0, 15, 60, 20, 5); //setMotion("step", 135, 12, 15, 90, 4, 5);
			_smokeBlackEmitter.setVelocity("smoke", new Point( -6, -1), new Point(5, 2));
			
			smokeParticle = Image.createCircle(2, 0xCCCCCC);
			_smokeWhiteEmitter = new Emitter(smokeParticle.source);
			_smokeWhiteEmitter.newType("smoke", [0]);
			_smokeWhiteEmitter.setAlpha("smoke");
			_smokeWhiteEmitter.setMotion("smoke", 180-30, 0, 10, 60, 20, 5); //setMotion("step", 135, 12, 15, 90, 4, 5);
			_smokeWhiteEmitter.setVelocity("smoke", new Point( -3, -1), new Point(2, 2));
			
			super(_smokeBlackEmitter, _smokeWhiteEmitter);
		}
		
		public function smoke(p:Point, lifes:int, maxLifes:int):void
		{
			var step_black:int = maxLifes - lifes + 2;
			var step_white:int = maxLifes - lifes;
			
			if (_t % step_white == 0)
				_smokeWhiteEmitter.emit("smoke", p.x - 4, p.y);
			
			if (step_white > 1 && _t % step_black == 0)
				_smokeBlackEmitter.emit("smoke", p.x - 6, p.y);
				
			_t++;
		}
		
	}

}