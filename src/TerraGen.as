package  
{
	import land.Landscape;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class TerraGen extends World 
	{
		private var _terrain:Landscape;
		private var _eye:Eye;
		
		public function TerraGen() 
		{
			_terrain = new Landscape();
			add(_terrain);
			
			_eye = new Eye(_terrain);
			add(_eye);
		}
		
		override public function update():void 
		{
			FP.camera.y = FP.clamp(_eye.y - FP.height * 0.5, 0, FP.height);
			super.update();
		}
		
	}

}