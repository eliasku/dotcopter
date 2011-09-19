package com.ek.audio
{
	import com.ek.asset.AssetLoader;
	import com.ek.asset.AssetManager;
	import com.ek.debug.Logger;
	import flash.media.SoundChannel;

	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	/**
	 * @author eliasku
	 */
	public class AudioLazy
	{
		private static var _loaders:Object = new Object();
		
		private static function playItem(item:String, loops:int, transform:SoundTransform):SoundChannel
		{
			var st:int;
			var ch:SoundChannel = null;
			var sfx:Sound;
			var loader:AssetLoader;
			
			if(transform)
			{
				st = AssetManager.getItemStatus(item);
				
				if(st & AssetManager.ITEM_FOUND)
				{
					if(st & AssetManager.ITEM_READY)
					{
						sfx = AssetManager.getSound(item);
					}
					else
					{
						if(!_loaders.hasOwnProperty(item))
						{
							loader = AssetManager.load([item]);
							loader.load();
							_loaders[item] = loader;
						}
					}
				}
				
				if(sfx)
				{
					try
					{
						ch = sfx.play(0.0, loops, transform);
					}
					catch(e:Error)
					{
						Logger.warning("[AudioLazy] " + e.message);
					}
				}
			}
			
			return ch;
		}
		
		public static function play(item:String, volume:Number = 1.0, pan:Number = 0.0):void
		{
			var st:SoundTransform = AudioManager.getSoundTransform(volume, pan);
			
			if(st)
			{
				playItem(item, 0, st);
			}
		}
		
		public static function loop(item:String, volume:Number = 1.0, pan:Number = 0.0):SoundChannel
		{
			var ch:SoundChannel = null;
			var st:SoundTransform = AudioManager.getSoundTransform(volume, pan);
			
			if(st)
			{
				ch = playItem(item, int.MAX_VALUE, st);
			}
			
			return ch;
		}
		
		public static function playAt(item:String, x:Number, y:Number, volume:Number = 1.0, pan:Number = 0.0):void
		{
			var st:SoundTransform = AudioManager.getPanorama(x, y, volume, pan);
			
			if(st)
			{
				playItem(item, 0, st);
			}
		}
		
		public static function setVolume(ch:SoundChannel, vol:Number):void
		{
			if (ch)
			{
				var st:SoundTransform = ch.soundTransform;
				if (st.volume == vol) return;
				
				if (vol <= 0)
				{
					st.volume = 0;
					ch.soundTransform = st;
				}
				else
				{
					st = AudioManager.getSoundTransform(vol);
					if (st)
					{
						ch.soundTransform = st;
					}
				}
			}
		}
		
	}
}
