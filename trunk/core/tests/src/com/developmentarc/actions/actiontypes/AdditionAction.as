package com.developmentarc.actions.actiontypes
{
	import com.developmentarc.core.actions.actions.AbstractHistoryAction;
	
	import flash.events.Event;

	public class AdditionAction extends AbstractHistoryAction
	{
		private var _value:Number;
		
		public function AdditionAction()
		{
			super();
			_value = 0;
		}
		
		public function get value():Number {
			return _value;
		}
		
		override public function applyAction(command:Event):void {
			_value++;
		}
		
		override public function undo(command:Event):void {
			_value--;
		}
		override public function redo(command:Event):void {
			this.applyAction(command);
		}
		
		
		
	}
}