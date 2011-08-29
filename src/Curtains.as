package  
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Curtains extends Entity
	{
		public static const MODE_SQARE:String = "sqare";
		public static const MODE_HORIZONTAL:String = "vertical";
		public static const MODE_VERTICAL:String = "horizontal";
		
		private var _modes:Array = [MODE_HORIZONTAL, MODE_VERTICAL, MODE_SQARE];
		private var _curMode:String;
		
		private const BACK_W:int = 96;
		private const BACK_H:int = 86;
		
		private var _delay:int = 30;
		private var _dir:int = 1;
		
		private var _curtains:Image;
		
		private var _back:BitmapData;
		private var _hole:Shape;
		private var _holeMatrix:Matrix;
		
		private var _blindTime:Number = -1;
		private var _waitTime:Number = -1;
		
		public function Curtains()
		{
			_back = new BitmapData(BACK_W, BACK_H, true, 0xFFFFFFFF);
			
			_hole = new Shape();
			_holeMatrix = new Matrix();
			
			_curtains = new Image(_back);
			_curtains.scrollX = 0;
			_curtains.scrollY = 0;
			
			super(0, 0, _curtains);	
			
			open();
		}
		
		public function updateBlind(percent:Number):void
		{
			var holeSize:Number = GameSize.X1 * ((percent < 0) ? -percent : percent); //Math.abs(percent);
		
			_hole.graphics.clear();
			_hole.graphics.beginFill(0);
			_hole.graphics.drawRect(0, 0, holeSize, holeSize);
			_hole.graphics.endFill();
			
			_holeMatrix = new Matrix();
			_holeMatrix.translate((GameSize.X1 - holeSize) * 0.5, (GameSize.X1- holeSize) * 0.5);
			
			_back.fillRect(_back.rect, 0xFFFFFFFF);
			_back.draw(_hole, _holeMatrix, null, BlendMode.ERASE);
			
			_curtains = new Image(_back);
			_curtains.scrollX = 0;
			_curtains.scrollY = 0;
			graphic = _curtains;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (waiting())
			{
				if (_waitTime > 0)
				{
					_waitTime--;
					if (_waitTime == 0)
						_waitTime = -1;
				}
				
				if (_waitTime < 0)
					wait(-1);
			}
			
			if (isBlind())
			{
				if (_blindTime > 0)
				{
					_blindTime--;
					if (_blindTime == 0)
						_blindTime = -1;
				}
				
				if (_blindTime < 0)
					blind(-1);
				else
				{
					updateBlind(_dir - _blindTime / _delay);
				}
			}
		}
		
		private function isBlind():Boolean
		{
			return _blindTime >= 0;
		}
		
		private function blind(duration:int):void
		{
			_blindTime = duration;
			if (_blindTime < 0)
			{
				updateBlind(_dir);
				if (_dir == 0)
				{
					wait();
				}
			}
		}
		
		private function waiting():Boolean 
		{
			return _waitTime >= 0;
		}
		
		private function wait(time:int = 5):void 
		{
			_waitTime = time;
			if (_waitTime < 0)
			{
				CoptGame(FP.world).reset();
				open();
			}
		}
		
		private function chooseMode():void
		{
			_curMode = FP.choose(_modes);
		}
		
		public function open(delay:int = 20):void
		{
			_dir = 1;
			_delay = delay;
			blind(_delay);
		}
		
		public function close(delay:int = 30):void
		{
			_dir = 0;
			_delay = delay;
			blind(_delay);
		}
	}
}