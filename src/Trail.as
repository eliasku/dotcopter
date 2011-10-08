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
			_smokeBlackEmitter.setMotion("smoke", 135, 1, 15, 90, 0, 5); //setMotion("step", 135, 12, 15, 90, 4, 5);
			_smokeBlackEmitter.setVelocity("smoke", new Point( -6, 0), new Point(0, 0));
			
			smokeParticle = Image.createCircle(2, 0xCCCCCC);
			_smokeWhiteEmitter = new Emitter(smokeParticle.source);
			_smokeWhiteEmitter.newType("smoke", [0]);
			_smokeWhiteEmitter.setAlpha("smoke");
			_smokeWhiteEmitter.setMotion("smoke", 135, 0, 10, 90, 0, 5); //setMotion("step", 135, 12, 15, 90, 4, 5);
			_smokeWhiteEmitter.setVelocity("smoke", new Point( -3, 0), new Point(0, 0));
			
			super(_smokeBlackEmitter, _smokeWhiteEmitter);
		}
		
		public function smoke(p:Point):void
		{
			_smokeBlackEmitter.emit("smoke", p.x - 4, p.y);
			
			_t++;
			if (_t % 2 == 0)
				_smokeWhiteEmitter.emit("smoke", p.x - 4, p.y);
		}
		
	}

}