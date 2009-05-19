package com.developmentarc.core.actions
{
	import com.developmentarc.core.actions.actions.IAction;
	import com.developmentarc.core.actions.actions.IHistoryAction;
	import com.developmentarc.core.actions.commands.HistoryCommand;
	import com.developmentarc.core.datastructures.utils.HashTable;
	import com.developmentarc.core.utils.EventBroker;
	
	import flash.events.Event;
	
	public class HistoryActionDelegate extends ActionDelegate
	{
		
		/*
		 * PRIVATE VARIABLES 
		 */
		private var _undoCommandStack:Array;
		private var _redoCommandStack:Array;
		/*
		 * PROTECTED VARIABLES
		 */ 
		protected var commandToActionMap:HashTable;
		
		public function HistoryActionDelegate()
		{
			super();
			init();	
		}
		
		private function init():void {
			commandToActionMap = new HashTable();
			// set default undo event
			undoCommands = [HistoryCommand.UNDO];
			// set default redo event
			redoCommands = [HistoryCommand.REDO];	
					
			// create inital stacks
			_undoCommandStack = new Array();
			_redoCommandStack = new Array();
		}
		/**
		 * Registers the Action's commands via the EventBroker.
		 *  
		 * @param action The action to register.
		 * 
		 */
		override protected function registerCommands(action:IAction):void {
			var commands:Array = action.commands;
			activeCommands.addItem(action, commands);
			for each(var commandType:String in commands) {
				if(!commandToActionMap.containsKey(commandType)) {
					commandToActionMap.addItem(commandType, new HashTable());
					// subsribe if this is a new command
					EventBroker.subscribe(commandType, handleCommand);
				}
				
				var actions:HashTable = commandToActionMap.getItem(commandType);
				actions.addItem(action, true);
			}
		}
		/**
		 * Unregisters the Action's commands via the EventBroker.
		 *  
		 * @param action The action to unregister.
		 * 
		 */
		override protected function unregisterCommands(action:IAction, commands:Array):void {
			for each(var commandType:String in commands) {
				var actions:HashTable = commandToActionMap.getItem(commandType);
				// remove action from list			
				actions.remove(action);
				
				// if no more actions exist for command				
				if(actions.getAllKeys().length < 1) {
					// remove command from map
					commandToActionMap.remove(commandType);
					// unsubscribe from command
					EventBroker.unsubscribe(commandType, handleCommand);
				}
			}
		}
		
		protected function handleCommand(command:Event):void {
			// get actions
			var actions:HashTable = commandToActionMap.getItem(command.type);
			// loop over all actions relevant to the dispatched command
			for each(var action:IAction in actions.getAllKeys()) {
				// apply action
				action.applyAction(command);
			}
			// add command to undo stack
			_undoCommandStack.push(command);
			
			// clear redo stack - its no longer relevent
			_redoCommandStack = new Array();
		}
		
// --------------
// UNDO 
// --------------		
		private var __undoCommands:Array;
		
		/**
		 * Set of commands that triggers a command from
		 * the undo stack to be executed.
		 * Upon setting this propery all pervious commands
		 * will be unsubscribed and the new ones subscribed too.
		 */
		public function get undoCommands():Array {
			return __undoCommands;
		}
		
		public function set undoCommands(commands:Array):void {
			if(__undoCommands) {
				// unregister undo commands
				unregisterUndoCommands();
			}
			__undoCommands = commands;
			
			registerUndoCommands();
		}
		
		/**
		 * Method unsubscribes from all commands currently subscribed to.
		 */
		private function unregisterUndoCommands():void {
			for each(var commandType:String in undoCommands) {
				EventBroker.unsubscribe(commandType, handleUndoCommand);
			}
		}
		/**
		 * Methdod subscribes to all commands currently held in the undo command list.
		 */
		private function registerUndoCommands():void {
			for each(var commandType:String in undoCommands) {
				EventBroker.subscribe(commandType, handleUndoCommand);
			}
		}
		
		/**		
		 * Method handles and events that are to trigger the execution of an "undo" for
		 * the last item on the undo command stack.
		 * 
		 * @param command Undo event
		 */
		protected function handleUndoCommand(command:Event):void {
			if(_undoCommandStack.length == 0) return;
			
			// remove command from undo stack
			var command:Event = _undoCommandStack.pop() as Event;
			// get actions
			var actions:HashTable = commandToActionMap.getItem(command.type);
			
			// only if actions exist for command
			if(actions) {
				// loop over all actions relevant to the dispatched command
				for each(var action:IHistoryAction in actions.getAllKeys()) {
					// apply action
					action.undo(command);
				}
				// add to redo stack
				_redoCommandStack.push(command);
			}
		}
// --------------
// REDO
// --------------		
		private var __redoCommands:Array;
		
		/**
		 * Set of commands that triggers a command from
		 * the redo stack to be executed.
		 * Upon setting this propery all pervious commands
		 * will be unsubscribed and the new ones subscribed too.
		 */
		public function get redoCommands():Array {
			return __redoCommands;
		}
		
		public function set redoCommands(commands:Array):void {
			if(__redoCommands) {
				// unregister undo commands
				unregisterRedoCommands();
			}
			__redoCommands = commands;
			
			registerRedoCommands();
		}
		
		/**
		 * Method unsubscribes from all commands currently subscribed to.
		 */
		private function unregisterRedoCommands():void {
			for each(var commandType:String in redoCommands) {
				EventBroker.unsubscribe(commandType, handleRedoCommand);
			}
		}
		/**
		 * Methdod subscribes to all commands currently held in the redo command list.
		 */
		private function registerRedoCommands():void {
			for each(var commandType:String in redoCommands) {
				EventBroker.subscribe(commandType, handleRedoCommand);
			}
		}
		
		/**		
		 * Method handles and events that are to trigger the execution of an "undo" for
		 * the last item on the undo command stack.
		 * 
		 * @param command Undo event
		 */
		protected function handleRedoCommand(command:Event):void {
			if(_redoCommandStack.length == 0) return;
			
			// remove command from redo stack
			var command:Event = _redoCommandStack.pop() as Event;
			// get actions
			var actions:HashTable = commandToActionMap.getItem(command.type);
			
			// only if actions exist for command
			if(actions) {
				// loop over all actions relevant to the dispatched command
				for each(var action:IHistoryAction in actions.getAllKeys()) {
					// apply action
					action.redo(command);
				}
				// add to undo stack
				_undoCommandStack.push(command);
			}
		}
	}	
}