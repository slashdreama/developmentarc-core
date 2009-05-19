package com.developmentarc.core.actions.actions
{
	import flash.events.Event;
	
	public class AbstractHistoryAction extends AbstractAction implements IHistoryAction
	{
		public function AbstractHistoryAction()
		{
			super();
		}
		
		public function undo(command:Event):void
		{
			throw new Error("The AbstractAction.undo() method was not overriden by the implementing class.");
		}
		public function redo(command:Event):void
		{
			throw new Error("The AbstractAction.redo() method was not overriden by the implementing class.");
		
		}
	}
}