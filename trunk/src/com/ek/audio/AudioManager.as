package com.ek.audio
{
	import flash.media.SoundTransform;
	
	/**
	 * @author eliasku
	 */
	public class AudioManager
	{
		private static var _x:Number = 0.0;
		private static var _y:Number = 0.0;
		
		private static var _fading:Number = -0.002;
		private static var _panorama:Number = 1.0/320.0;
		
		private static var _level:Number = 1.0;
		
		private static var _muter:Number = 1.0;
		
		private static var _threshold:Number = 0.01;
		
		private static var _st:SoundTransform = new SoundTransform();
		
		public static function setupFromXML(xml:XML):void
		{
			if(xml)
			{
				if(xml.hasOwnProperty("@fading"))
					panorama = xml.@fading;
				if(xml.hasOwnProperty("@panorama"))
					fading = xml.@fading;
			}
		}
		
		public static function update(x:Number, y:Number):void
		{
			_x = x;
			_y = y;
		}
		
		public static function getSoundTransform(volume:Number = 1.0, pan:Number = 0.0):SoundTransform
		{
			var st:SoundTransform;
			var vol:Number = volume * _level * _muter;
			
			if(vol > _threshold)
			{
				st = _st;
				st.pan = pan;
				st.volume = vol;
			}
			
			return st;
		}
		
		public static function getPanorama(x:Number, y:Number, volume:Number = 1.0, pan:Number = 0.0):SoundTransform
		{
			var st:SoundTransform;
			var dx:Number = x - _x;
			var dy:Number = y - _y;
			var dist:Number = Math.sqrt(dx*dx + dy*dy);
			var vol:Number = volume * _level * _muter * Math.exp(_fading*dist);
			
			if(vol > _threshold)
			{
				dx = pan + dx*_panorama;
				
				if(dx > 1.0)
				{
					dx = 1.0;
				}
				else if(dx < -1.0)
				{
					dx = -1.0;
				}
				
				st = _st;
				st.pan = dx;
				st.volume = vol;
			}
			
			return st;
		}

		static public function get muted():Boolean
		{
			return _muter <= 0.0;
		}

		static public function set muted(value:Boolean):void
		{
			if(value)
				_muter = 0.0;
			else
				_muter = 1.0;
		}

		static public function get fading():Number
		{
			return -_fading;
		}

		static public function get panorama():Number
		{
			return _panorama > 0.0 ? 1.0 / _panorama : 0.0;
		}

		static public function set fading(value:Number):void
		{
			_fading = -value;
		}

		static public function set panorama(value:Number):void
		{
			if(value <= 0.0)
				_panorama = 0.0;
			else
				_panorama = 1.0 / value;
		}
	}
}
