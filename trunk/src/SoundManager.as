package  
{
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class SoundManager 
	{
		[Embed(source='../assets/sound/kick.mp3')] private static const KICK:Class;
		
		private static var _sounds:Object;
		
		public static function initialize():void
		{
			_sounds = { };
			
			addSound("kick", KICK);
		}
		
		private static function addSound(id:String, link:Class):void
		{
			if (!_sounds.hasOwnProperty(id))
				_sounds[id] = new Sfx(link);
		}
		
		private static function getSound(id:String):Sfx
		{
			var sound:Sfx = null;
			if (_sounds.hasOwnProperty(id))
				sound = _sounds[id];
			return sound;
		}
		
		public static function play(id:String, vol:Number = 1.0, pan:Number = 0.0):void
		{
			var sound:Sfx = getSound(id);
			if (sound)
				sound.play(vol, pan);
		}
		
		public static function loop(id:String, vol:Number = 1.0, pan:Number = 0.0):void
		{
			var sound:Sfx = getSound(id);
			if (sound) 
				sound.loop();
		}
		
		public static function setVolume(id:String, value:Number):void
		{
			var sound:Sfx = getSound(id);
			if (sound) 
				sound.volume = value;
		}
		
	}

}