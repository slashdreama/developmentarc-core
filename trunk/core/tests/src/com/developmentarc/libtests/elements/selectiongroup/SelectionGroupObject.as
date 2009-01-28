package com.developmentarc.libtests.elements.selectiongroup
{
	import com.developmentarc.framework.controllers.interfaces.ISelectable;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.Container;

	public class SelectionGroupObject extends Container implements ISelectable
	{
		
		public static var CUSTOM_EVENT:String = "CUSTOM_EVENT";
		// PRIVATE GET/SET PROPERTIES
		private var __selected:Boolean;
		
		public function SelectionGroupObject()
		{
			//TODO: implement function
			super();
		}
		/**
		 * The selected value is true for selected and false for deselected.
		 *  
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void
		{
			__selected = value;
		}
		
		public function get selected():Boolean
		{
			return __selected;
		}
		
		public function fireClickEvent():void {
			dispatchEvent(new Event(MouseEvent.CLICK));
		}
		public function fireCustomEvent():void {
			dispatchEvent(new Event(CUSTOM_EVENT));
		}
	}
}