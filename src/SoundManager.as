package  
{
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Gleb Volkov
	 */
	public class SoundManager 
	{
		[Embed(source='../assets/sound/boom.mp3')] private static const BOOM:Class;
		[Embed(source = '../assets/sound/kick.mp3')] private static const KICK:Class;
		[Embed(source = '../assets/sound/lift_up.mp3')] private static const LIFT_UP:Class;
		[Embed(source = '../assets/sound/lift_down.mp3')] private static const LIFT_DOWN:Class;
		
		[Embed(source='../assets/sound/speed_up.mp3')] private static const SPEED_UP:Class;
		
		private static var _sounds:Object;
		
		public static function initialize():void
		{
			_sounds = { };
			
			addSound("boom", BOOM);
			addSound("kick", KICK);
			addSound("lift_up", LIFT_UP);
			addSound("lift_down", LIFT_DOWN);
			addSound("speed_up", SPEED_UP);
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
				sound.loop(vol, pan);
		}
		
		public static function setVolume(id:String, value:Number):void
		{
			var sound:Sfx = getSound(id);
			if (sound) 
				sound.volume = value;
		}
		
	}

}