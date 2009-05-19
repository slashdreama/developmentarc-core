package com.developmentarc.core.actions.commands
{
	import com.developmentarc.core.actions.actions.IHistoryAction;
	import com.developmentarc.core.datastructures.utils.HashTable;
	
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