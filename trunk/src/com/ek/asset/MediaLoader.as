package com.ek.asset 
{
	import com.ek.debug.LogLevel;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;

	/*
	 * Media Loader types:
	 * 
	 *  LoaderType.IMAGE: content is Bitmap
	 *  LoaderType.SWF: content is MovieClip 
	 *  
	 */
	internal class MediaLoader extends BaseLoader 
	{
		public function MediaLoader(url:String, type:String, antiCache:String = null, retryCount:int = 5)
		{
			switch(type)
			{
				case LoaderType.IMAGE:
				case LoaderType.SWF:
					break;
				default:
					AssetManager.log(LogLevel.ERROR, "MediaLoader supports only image and swf formats.");
					break;
			}
			
			super(url, type, antiCache, retryCount);
		}

		public override function get bytesLoaded():uint
		{
			if(_loader)
				return (_loader as Loader).contentLoaderInfo.bytesLoaded;
				
			return 0;
		}
		
		public override function get bytesTotal():uint
		{
			if(_loader)
				return (_loader as Loader).contentLoaderInfo.bytesTotal;
				
			return 0;
		}
		
		protected override function _initializeLoader():void
		{
			_loader = new Loader();
			_loaderEventDispatcher = (_loader as Loader).contentLoaderInfo;
			_loaderRequest = new URLRequest(requestURL);
			if(_type == LoaderType.IMAGE)
				_loaderContext = new LoaderContext(true);
			else
			{
				switch(Security.sandboxType)
				{
					case Security.REMOTE:
						_loaderContext = new LoaderContext(false, null, SecurityDomain.currentDomain);
						break;
					case Security.LOCAL_TRUSTED:
					case Security.LOCAL_WITH_FILE:
					case Security.LOCAL_WITH_NETWORK:
						_loaderContext = new LoaderContext(false);
						break;
				}
				
			}
		}
		
		protected override function _resolveContent():void
		{
			switch(_type)
			{
				case LoaderType.IMAGE:
					_content = (_loader as Loader).content as Bitmap;
					break;
				case LoaderType.SWF:
					_content = (_loader as Loader).content as MovieClip;
					break;
			}
		}
		
		protected override function _startLoader():void
		{
			(_loader as Loader).load(_loaderRequest, _loaderContext as LoaderContext);			
		}
		
		public function get applicationDomain():ApplicationDomain
		{
			return (_loader as Loader).contentLoaderInfo.applicationDomain;
		}
		
		protected override function createEmbedContent(cls:Class):Boolean
		{
			var ba:ByteArray = (new cls()) as ByteArray;
			if(_type != LoaderType.IMAGE)
			{
				var loader:Loader = new Loader();
				var context:LoaderContext = new LoaderContext(false);
				_loader = loader;
				_loaderContext = context;
				loader.loadBytes(ba, _loaderContext as LoaderContext);
				_resolveContent();
			}
			else
			{
				_content = new cls();
			}
			return true;
		}
	}
}
