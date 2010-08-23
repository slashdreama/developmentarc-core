package com.developmentarc.actions.actiontypes
{
	import com.developmentarc.actions.commands.ContextCommand;
	import com.developmentarc.core.actions.actions.AbstractHistoryAction;
	import com.developmentarc.core.actions.commands.HistoryCommand;
	
	import flash.events.Event;
	
	public class ContextAction extends AbstractHistoryAction
	{
		public function ContextAction()
		{
			super();
		}
		
		private var _lastValue:String;
		
		public function get lastValue():String {
			return _lastValue;
		}
		
		public override function applyAction(command:Event):void
		{
			// set the properties based on the command
			var context:ContextCommand = ContextCommand(command);
			_lastValue = context.value;
		}
		
		public override function redo(command:Event):void
		{
			var context:ContextCommand = ContextCommand(command);
			_lastValue = context.value;
		}

		public override function undo(command:Event):void
		{
			var context:ContextCommand = ContextCommand(command);
			_lastValue = context.value;
		}
	}
}