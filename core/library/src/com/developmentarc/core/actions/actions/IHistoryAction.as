package com.developmentarc.core.actions.actions
{
	import flash.events.Event;
	
	public interface IHistoryAction extends IAction
	{
		/**
		 * Method invokes logic to undo this paticular action. 
		 * 
		 * @param command Dispatched command that triggered call to action.
		 */
		function undo(command:Event):void;
		
		/**
		 * Method invokes logic to redo this paticular action
		 * @param command Dispatched command that triggered call to action.
 		 */
		function redo(command:Event):void;
	}
}