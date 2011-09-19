package com.ek.ui 
{
	import com.ek.gocs.Component;
	import com.ek.gocs.IComponentContainer;

	import flash.display.Sprite;

	/**
	 * @author eliasku
	 */
	public class UIWrapper extends Component 
	{
		public function UIWrapper(owner:IComponentContainer, content:Sprite)
		{
			super(owner);
			
			_content = content;
		}
		
		public function get content():Sprite
		{
			return _content;
		}
		
		public function set visible(value:Boolean):void
		{
			if(_content)
				_content.visible = value;
		}
		
		public function get visible():Boolean
		{
			if(_content) 
				return _content.visible;
				
			return false;
		}
		
		private var _content:Sprite;
	}
}
