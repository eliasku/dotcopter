package com.ek.utils 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author eliasku
	 */
	public class DepthSprite extends Sprite 
	{
		public function DepthSprite()
		{
			super();
		}
		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			if(child is DepthSprite && _depthChildren)
			{
				var sprite:DepthSprite = child as DepthSprite;
				var displayObject:DisplayObject;
				var nodeSprite:DepthSprite;
				var i:int;
				
				for ( i = 0; i < numChildren; ++i )
				{
					displayObject = getChildAt(i);
					if(displayObject is DepthSprite)
					{
						nodeSprite = displayObject as DepthSprite;
						if(nodeSprite.depth > sprite.depth)
						{
							break;
						}
					}
				}
			
				addChildAt(child, i);
			}
			else
			{
				super.addChild(child);
			}
			
			return child;
		}
			
		public function get depth():Number
		{
			return _depth;
		}
		
		public function set depth(value:Number):void
		{
			_depth = value;
			
			if(parent && parent is DepthSprite && (parent as DepthSprite).depthChildren)
			{
				var index:int = parent.getChildIndex(this);
				var displayObject:DisplayObject;
				var depthSprite:DepthSprite;
				var i:int;
				var numChildren:int = parent.numChildren;
				
				for ( i = 0; i < numChildren; ++i)
				{
					displayObject = parent.getChildAt(i);
					if(displayObject!=this)
					{
						if(displayObject is DepthSprite)
						{
							depthSprite = displayObject as DepthSprite;
							if(depthSprite.depth > _depth)
							{
								break;
							}
						}
					}
				}
				
				if(i > index) --i;
				
				parent.setChildIndex(this, i);
			}
		}
		
		public function get depthChildren():Boolean
		{
			return _depthChildren;
		}
		
		public function set depthChildren(value:Boolean):void
		{
			_depthChildren = value;
		}
		
		private var _depth:Number = 0.0;
		private var _depthChildren:Boolean;
	}
}
