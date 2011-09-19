package com.ek.gocs 
{
	import com.ek.debug.Logger;

	import flash.events.EventDispatcher;

	/**
	 * @author eliasku
	 */
	public class Component extends EventDispatcher implements IComponentContainer
	{
		public function Component(owner:IComponentContainer) 
		{
			if(owner)
				owner.addComponent(this);
		}

		public function tick(dt:Number):void
		{
			for each (var goc:Component in _children)
				goc.tick(dt);
		}
		
		public function slowTick():void
		{
			for each (var goc:Component in _children)
				goc.slowTick();
		}
		
		public function get owner():GameObject
		{
			return _owner;
		}
		
		public function set owner(value:GameObject):void
		{
			_owner = value;
			
			for each (var goc:Component in _children)
				goc.owner = value;
		}
		
		public function get parent():Component
		{
			return _parent;
		}
		
		public function set parent(value:Component):void
		{
			_parent = value;
		}
		
		public function addComponent(component:Component):void
		{
			if(!component._parent)
			{
				component.parent = this;
				component.owner = _owner;
				_children.push(component);
			}
			else
			{
				Logger.error("[Component] addChild");
			}
		}
		
		public function removeComponent(component:Component):void
		{
			var i:int = _children.indexOf(component);
			
			if(i >= 0)
			{
				_children.splice(i, 1);
				
				if(_owner)
					component.owner = null;
					
				component.parent = null;
			}
		}
		
		public function clearComponents():void
		{
			for each (var goc:Component in _children)
			{
				if(_owner)
					goc.owner = null;
					
				goc.parent = null;
			}
			
			_children.length = 0;
		}
		
		private var _owner:GameObject;
		private var _children:Vector.<Component> = new Vector.<Component>();
		private var _parent:Component;		
	}
}
