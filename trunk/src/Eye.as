package  
{
	import com.ek.asset.AssetManager;
	import land.Landscape;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class Eye extends Entity 
	{
		private var _speed:int = 2;
		private var _eye:Image;
		
		public function Eye(watch:Landscape) 
		{
			x = FP.width * 0.3;
			var down:int = watch.getPlaceOffset(x + 5);
			y = down - watch.spaceGap * 0.5;
			
			_eye = new Image(AssetManager.getBitmapData("gfx_eye_debug"));
			_eye.centerOrigin();
			graphic = _eye;
		}
		
		override public function update():void 
		{
			if (Input.check(Key.UP))
			{
				this.y -= _speed;
				_eye.angle = 180;
			}
			if (Input.check(Key.DOWN)) 
			{
				this.y += _speed;
				_eye.angle = 0;
			}
			if (Input.check(Key.LEFT))
			{
				this.x -= _speed;
				_eye.angle = 270;
			}
			if (Input.check(Key.RIGHT))
			{
				this.x += _speed;
				_eye.angle = 90;
			}
			
			super.update();
		}
		
	}

}