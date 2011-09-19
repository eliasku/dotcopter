package com.ek.asset
{
	import com.ek.debug.LogLevel;
	import com.ek.debug.Logger;
	import com.ek.utils.ParserUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.system.Security;
	import flash.text.StyleSheet;

	/**
	 * @author eliasku
	 */
	public class AssetManager
	{
		public static const ITEM_NOT_FOUND:int = 0x1;
		public static const ITEM_FOUND:int = 0x6;
		public static const ITEM_NOT_READY:int = 0x2;
		public static const ITEM_READY:int = 0x4;
		
		public function AssetManager()
		{
			//initialize();
		}
		
		private static var _initialized:Boolean;
		public static function initialize():void
		{
			if(!_initialized)
			{
				registerLoader(LoaderType.BINARY, DataLoader, ["dat", "bin", ""]);
				registerLoader(LoaderType.TEXT, DataLoader, ["txt", "log"]);
				registerLoader(LoaderType.XML, DataLoader, ["xml"]);
				registerLoader(LoaderType.CSS, DataLoader, ["css"]);
		
				registerLoader(LoaderType.SWF, MediaLoader, ["swf"]);
				registerLoader(LoaderType.IMAGE, MediaLoader, ["jpg", "jpeg", "png", "gif"]);
				
				registerLoader(LoaderType.SOUND, SoundLoader, ["mp3", "wav"]);
				
				if(Security.sandboxType != Security.REMOTE)
					_retryCount = 0;
					
				_initialized = true;
			}
		}

		private static function registerLoader(type:String, cls:Class, extensions:Array):void
		{
			_typesLoader[type] = cls;
			for each (var ext:String in extensions)
				_typeExtensions[ext] = type;
		}

		public static function load(...rest:Array):AssetLoader
		{
			if(rest.length > 0)
			{
				if(rest[0])
				{
					if(rest[0] is String)
						return createBatchFromVector(Vector.<String>(rest));
					else if(rest[0] is Array)
						return createBatchFromVector(Vector.<String>(rest[0]));
					else if(rest[0] is Vector.<String>)
						return createBatchFromVector(rest[0]);
				}
			}
				
			return createBatchFromVector(null);
		}

		private static function createBatchFromVector(list:Vector.<String> = null):AssetLoader
		{
			var item:AssetItem;
			
			if(!list)
			{
				list = new Vector.<String>();
				for each (item in _items)
				{
					if(!item.lazy)
						list.push(item.id);
				}
			}
			
			if(list.length > 0)
				return createItemsBatch(list);
				
			return null;
		}

		public static function add(id:String, url:String, lazy:Boolean = false, definition:String = null, type:String = null, ignoreBaseURL:Boolean = false, caseSensitive:Boolean = false, antiCache:Boolean = true, group:String = null):void
		{
			var item:AssetItem = new AssetItem();
			
			item.id = id;
			item.url = url;
			item.lazy = lazy;
			item.def = definition;
			item.type = type;
			item.antiCache = antiCache;
			item.group = group;
			
			addItem(item, ignoreBaseURL, caseSensitive);
		}

		public static function addFromXML(xml:XML):void
		{
			if(!xml) return;
			
			var node:XML;
			
			if(xml.name() != "item")
			{
				for each (node in xml.item)
				{
					addItemFromXML(node);
				}
			}
			else
			{
				addItemFromXML(xml);
			}
		}

		public static function remove(itemId:String):void
		{
			var loader:BaseLoader;
			var item:AssetItem;
			var group:Array;
			var i:int;
			
			itemId = itemId.toLowerCase();
			
			if(_items.hasOwnProperty(itemId))
			{
				item = _items[itemId];
				delete _items[itemId];
				
				loader = getLoader(item.url);
				loader.decRefs();
				if(loader.refs == 0)
					delete _loaders[item.url];
					
				if(item.group && _groups.hasOwnProperty(item.group))
				{
					group = _groups[item.group];
					if(group)
					{
						i = group.indexOf(item.id);
						if(i >= 0)
							group.splice(i, 1);
						if(group.length == 0)
							delete _groups[item.group];
					}
				}
			}
			else
			{
				log(LogLevel.ERROR, "item '" + itemId + "' has not found");
			}
		}

		public static function embed(url:String, cls:Class, type:String = null):void
		{
			var loader:BaseLoader;
			
			url = AssetManager.generalizeURL(url, false);
			
			loader = getLoader(url);
			if(!loader)	loader = addLoader(url, type);
			if(loader) loader.embed(cls);
		}

		private static function createLoader(url:String, type:String = null, antiCache:Boolean = true):BaseLoader
		{
			var loader:BaseLoader;
			var ac:String;
			
			if(!type)
				type = guessLoaderType(url);
			
			if(_typesLoader.hasOwnProperty(type))
			{
				if(antiCache)
					ac = _antiCacheVersion;
					
				loader = ( new (_typesLoader[type])(url, type, ac, _retryCount) ) as BaseLoader;
			}

			return loader;
		}		

		private static function addItem(item:AssetItem, ignoreBaseURL:Boolean, caseSensitive:Boolean):void
		{
			var loader:BaseLoader;
			
			prepareItem(item, ignoreBaseURL, caseSensitive);
			
			if(_items.hasOwnProperty(item.id))
			{
				log(LogLevel.WARNING, "item '" + item.id + "' already described and has been replaced");
				remove(item.id);
			}
			
			_items[item.id] = item;
			
			if(item.group)
			{
				if(_groups.hasOwnProperty(item.group))
				{
					(_groups[item.group] as Array).push(item.id);
				}
				else
				{
					_groups[item.group] = [item.id];
				}
			}
			
			loader = getLoader(item.url);
				
			if(!loader)	loader = addLoader(item.url, item.type, item.antiCache);
			if(loader) loader.incRefs();
		}

		private static function addItemFromXML(xml:XML):void
		{
			var item:AssetItem = new AssetItem();
			var caseSensitive:Boolean;
			var ignoreBaseURL:Boolean;
			
			// item args
			if(xml.hasOwnProperty("@id"))
				item.id = xml.@id;
				
			if(xml.hasOwnProperty("@type"))
				item.type = xml.@type;
				
			if(xml.hasOwnProperty("@url"))
				item.url = xml.@url;
				
			if(xml.hasOwnProperty("@class"))
				item.def = xml["@class"];
				
			if(xml.hasOwnProperty("@lazy"))
				item.lazy = ParserUtil.parseBoolean(xml.@lazy);
			
			if(xml.hasOwnProperty("@anticache"))
				item.antiCache = ParserUtil.parseBoolean(xml.@anticache);
			
			if(xml.hasOwnProperty("@group"))
				item.group = xml.@group;
			
			// additional args
			if(xml.hasOwnProperty("@ignore_base_url"))
				ignoreBaseURL = ParserUtil.parseBoolean(xml.@ignore_base_url);
			
			if(xml.hasOwnProperty("@case_sensitive"))
				caseSensitive = ParserUtil.parseBoolean(xml.@case_sensitive);
				
			addItem(item, ignoreBaseURL, caseSensitive);
		}

		private static function getItem(id:String, generalize:Boolean = true):AssetItem
		{
			if(generalize)
				id = id.toLowerCase();
			
			if(_items.hasOwnProperty(id))
				return _items[id];
				
			return null;
		}
		
		/**
		 * Возвращает флаг статуса единицы ресурса.
		 * Можно определить готов или не готов ресурс, найден или не найден
		 */
		public static function getItemStatus(itemId:String):int
		{
			var status:int = ITEM_NOT_READY;
			var item:AssetItem = getItem(itemId);
			var loader:BaseLoader;

			if(item)
			{
				loader = getLoader(item.url);
				if(loader && loader.status == BaseLoader.READY)
				{
					status = ITEM_READY;
				}
			}
			else
			{
				status = ITEM_NOT_FOUND;
			}
			
			return status;
		}
		
		/**
		 * Возвращает группу ресурсов, массив item-идентификаторов (строки)
		 * Если группы нет, то возвращается null
		 */
		public static function getGroup(groupId:String):Array
		{
			if(_groups.hasOwnProperty(groupId))
			{
				return _groups[groupId] as Array;
			}
			
			return null;
		}

		private static function prepareItem(item:AssetItem, ignoreBaseURL:Boolean, caseSensitive:Boolean):void
		{
			if(item.url)
				item.url = generalizeURL(item.url, caseSensitive);
			
			// try to generate auto Id
			if(item.id == null)
			{
				if(item.def)
				{
					item.id = item.def;
				}
				else if(item.url)
				{
					// generate from url
					item.id = item.url.replace(/[\\\/]/g, "_");
				}
			}
			
			if(item.url)
			{
				if(!ignoreBaseURL)
					item.url = _assetURL + item.url;
			}
			else
				log(LogLevel.ERROR, "item '" + item.id + "' must have URL to asset file");
				
			if(!item.id)
				log(LogLevel.ERROR, "item have not ID, enable generateID property");
			
			item.id = item.id.toLowerCase();
		}

		private static function getLoader(url:String):BaseLoader
		{
			var loader:BaseLoader;
			
			if(_loaders.hasOwnProperty(url))
				loader = _loaders[url];
				
			return loader;
		}

		private static function addLoader(url:String, type:String = null, antiCache:Boolean = true):BaseLoader
		{
			var loader:BaseLoader = createLoader(url, type, antiCache);
			
			if(loader)
				_loaders[url] = loader;
				
			return loader;
		}

		
		// load list of items by generalized ids
		private static function createItemsBatch(list:Vector.<String>):AssetLoader
		{
			var batch:AssetLoader;
			var id:String;
			var item:AssetItem;
			var loader:BaseLoader;
			 
			for each (id in list)
			{
				// можно принимать null аргументы
				if(!id) continue;
				
				item = getItem(id);
				if(item)
				{
					loader = getLoader(item.url);
					if(loader.status != BaseLoader.READY)
					{
						if(!batch)
							batch = new AssetLoader();
							
						batch.addLoader(loader);
					}
				}
				else
					log(LogLevel.WARNING, "item '" + id + "' has not found and will be not available");
			}
			
			return batch;
		}

		public static function set assetURL(value:String):void
		{
			if(value)
			{
				value = generalizeURL(value, false);
				if( value.length > 0 && value.lastIndexOf("/") != value.length - 1)
				{
					value += "/";
				}
			}
			else
				value = "";
			
			_assetURL = value;
		}

		public static function get assetURL():String
		{
			return _assetURL;
		}

		// asset base url
		private static var _assetURL:String = "";
		
		// anti-cache feature, type and version
		private static var _antiCacheVersion:String = "";
		
		// default retry count
		private static var _retryCount:int = 5;

		// map<url, BaseLoader>
		private static var _loaders:Object = new Object();

		// map<itemId, AssetItem>
		private static var _items:Object = new Object();
		
		// map<groupId, Array of itemId>
		private static var _groups:Object = new Object();

		private static var _typeExtensions:Object = new Object();
		private static var _typesLoader:Object = new Object();

		public static function cleanup():void
		{
			_loaders = new Object();
			_items = new Object();
			_groups = new Object();
		}
		
		
		// guess suitable item type from url
		public static function guessLoaderType(url:String):String
		{
			const ext:String = getFileExtension(url);
			
			if(_typeExtensions.hasOwnProperty(ext))
				return _typeExtensions[ext];
				
			return LoaderType.UNKNOWN;
		}

		public static function getContent(itemId:String):Object
		{
			var item:AssetItem = getItem(itemId, true);
			var loader:BaseLoader;
			
			if(item)
			{
				loader = getLoader(item.url);
				if(loader)
					return loader.content;
			}
			
			return null;
		}

		public static function getStyleSheet(id:String):StyleSheet
		{
			return getContent(id) as StyleSheet;
		}

		public static function getXML(itemId:String):XML
		{
			return getContent(itemId) as XML;
		}
		
		public static function getBitmapData(itemId:String):BitmapData
		{
			var bitmap:Bitmap = getContent(itemId) as Bitmap;
			var bd:BitmapData;
			
			if(bitmap)
			{
				bd = bitmap.bitmapData;
				if(itemId.charAt(itemId.length-1) == "_" && bd.transparent)
				{
					processImage(bitmap, false);
					bd = bitmap.bitmapData;
				}
			}

			return bd;
		}
		
		private static function processImage(bitmap:Bitmap, alpha:Boolean):void
		{
			var bd:BitmapData = bitmap.bitmapData;
			var temp:BitmapData;
			var smoothing:Boolean = bitmap.smoothing;
			var pixelSnapping:String = bitmap.pixelSnapping;
			
			if(!alpha)
			{
				temp = new BitmapData(bd.width, bd.height, false, 0);
				temp.draw(bd);
				bitmap.bitmapData = temp;
				bitmap.smoothing = smoothing;
				bitmap.pixelSnapping = pixelSnapping;
			}
		}

		public static function getSound(itemId:String):Sound
		{
			return getContent(itemId) as Sound;
		}

		public static function getMovieClip(itemId:String, definition:String = null):MovieClip
		{
			var item:AssetItem = getItem(itemId, true);
			var loader:BaseLoader;
			var definitionName:String = definition;
			var result:MovieClip;
			
			if(item)
			{
				if(item.def)
					definitionName = item.def;
					
				loader = getLoader(item.url);
				if(loader && loader.type == LoaderType.SWF && loader.status == BaseLoader.READY)
				{
					result = createMovieClip(definitionName, (loader as MediaLoader).applicationDomain);
				}
			}

			if(!result)
			{
				log(LogLevel.WARNING, "can't create definition '" + definitionName + "' with item '" + itemId + "'");
			}
			
			return result;
		}
		
		public static function getItemDomain(itemId:String):ApplicationDomain
		{
			var item:AssetItem = getItem(itemId, true);
			var loader:BaseLoader;
			var result:ApplicationDomain;
			
			if(item)
			{
				loader = getLoader(item.url);
				if(loader && loader.type == LoaderType.SWF && loader.status == BaseLoader.READY)
				{
					result = (loader as MediaLoader).applicationDomain;
				}
			}

			if(!result)
			{
				log(LogLevel.WARNING, "item '" + itemId + "' has not application domain");
			}
			
			return result;
		}

		private static function createMovieClip(definition:String, applicationDomain:ApplicationDomain = null):MovieClip
		{
			var definitionClass:Class;
			var mc:MovieClip;
			
			if(!applicationDomain)
				applicationDomain = ApplicationDomain.currentDomain;
			
			if(applicationDomain.hasDefinition(definition))
			{
				try
				{
					definitionClass = applicationDomain.getDefinition(definition) as Class;
				}
				catch(e:Error)
				{
					log(LogLevel.WARNING, "createMovieClip, " + e.message);
				}
			}
			else
			{
				log(LogLevel.WARNING, "createMovieClip, target application domain has not definition '" + definition + "'");
			}
			
			if(definitionClass)
			{
				try
				{
					mc = (new definitionClass()) as MovieClip;
					//definitionClass = applicationDomain.getDefinition(definition) as Class;
				}
				catch(e:Error)
				{
					log(LogLevel.WARNING, "newMovieClip, " + e.message);
				}
			}

			return mc;
		}		

		public static function get antiCacheVersion():String
		{
			return _antiCacheVersion;
		}

		public static function set antiCacheVersion(value:String):void
		{
			_antiCacheVersion = value;
		}
		
		internal static function log(level:String, message:String):void
		{
			Logger.log(level, "[Asset] " + message);
		}
		
		
		// UTILITY METHODS
		
		// convert url string to filename
		/*private static function getFileName(url:String, cropExtension:Boolean = true):String
		{
			var indexEnd:int = url.indexOf("?");
			
			if(indexEnd < 0)
				indexEnd = url.length;
				
			var indexSlash:int = url.lastIndexOf("/", indexEnd) + 1;
						
			if(cropExtension)
			{
				var indexDot:int = url.lastIndexOf(".", indexEnd);
			
				if(indexDot <= indexSlash)
					indexDot = indexEnd;
					
				if(indexDot >= 0)
					return url.substring(indexSlash, indexDot);
			}
			
			return url.substring(indexSlash, indexEnd);
		}*/

		// retrive the file extension
		private static function getFileExtension(url:String):String
		{
			var indexEnd:int = url.indexOf("?");
			
			if(indexEnd < 0)
				indexEnd = url.length;
				
			const lastSlash:int = url.lastIndexOf("/", indexEnd);
			const indexStart:int = url.lastIndexOf(".", indexEnd);
			
			if(indexStart <= lastSlash)
				return "";
			
			return url.substring(indexStart + 1, indexEnd);
		}

		public static function generalizeURL(url:String, caseSensitive:Boolean):String
		{
			// descriptions and files must generalize their url string,
			// to avoid \ and / problems in urls
			if(url.indexOf("\\") >= 0)
				url = url.replace(/\\/g, '/');
			
			if(!caseSensitive)
				url = url.toLowerCase();
				
			return url;
		}
		
		/*public static function checkFileMask(fileName:String, fileMask:String):Boolean
		{
			fileName = generalizeURL(fileName, false);
			fileMask = generalizeURL(fileMask, false);
			
			fileMask = fileMask.replace(".", "[.]");
			fileMask = fileMask.replace("*", ".*");
			fileMask = fileMask.replace("?", ".");
			
			return fileName.search(new RegExp(fileMask)) == 0; 
		}*/
	}
}
