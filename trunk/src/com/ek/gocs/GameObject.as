package com.ek.gocs 
{
	import com.ek.debug.Logger;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author eliasku
	 */
	public class GameObject extends Sprite implements IComponentContainer
	{
		public function GameObject()
		{
			super();
		}

		public function tick(dt:Number):void
		{
			for each ( var goc:Component in _components )
			{
				goc.tick(dt);
			}
			
			for ( var child:GameObject = _children; child; child = _iter )
			{
				_iter = child._next;
				child.tick(dt);
			}
		}

		public function slowTick():void
		{
			for each ( var goc:Component in _components )
			{
				goc.slowTick();
			}
			
			for ( var child:GameObject = _children; child; child = _iter )
			{
				_iter = child._next;
				child.slowTick();
			}
		}

		protected function onAdded():void
		{
			
		}

		protected function onRootJoin():void
		{
			_joined = true;
			
			for(var child:GameObject = _children; child; child = _iter)
			{
				_iter = child._next;
				child.onRootJoin();
			}
		}

		protected function onRootExit():void
		{
			for(var child:GameObject = _children; child; child = _iter)
			{
				_iter = child._next;
				child.onRootExit();
			}

			_joined = false;
		}

		protected function onRemoved():void
		{
		}

		private function _addGameObject(go:GameObject):void
		{
			if(_children) _children._prev = go;
			go._next = _children;
			go._prev = null;
			_children = go;
			
			go.onAdded();
			
			if(_joined)
				go.onRootJoin();
		}

		private function _removeGameObject(go:GameObject):void
		{
			if(_joined)
				go.onRootExit();

			go.onRemoved();
			
			if(go == _children) _children = go._next;
			if(go == _iter) _iter = go._next;
			if(go._next) go._next._prev = go._prev;
			if(go._prev) go._prev._next = go._next;
		}


		public override function addChild(child:DisplayObject):DisplayObject
		{
			if(child.parent)
			{
				Logger.error("[GameObject.addChild] Object already has parent object.");
				return child;
			}
			
			super.addChild(child);
			
			if(child is GameObject)
				_addGameObject(child as GameObject);
			
			return child;
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(child.parent)
			{
				Logger.error("[GameObject.addChild] Object already has parent object.");
				return child;
			}
			
			super.addChildAt(child, index);
			
			if(child is GameObject)
				_addGameObject(child as GameObject);
			
			return child;
		}

		public override function removeChild(child:DisplayObject):DisplayObject
		{
			if(child.parent != this)
			{
				Logger.error("[GameObject.removeChild] Argument is not a child of target object.");
				return child;
			}
			
			if(child is GameObject)
				_removeGameObject(child as GameObject);
			
			super.removeChild(child);
			
			return child;
		}
		
		public override function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = getChildAt(index);
			
			if(child.parent != this)
			{
				Logger.error("[GameObject.removeChild] Argument is not a child of target object.");
				return child;
			}
			
			if(child is GameObject)
				_removeGameObject(child as GameObject);
			
			super.removeChildAt(index);
			
			return child;
		}

		public function clearGameObjects():void
		{
			for(var child:GameObject = _children; child; child = _iter)
			{
				_iter = child._next;
				removeChild(child);
			}
		}

		public function getGameObject(name:String):GameObject
		{
			if(!name) return null;
			
			var object:GameObject = _children;
			var found:GameObject;
			
			while(object && !found)
			{
				found = object.findGameObject(name);
				object = object._next;
			}
			
			return found;
		}

		public function findGameObject(name:String):GameObject
		{
			if(!name) return null;
			
			var child:GameObject = _children;
			var found:GameObject = getGameObject(name);
			
			while(child && !found)
			{
				found = child.findGameObject(name);
				child = child._next;
			}
			
			return found;
		}

		public function addComponent(component:Component):void
		{
			Logger.assert(component.owner == null, "GameObject.addComponent assert");
			
			_components.push(component);
			component.owner = this;
		}

		public function removeComponent(component:Component):void
		{
			var i:int = _components.indexOf(component);
			
			Logger.assert(i >= 0 && component.owner == this, "GameObject.removeComponent assert");
			
			if(i >= 0)
				_components.splice(i, 1);
				
			component.owner = null;
		}

		public function clearComponents():void
		{
			var goc:Component;
			
			for each (goc in _components)
				goc.owner = null;
			
			_components.length = 0;
		}
		
		public function clear():void
		{
			clearComponents();
			clearGameObjects();
		}
		
		public function eachGameObject(callback:Function):void 
		{
			if(callback==null) return;
			
			for(var go:GameObject = _children; go; go = _iter)
			{
				_iter = go._next;
				callback(go);
			}
		}
		
		public function get isJoined():Boolean
		{
			return _joined;
		}

		private var _children:GameObject;
		private var _next:GameObject;
		private var _prev:GameObject;
		private var _iter:GameObject;
		private var _components:Vector.<Component> = new Vector.<Component>();
		private var _joined:Boolean;
	}
}
