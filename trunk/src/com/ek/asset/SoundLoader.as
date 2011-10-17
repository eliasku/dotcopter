package com.ek.asset 
{
	import com.ek.debug.LogLevel;

	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/*
	 * Sound Loader types:
	 * 
	 *  LoaderType.SOUND: content is Sound 
	 *  
	 */
	internal class SoundLoader extends BaseLoader 
	{
		public function SoundLoader(url:String, type:String, antiCache:String = null, retryCount:int = 5)
		{
			switch(type)
			{
				case LoaderType.SOUND:
					break;
				default:
					AssetManager.log(LogLevel.ERROR, "SoundLoader supports only sound formats.");
					break;
			}
			
			super(url, type, antiCache, retryCount);
		}

		public override function get bytesLoaded():uint
		{
			if(_loader)
				return (_loader as Sound).bytesLoaded;
				
			return 0;
		}
		
		public override function get bytesTotal():uint
		{
			if(_loader)
				return (_loader as Sound).bytesTotal;
				
			return 0;
		}
		
		protected override function _initializeLoader():void
		{
			_loader = new Sound();
			_loaderEventDispatcher = _loader as IEventDispatcher;
			_loaderRequest = new URLRequest(requestURL);
			_loaderContext = new SoundLoaderContext();
		}
		
		protected override function _resolveContent():void
		{
			_content = _loader as Sound;
		}
		
		protected override function _startLoader():void
		{
			(_loader as Sound).load(_loaderRequest, _loaderContext as SoundLoaderContext);			
		}
		
		protected override function createEmbedContent(cls:Class):Boolean
		{
			return false;
		}
	}
}
