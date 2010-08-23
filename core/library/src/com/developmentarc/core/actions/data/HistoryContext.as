/* ***** BEGIN MIT LICENSE BLOCK *****
* 
* Copyright (c) 2010 DevelopmentArc LLC
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
package com.developmentarc.core.actions.data
{
	/**
	 * The history context is used by the HistoryActionDelegate to compartmentalize
	 * undo and redo actions within a specified context.  By default, the system uses
	 * a default context.  If the user/developer wishes to chanage context, a 
	 * ChangeHistoryContextCommand is dispatched and the HistoryActionDelegate's HistoryContext
	 * instance is changed.  This allows for parrelel history stacks.
	 *  
	 * @author "James Polanco"
	 * 
	 */
	public class HistoryContext
	{
		/**
		 * The id name of the stack. 
		 */		
		public var id:String;
		/**
		 * The undo stack instance, contains all the commands for the specific
		 * context.
		 */		
		public var undoStack:Array;
		/**
		 * The redo stack instance, contains all the commands for the specific
		 * context.
		 */	
		public var redoStack:Array;
		/**
		 * Defines if the stack should be saved when the context changes. 
		 */				
		public var saveStack:Boolean;
		
		/**
		 * constructor. 
		 * @param id The ID of the context.
		 * @param saveStack Defines if the context should save or clear the stack on change.
		 * 
		 */		
		public function HistoryContext(id:String, saveStack:Boolean) {
			undoStack = [];
			redoStack = [];
			this.id = id;
			this.saveStack = saveStack;
		}
	}
}