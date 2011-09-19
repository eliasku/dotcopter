package com.ek.gocs 
{

	/**
	 * @author eliasku
	 */
	public interface IComponentContainer 
	{
		function addComponent(component:Component):void;
		
		function removeComponent(component:Component):void;
		
		function clearComponents():void;
	}
}
