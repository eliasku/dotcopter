package com.ek.asset 
{
	import com.ek.debug.LogLevel;

	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.utils.ByteArray;

	/*
	 * Data Loader types:
	 * 
	 *  LoaderType.BINARY: content is ByteArray
	 *  LoaderType.TEXT: content is String 
	 *  LoaderType.XML: content is XML;
	 *  LoaderType.CSS: content is StyleSheet
	 *  
	 */
	internal class DataLoader extends BaseLoader 
	{
		public function DataLoader(url:String, type:String, antiCache:String = null, retryCount:int = 5)
		{
			switch(type)
			{
				case LoaderType.TEXT:
				case LoaderType.XML:
				case LoaderType.CSS:
				case LoaderType.BINARY:
					break;
				default:
					AssetManager.log(LogLevel.WARNING, "DataLoader not support '" + type + "' format. Loader type setted to 'binary' by default.");
					type = LoaderType.BINARY;
					break;
			}
			
			super(url, type, antiCache, retryCount);
		}

		public override function get bytesLoaded():uint
		{
			if(_loader)
				return (_loader as URLLoader).bytesLoaded;
				
			return 0;
		}
		
		public override function get bytesTotal():uint
		{
			if(_loader)
				return (_loader as URLLoader).bytesTotal;
				
			return 0;
		}
		
		protected override function _initializeLoader():void
		{
			_loader = new URLLoader();
			
			switch(_type)
			{
				case LoaderType.XML:
				case LoaderType.CSS:
				case LoaderType.TEXT:
					(_loader as URLLoader).dataFormat = URLLoaderDataFormat.TEXT;
					break;
				case LoaderType.BINARY:
					(_loader as URLLoader).dataFormat = URLLoaderDataFormat.BINARY;
					break;
			}
			
			_loaderEventDispatcher = _loader as IEventDispatcher;
			_loaderRequest = new URLRequest(requestURL);
		}
		
		protected override function _resolveContent():void
		{
			var urlLoader:URLLoader = _loader as URLLoader;
			
			switch(_type)
			{
				case LoaderType.TEXT:
					_content = urlLoader.data as String;
					break;
				case LoaderType.XML:
					_content = new XML(urlLoader.data as String);
					break;
				case LoaderType.CSS:
					_content = new StyleSheet();
					(_content as StyleSheet).parseCSS(urlLoader.data as String);
					break;
				case LoaderType.BINARY:
					_content = urlLoader.data as ByteArray;
					break;
			}
		}

		protected override function _startLoader():void
		{
			//DebugManager.message("start loading");
			(_loader as URLLoader).load(_loaderRequest);			
		}
		
		protected override function createEmbedContent(cls:Class):Boolean
		{
			var ba:ByteArray = (new cls()) as ByteArray;
			_content = XML(ba.readUTFBytes(ba.length));
			return true;
		}
	}
}
