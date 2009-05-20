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
package com.developmentarc.core.actions.commands
{
	import com.developmentarc.core.actions.actions.IHistoryAction;
	import com.developmentarc.core.datastructures.utils.HashTable;
	
	/**
	 * <p>Abstact Command class to base all History enabled commands from. This class is to be used in
	 * conjunction with the HistoryActionDelegate class.</p>
	 * 
	 * <p>Class provides functionality to allow for actions to save their old states inside of the command. This 
	 * ability gives commands the knowledge to assist actions in undoing the action originally taken.  This class 
	 * is only provides a data store for values, no logic is provided by default. Add all logic for applying, undo, redo inside
	 * of your action classes.</p>
	 * 
	 * 
	 * @see com.developmentarc.core.actions.actions.IHistoryAction
	 * @see com.developmentarc.core.actions.HistoryActionDelegate
	 * 
	 * @author Aaron Pedersen
	 */
	public class AbstractHistoryCommand extends AbstractCommand
	{
		/*
		 * PRIVATE VARIABLES
		 */
		private var _actionPropertiesState:HashTable;
		
		/**
		 * Constructor.
		 *  
		 * @param type The type of command.
		 * 
		 */
		public function AbstractHistoryCommand(type:String)
		{
			super(type);
			
			_actionPropertiesState = new HashTable();
		}
		
		/**
		 * Stores state of the provided action's property inside of command instance.
		 * 
		 * @param action IHistoryAction reference to the invoked Action relevant to this command.
		 * @param property Unique property name to store state of property.
		 * @param value Value of the property to be stored.
		 */	
		public function setPropertyState(action:IHistoryAction, property:String, value:*):void {
			if(!_actionPropertiesState.containsKey(action)) {
				_actionPropertiesState.addItem(action, new Array());
			}
			
			var properties:Array = _actionPropertiesState.getItem(action) as Array;
			properties[property] = value;
		}
		
		/**
		 * Method returns the value of the provided action's property. If no action exists, null will be returns. 
		 * If an action exists but the supplied property has not been set, null will also be returned.
		 * 
		 * @param action IHistoryAction reference to the invoked Action relavant to this command.
		 * @param property String of the property name.
		 */
		public function getPropertyState(action:IHistoryAction, property:String):* {
			
			if(_actionPropertiesState.containsKey(action)) {
				return _actionPropertiesState.getItem(action)[property];
			}
			else {
				return null;
			}
		}

	}
}