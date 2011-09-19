package com.ek.asset 
{
	import com.ek.debug.LogLevel;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	/**
	 * @author eliasku
	 */
	internal class BaseLoader extends EventDispatcher
	{
		public static const WAITING:int = 0x0;
		public static const LOADING:int = 0x1;
		public static const READY:int = 0x2;
		public static const FAILED:int = 0x3;
		
		// owner manager
		//protected var _asset:AssetManager;
		
		// loader reference count
		private var _refs:int;
		
		// total loading time
		private var _totalTime:int;
		
		// start time
		private var _startTime:int;
		
		// retry counter
		private var _retryCount:int;
		
		// attemps to load count
		private var _attempts:int;
		
		// loader status
		private var _status:int;
		
		// URL to resource file
		protected var _url:String;
		
		// loaded content depends on resource type
		protected var _content:Object;
		
		// loader type
		protected var _type:String;
		
		// anti-cache code
		protected var _ac:String;
		
		// handled loader's items
		protected var _loader:Object;
		protected var _loaderEventDispatcher:IEventDispatcher;
		protected var _loaderContext:Object;
		protected var _loaderRequest:URLRequest;
		private var _listenersAttached:Boolean;
		
		public function BaseLoader(url:String, type:String = LoaderType.UNKNOWN, antiCache:String = null, retryCount:int = 5)
		{
			super();
		
			//_asset = asset;
			_url = url;
			_type = type;
			//_status = LoaderStatus.WAITING;
			_ac = antiCache;
			_retryCount = retryCount;
		}
		
		/*public function get ready():Boolean { return _status == LoaderStatus.READY; }
		public function get failed():Boolean { return _status == LoaderStatus.FAILED; }
		public function get loading():Boolean { return _status == LoaderStatus.LOADING; }*/
		
		public function get content():Object
		{
			return _content;
		}
		
		public function get url():String
		{
			return _url;
		}

		public function incRefs():void { ++_refs; }
		public function decRefs():void { --_refs; }
		public function get refs():int { return _refs; }
		
		public function embed(cls:Class):void
		{
			if(createEmbedContent(cls))
				_status = READY;
			else
				_status = FAILED;
		}
		
		protected function createEmbedContent(cls:Class):Boolean
		{
			return false;
		}
		
		public function load():void
		{
			switch(_status)
			{
				case WAITING:
				case FAILED:
					_attempts = 0;
					_startTime = getTimer();
					_status = LOADING;
					doLoad();
					break;
				case READY:
					dispatchEvent(new Event(Event.COMPLETE));
					break;
			}
		}
		
		public function get bytesLoaded():uint
		{
			if(_loader)
				return _loader["bytesLoaded"];
			
			return 0;
		}
		
		public function get bytesTotal():uint
		{
			if(_loader)
				return _loader["bytesTotal"];
			
			return 0;
		}
		
		public function get progress():Number
		{
			if(bytesTotal > 0)
				return Number(bytesLoaded / bytesTotal);
			
			return 0.0;
		}
		
		protected function doLoad():void
		{
			_attempts++;
			
			try
			{
				cleanupLoader();
				
				_initializeLoader();
				
				if(!_listenersAttached && _loaderEventDispatcher)
				{
					_loaderEventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
					_loaderEventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
					_loaderEventDispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
					_loaderEventDispatcher.addEventListener(IOErrorEvent.DISK_ERROR, errorHandler);
					_loaderEventDispatcher.addEventListener(IOErrorEvent.NETWORK_ERROR, errorHandler);
					_loaderEventDispatcher.addEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
					_loaderEventDispatcher.addEventListener(Event.COMPLETE, completeHandler);
					_listenersAttached = true;
				}
				
				_startLoader();
			}
			catch (error:Error)
	        {
				errorHandler(new ErrorEvent(ErrorEvent.ERROR, false, false, error.name + ": " + error.message));
			}
		}

		private function onHTTPStatus(e:HTTPStatusEvent):void 
		{
			if(e.status > 0 && !(e.status == 200 || e.status == 304))
			{
				AssetManager.log(LogLevel.WARNING, "HTTP status: " + e.status);
				//errorHandler(new ErrorEvent(ErrorEvent.ERROR, false, false, "http status: " + ));
			}
		}

		protected function errorHandler(e:ErrorEvent):void
		{
			if(_status == LOADING)
			{
				if(e)
				{
					if(e is SecurityErrorEvent)
						AssetManager.log(LogLevel.WARNING, "sec: " + e.target + "  " + (e as SecurityErrorEvent).text);
					else if(e is IOErrorEvent)
						AssetManager.log(LogLevel.WARNING, "io: " + e.target + "  " + (e as IOErrorEvent).text);
					else
						AssetManager.log(LogLevel.WARNING, "def: " + e.target + "  " + e.text);
					AssetManager.log(LogLevel.WARNING, "item url: " + _url);
					AssetManager.log(LogLevel.WARNING, "item type: " + _type);
				}
				
				if(_attempts <= _retryCount)
				{
					doLoad();
				}
				else
				{
					_status = FAILED;
					_totalTime = getTimer() - _startTime;
					dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		protected function completeHandler(e:Event):void
		{
			try
			{
				_resolveContent();
			}
			catch (e:Error)
			{
				errorHandler(new ErrorEvent(ErrorEvent.ERROR, false, false, e.name + ": " + e.message));
				return;
			}
			
			_totalTime = getTimer() - _startTime;
			cleanupListeners();
			_status = READY;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function cleanupListeners():void
		{
			if(_listenersAttached && _loaderEventDispatcher)
			{
				_loaderEventDispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
				_loaderEventDispatcher.removeEventListener(IOErrorEvent.DISK_ERROR, errorHandler);
				_loaderEventDispatcher.removeEventListener(IOErrorEvent.NETWORK_ERROR, errorHandler);
				_loaderEventDispatcher.removeEventListener(IOErrorEvent.VERIFY_ERROR, errorHandler);
				_loaderEventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				_loaderEventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_loaderEventDispatcher.removeEventListener(Event.COMPLETE, completeHandler);
				_listenersAttached = false;
			}
		}
		
		private function cleanupLoader():void
		{
			// clean all except loader object to gain useful info later (domain, bytes loaded, etc)

			cleanupListeners();
			
			_loaderEventDispatcher = null;
			_loaderContext = null;
			_loaderRequest = null;
		}
		
		protected function _initializeLoader():void
		{
		}
		
		protected function _resolveContent():void
		{
		}
		
		protected function _startLoader():void
		{
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get requestURL():String
		{
			if(_ac && _ac.length > 0)
				return _url + "?" + _ac;
			return _url;
		}

		public function get attempts():int
		{
			return _attempts;
		}

		public function get totalTime():int
		{
			return _totalTime;
		}

		public function get status():int
		{
			return _status;
		}
		
	}
}
