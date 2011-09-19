package com.ek.audio 
{
	import com.ek.asset.AssetManager;
	import com.ek.debug.Logger;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author eliasku
	 */
	public class Music 
	{
		private var _id:String;
		private var _sound:Sound;
		private var _loop:Boolean;
		//public var onComplete:Function;
		
		private var _channel:SoundChannel;
		private var _transform:SoundTransform = new SoundTransform();
		
		private var _volumeBegin:Number = 0.0;
		private var _volumeEnd:Number = 0.0;
		private var _volumeSpeed:Number = 1.0;
		private var _volumeProgress:Number = 1.0;
		
		public function Music(id:String, loop:Boolean)
		{
			_id = id;
			_loop = loop;
			_sound = AssetManager.getSound(id);
		}
				
		public function play(time:Number = 0.0):void
		{
			if(!_sound) return;
			
			var vol:Number;
			
			_volumeBegin = 0.0;
			_volumeEnd = 1.0;
				
			if(time > 0.0)
			{
				vol = 0.0;
				_volumeProgress = 0.0;
				_volumeSpeed = 1.0/time;
			}
			else
			{
				vol = 1.0;
				_volumeProgress = 1.0;
			}
			
			_transform.volume = vol * _musicVolume;
			
			if(_loop)
			{
				if(_channel)
				{
					_channel.soundTransform = _transform;
				}
				else
				{
					_channel = playSound(_sound, 99999, _transform);
				}
			}
			else
			{
				_channel = playSound(_sound, 0, _transform);
			}
		}
		
		private function playSound(sound:Sound, loops:int, transform:SoundTransform):SoundChannel
		{
			var ch:SoundChannel;
			
			try
			{
				ch = sound.play(0, loops, transform);
			}
			catch(e:Error)
			{
				Logger.warning("[Music] " + e.message);
			}
			
			return ch;
		}
		
		public function stop(time:Number = 0):void
		{
			if(!_sound) return;
			
			var vol:Number;
			
			_volumeBegin = _volumeBegin + (_volumeEnd - _volumeBegin)*_volumeProgress;
			_volumeEnd = 0;
				
			if(time > 0)
			{
				vol = _volumeBegin;
				_volumeProgress = 0;
				_volumeSpeed = 1/time;
			}
			else
			{
				vol = 0;
				_volumeProgress = 1;
			}

			if(_channel)
			{
				_transform.volume = vol * _musicVolume;
				_channel.soundTransform = _transform;
				if( vol <= 0 )
				{
					_channel.stop();
					_channel = null;
				}
			}
		}
		
		private function update(dt:Number):void
		{
			if(!_sound) return;
			
			if(_volumeProgress < 1)
			{
				_volumeProgress += dt * _volumeSpeed;
				if(_volumeProgress > 1)
				{
					_volumeProgress = 1;
				}
	
				updateVolume();
			}
		}
		
		private function updateVolume():void
		{
			if(!_sound) return;
			
			var vol:Number = _volumeBegin + (_volumeEnd - _volumeBegin)*_volumeProgress;
				
			if(_channel)
			{
				_transform.volume = vol * _musicVolume;
				_channel.soundTransform = _transform;
				if(vol <=0 )
				{
					_channel.stop();
					_channel = null;
				}
			}
		}
		
		private static var _lookup:Object = new Object();
		private static var _playlist:Vector.<Music> = new Vector.<Music>();
		private static var _musicVolume:Number = 1.0;
		private static var _muted:Boolean;
		
		public static function update(dt:Number):void
		{
			for each (var track:Music in _playlist)
				track.update(dt);
		}
		
		public static function setVolume(volume:Number):void
		{
			_musicVolume = volume;
			
			for each (var track:Music in _playlist)
				track.updateVolume();
		}
		
		public static function getVolume():Number
		{
			return _musicVolume;
		}
		
		public static function stopAll(time:Number):void
		{
			for each (var track:Music in _playlist)
				track.stop(time);
		}
		
		public static function add(id:String, loop:Boolean = true):void
		{
			var track:Music = new Music(id, loop);
			_playlist.push(track);
			_lookup[id] = track;
		}
		
		public static function getMusic(id:String):Music
		{
			return _lookup[id];
		}
		
		public static function hasMusic(id:String):Boolean
		{
			return _lookup.hasOwnProperty(id);
		}
		
		static public function get muted():Boolean
		{
			return _muted;
		}

		static public function set muted(value:Boolean):void
		{
			_muted = value;
		}
	}
}
