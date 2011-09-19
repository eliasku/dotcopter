package com.ek.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.filters.ColorMatrixFilter;

	/**
	 * @author eliasku
	 */
	public class VisualUtil
	{
		public static function clear(container:DisplayObjectContainer, clearGraphics:Boolean = true, clearFilters:Boolean = false):void
		{
			if(container)
			{
				while(container.numChildren > 0)
					container.removeChildAt(0);

				if(clearGraphics && container.hasOwnProperty("graphics"))
				{
					const g:Graphics = container["graphics"] as Graphics;
					if(g) g.clear();
				}

				if(clearFilters && container.filters.length > 0)
					container.filters.length = 0;
			}
		}

		private static const _bwr:Number = 1 / 3;
		private static const _bwg:Number = 1 / 3;
		private static const _bwb:Number = 1 / 3;
		private static const _bwf:ColorMatrixFilter = new ColorMatrixFilter([_bwr, _bwg, _bwb, 0, 0, _bwr, _bwg, _bwb, 0, 0, _bwr, _bwg, _bwb, 0, 0, 0, 0, 0, 1, 0]);

		public static function bw(target:DisplayObject, enabled:Boolean = true):void
		{
			if(target)
			{
				if(enabled) target.filters = [_bwf];
				else target.filters = [];
			}
		}

		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject
		{
			var targetClass:Class = Object(target).constructor as Class;
			var duplicate:DisplayObject = new targetClass() as DisplayObject;
				
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			duplicate.scale9Grid = target.scale9Grid;

			//duplicate.graphics.copyFrom(target.graphics);

			if(autoAdd && target.parent)
				target.parent.addChild(duplicate);
			
			return duplicate;
		}
	}
}
