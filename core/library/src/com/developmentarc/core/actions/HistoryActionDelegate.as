/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2009 DevelopmentArc LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * ***** END MIT LICENSE BLOCK ***** */
package com.developmentarc.core.actions
{
	import com.developmentarc.core.actions.actions.IAction;
	import com.developmentarc.core.actions.actions.IHistoryAction;
	import com.developmentarc.core.actions.commands.AbstractHistoryCommand;
	import com.developmentarc.core.actions.commands.HistoryCommand;
	import com.developmentarc.core.datastructures.utils.HashTable;
	import com.developmentarc.core.utils.EventBroker;
	
	import flash.events.Event;
	
	/**
	 * <p>Class is used as the action delegate when history management is neccessary. 
	 * This delegation system supports undo and redo. When a command is executed
	 * the command will be stored inside of a undo stack to allow for the command and it's associated
	 * actions to be reversed. When a command is 'undone' the command will be popped from
	 * the stack and all actions associated with the command will have it's undo() method invoked.
	 * </p>
	 * <p>It is the responsibility of the Action to define the operation to undo it's actions when applyAction() was
	 * originally called.</p>
	 * 
	 * <p>When a command is 'undone' it will be added to the redo stack allow for it's original operation to be reapplied. Similar to
	 * the undo operation, it is up to the Action to define it's redo() method.</p>
	 * 
	 * <p>To use this sytem, all actions must implement IHistoryAction or extend from AbstractHistoryAction (recommended) and commands must
	 * extend AbstractHistoryCommand</p>
	 * 
	 * By default the delegate system will listen to HistoryCommand.UNDO and 
	 * HistoryCommand.REDO events to trigger the undo and redo operations. Developers can override any anypoint via the undoCommands and redoCommands properties on this class.
	 * 
	 * 
	 * @see com.developmentarc.core.actions.actions.IHistoryAction
	 * @see com.developmentarc.core.actions.commands
	 * 
	 * 
	 * @author Aaron Pedersen
	 */ 
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
		
		/**
		 * Method handles events that trigger a command to be executed. This method w
		 * will determine all associated actions and invoke each's applyAction method.
		 * After all have been executed, the command will be added to the undo stack and
		 * the redo stack will be cleared.
		 * 
		 * @param command Command event that was broadcasted.
		 */
		protected function handleCommand(command:Event):void {
			// get actions
			var actions:HashTable = commandToActionMap.getItem(command.type);
			// loop over all actions relevant to the dispatched command
			for each(var action:IAction in actions.getAllKeys()) {
				// apply action
				action.applyAction(command);
			}
			
			// if command has history enabled
			if(command is AbstractHistoryCommand && AbstractHistoryCommand(command).useHistory) {
				// add command to undo stack
				_undoCommandStack.push(command);
				
				// clear redo stack - its no longer relevent
				_redoCommandStack = new Array();
			}
		}
		
		/**
		 * Method clears history inside of delegate.
		 */
		public function clearHistory():void {
			_undoCommandStack = new Array();
			_redoCommandStack = new Array();
		}
		
		/**
		 * The number of commands currently in undo stack.
		 *
		 */
		public function get undoStackLength():int {
			return _undoCommandStack.length;
		}
		
		/**
		 * The number of commands currently in redo stack.
		 *
		 */
		public function get redoStackLength():int {
			return _redoCommandStack.length;
		}
		
		/**
		 * Provides a clone of the current Undo stack.
		 *  
		 * @return A clone Array of the undo stack.
		 * 
		 */
		public function getUndoStackClone():Array {
			return _undoCommandStack.concat([]);
		}
		
		/**
		 * Provides a clone of the current Redo stack.
		 *  
		 * @return A clone Array of the undo stack.
		 * 
		 */
		public function getRedoStackClone():Array {
			return _redoCommandStack.concat([]);
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