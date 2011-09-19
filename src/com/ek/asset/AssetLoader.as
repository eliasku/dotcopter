package com.ek.asset 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author eliasku
	 */
	public class AssetLoader extends EventDispatcher 
	{
		public function AssetLoader()
		{
			super();
		}
		
		public function addLoader(loader:BaseLoader):void
		{
			if(_loaders.indexOf(loader) < 0)
				_loaders.push(loader);
		}
		
		public function load():void
		{
			var loader:BaseLoader;
		
			for each (loader in _loaders)
			{
				loader.addEventListener(Event.COMPLETE, finishHandler);
				loader.load();
			}
			
			_itemsTotal = _loaders.length;
			
			if(_itemsTotal == 0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		protected function finishHandler(event:Event):void
		{
			var loader:BaseLoader;
			var i:int;
			
			for ( i = 0; i < _loaders.length; ++i )
			{
				if(_loaders[i] == event.target)
				{
					loader = _loaders[i];
					break;
				}
			}
			
			if(loader)
			{
				if(loader.status == BaseLoader.FAILED)
				{
					if(_failedLoaders.indexOf(loader) < 0)
					{
						_failedLoaders.push(loader);
					}
				}
				loader.removeEventListener(Event.COMPLETE, finishHandler);
				_loaders.splice(i, 1);
				++_itemsLoaded;
			}
			
			if(_loaders.length == 0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function get progress():Number
		{
			var weight:Number = _itemsLoaded;
			
			for each ( var loader:BaseLoader in _loaders )
			{
				weight += loader.progress;
			}
			
			if(_itemsTotal > 0)
				return weight / _itemsTotal;
			
			return 1.0;
		}
		
		
		private var _loaders:Vector.<BaseLoader> = new Vector.<BaseLoader>();
		private var _itemsLoaded:int;
		private var _itemsTotal:int;


		private static var _failedLoaders:Vector.<BaseLoader> = new Vector.<BaseLoader>();
		
		public static function get failedLoaders():Array
		{
			var result:Array = [];
			var data:Object;
			var loader:BaseLoader;
			
			for each (loader in _failedLoaders)
			{
				data = {url:loader.url, attempts:loader.attempts, time:loader.totalTime};
				result.push(data);
			}
			
			return result;
		}
	}
}
