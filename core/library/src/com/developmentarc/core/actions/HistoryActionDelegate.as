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
	import com.developmentarc.core.actions.commands.ChangeHistoryContextCommand;
	import com.developmentarc.core.actions.commands.HistoryCommand;
	import com.developmentarc.core.actions.commands.RemoveHistoryContentCommand;
	import com.developmentarc.core.actions.data.HistoryContext;
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
		 * PROTECTED VARIABLES
		 */ 
		protected var commandToActionMap:HashTable;
		
		/**
		 * Contains the all contexts within the application.
		 */		
		protected var contextList:HashTable;
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function HistoryActionDelegate()
		{
			super();
			construct();	
		}
		
		private var _currentContext:HistoryContext;
		
		/**
		 * Contains the current history context being used by the
		 * application.
		 */	
		protected function get currentContext():HistoryContext
		{
			return _currentContext;
		}

		protected function set currentContext(value:HistoryContext):void
		{
			_currentContext = value;
		}

		/**
		 * Helper method that is called during construction.  This configures
		 * the class and allows for Flash Player to JIT the method. 
		 * 
		 */		
		protected function construct():void {
			commandToActionMap = new HashTable();
			// set default undo event
			undoCommands = [HistoryCommand.UNDO];
			// set default redo event
			redoCommands = [HistoryCommand.REDO];	
			// set default remove commands
			removeHistoryCommands = [RemoveHistoryContentCommand.REMOVE_HISTORY_CONTENT];
			// set default conect command
			contextCommands = [ChangeHistoryContextCommand.CHANGE_CONTEXT];
			
			// create default context
			currentContext = new HistoryContext(ChangeHistoryContextCommand.DEFAULT_CONTEXT, true);
			contextList = new HashTable();
			contextList.addItem(currentContext.id, currentContext);
			
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
				currentContext.undoStack.push(command);
				
				// clear redo stack - its no longer relevent
				currentContext.redoStack = new Array();
			}
		}
		
		/**
		 * Method clears current context history inside of delegate.
		 */
		public function clearHistory():void {
			currentContext.undoStack = [];
			currentContext.redoStack = [];
		}
		
		/**
		 * Clears all of the history stacks from the contexts. 
		 * 
		 */		
		public function clearAllHistory():void {
			var contexts:Array = contextList.getAllItems();
			for each(var item:HistoryContext in contexts) {
				item.undoStack = [];
				item.redoStack = [];
			}
		}
		
		/**
		 * The number of commands currently in undo stack.
		 *
		 */
		public function get undoStackLength():int {
			return currentContext.undoStack.length;
		}
		
		/**
		 * The number of commands currently in redo stack.
		 *
		 */
		public function get redoStackLength():int {
			return currentContext.redoStack.length;
		}
		
		/**
		 * Provides a clone of the current Undo stack.
		 *  
		 * @return A clone Array of the undo stack.
		 * 
		 */
		public function getUndoStackClone():Array {
			return currentContext.undoStack.slice();
		}
		
		/**
		 * Provides a clone of the current Redo stack.
		 *  
		 * @return A clone Array of the undo stack.
		 * 
		 */
		public function getRedoStackClone():Array {
			return currentContext.redoStack.concat([]);
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
			if(currentContext.undoStack.length == 0) return;
			
			// remove command from undo stack
			var command:Event = currentContext.undoStack.pop() as Event;
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
				currentContext.redoStack.push(command);
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
			if(currentContext.redoStack.length == 0) return;
			
			// remove command from redo stack
			var command:Event = currentContext.redoStack.pop() as Event;
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
				currentContext.undoStack.push(command);
			}
		}

// --------------
// REMOVE HISTORY
// -------------- 
		
		private var __removeHistoryCommands:Array;
		
		/**
		 * A set of commands that are used to clear elements from
		 * the history stack.
		 */
		public function get removeHistoryCommands():Array {
			return __removeHistoryCommands;
		}
		
		public function set removeHistoryCommands(commands:Array):void {
			if(__removeHistoryCommands) {
				// unregister undo commands
				unregisterRemoveHistoryCommands();
			}
			__removeHistoryCommands = commands;
			
			registerRemoveHistoryCommands();
		}
		
		/**
		 * Method unsubscribes from all commands currently subscribed to.
		 */
		private function unregisterRemoveHistoryCommands():void {
			for each(var commandType:String in removeHistoryCommands) {
				EventBroker.unsubscribe(commandType, handleRemoveHistoryCommand);
			}
		}
		/**
		 * Methdod subscribes to all commands currently held in history list.
		 */
		private function registerRemoveHistoryCommands():void {
			for each(var commandType:String in removeHistoryCommands) {
				EventBroker.subscribe(commandType, handleRemoveHistoryCommand);
			}
		}
		
		/**
		 * Used to process the undo and redo stack for the current context and removes
		 * the items provided in the command.
		 *  
		 * @param command
		 * 
		 */		
		protected function handleRemoveHistoryCommand(command:RemoveHistoryContentCommand):void {

			// remove from the undo stack
			removeItems(currentContext.undoStack, command.contentList);

			// remove from the redo stack
			removeItems(currentContext.redoStack, command.contentList);
		}
		
		/**
		 * Used to remove items from the target list.
		 * 
		 * @param target The array to remove items from.
		 * @param list The list of items that should be removed from the target.
		 * 
		 */		
		protected function removeItems(target:Array, list:Array):void {
			var targetLength:int = target.length - 1;
			var removeLength:int = list.length;
			
			for(var i:int = targetLength; i > -1; i--) {
				var item:Object = target[i];
				
				// loop through our remove list
				for(var ii:uint = 0; ii < removeLength; ii++) {
					if(item == list[ii]) {
						// remove the item from the undo stack
						target.splice(i, 1);
						break;
					}
				}
			}
		}
		
// --------------
// CONTEXT
// --------------	
		
		private var _contextCommands:Array;
		
		/**
		 * Defines the list of context commands types that are used to
		 * change the current history stack context.  By default the
		 * list contains the ChangeHistoryContextCommand.CHANGE_CONTEXT
		 * is dispatched through the EventBroker.
		 * 
		 */		
		public function get contextCommands():Array {
			return _contextCommands;
		}
		
		public function set contextCommands(value:Array):void {
			if(_contextCommands) {
				unregisterContextCommands();
			}
			
			_contextCommands = value;
			if(_contextCommands && _contextCommands.length > 0) registerContextCommands();
		}
		
		/* 
		 * Called to register all the command types defined for the history context
		 * changes.
		 */
		private function registerContextCommands():void {
			for each(var commandType:String in _contextCommands) {
				EventBroker.subscribe(commandType, handleChangeContextCommand);
			}
		}
		
		/* 
		* Called to unregister all the command types defined for the history context
		* changes.
		*/
		private function unregisterContextCommands():void {
			for each(var commandType:String in _contextCommands) {
				EventBroker.unsubscribe(commandType, handleChangeContextCommand);
			}
		}
		
		/**
		 * When a registered changed history command is dispatched, this method
		 * processes the command and switches the current context to the request
		 * context.
		 *  
		 * @param command
		 * 
		 */		
		protected function handleChangeContextCommand(command:ChangeHistoryContextCommand):void {
			// make sure we aren't already in the context
			if(currentContext.id == command.context) return;
			
			// look at the current context, clear if required (default is always kept)
			if(currentContext.id != ChangeHistoryContextCommand.DEFAULT_CONTEXT && !currentContext.saveStack) {
				currentContext.redoStack = [];
				currentContext.undoStack = [];
			}
			
			// get the new context
			var newContext:HistoryContext;
			if(contextList.containsKey(command.context)) {
				// get the conext from the stack
				newContext = contextList.getItem(command.context);
				if(newContext.id != ChangeHistoryContextCommand.DEFAULT_CONTEXT && command.clearStack) {
					// reset the stack
					newContext.redoStack = [];
					newContext.undoStack = [];
				}
			} else {
				// create a new conext from this
				newContext = new HistoryContext(command.context, command.saveStack);
				contextList.addItem(newContext.id, newContext);
			}
			
			currentContext = newContext;
		}
	}	
}