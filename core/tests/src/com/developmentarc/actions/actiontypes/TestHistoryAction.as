package com.developmentarc.actions.actiontypes
{
	import com.developmentarc.core.actions.actions.AbstractHistoryAction;
	import com.developmentarc.core.actions.commands.AbstractHistoryCommand;
	
	import flash.events.Event;

	public class TestHistoryAction extends AbstractHistoryAction
	{
		public static const DEFAULT_AGE:int = 16;
		public static const DEFAULT_NAME:String = "DevArc";
		
		public static const APPLIED_AGE:int = 21;
		public static const APPLIED_NAME:String = "DevelopmentArc";
		
		public function TestHistoryAction()
		{
			super();
			
			__name = DEFAULT_NAME;
			__age = DEFAULT_AGE;
		}
		
		private var __name:String;
		public function get name():String {
			return __name;
		}
		
		private var __age:int;
		public function get age():int {
			return __age;
		}
		
		override public function applyAction(command:Event):void {
			var historyCommand:AbstractHistoryCommand = AbstractHistoryCommand(command);
			
			// set current state
			historyCommand.setPropertyState(this,"name", __name);
			historyCommand.setPropertyState(this,"age", __age);
			
			// set values
			__name = APPLIED_NAME;
			__age = APPLIED_AGE;
		}
		
		override public function undo(command:Event):void {
			var historyCommand:AbstractHistoryCommand = AbstractHistoryCommand(command);
			
			// hold values
			var oldName:String = historyCommand.getPropertyState(this, "name");
			var oldAge:int = historyCommand.getPropertyState(this, "age");
			
			// set current state
			historyCommand.setPropertyState(this,"name", __name);
			historyCommand.setPropertyState(this,"age", __age);
			
			// set values
			__name = oldName;
			__age = oldAge;
		}
		
		override public function redo(command:Event):void {
			var historyCommand:AbstractHistoryCommand = AbstractHistoryCommand(command);
			
			// hold values
			var oldName:String = historyCommand.getPropertyState(this, "name");
			var oldAge:int = historyCommand.getPropertyState(this, "age");
			
			// set current state
			historyCommand.setPropertyState(this,"name", __name);
			historyCommand.setPropertyState(this,"age", __age);
			
			// set values
			__name = oldName;
			__age = oldAge;
		}
		
		
	}
}