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
package com.developmentarc.core.actions.commands
{
	/**
	 * The RemoveHistoryContentCommand allows for specific commands to be removed
	 * from the current undo and redo stack. The HistoryActionDelegate automatically
	 * registers for this command type and when dispatched, the delegate processes the
	 * contentList to determine which commands should be removed from both the undo
	 * and redo stack.
	 * 
	 * @author "James Polanco"
	 * 
	 */	
	public class RemoveHistoryContentCommand extends AbstractCommand
	{
		/**
		 * Dispatched when items from the history content need to be removed. 
		 */		
		static public const REMOVE_HISTORY_CONTENT:String = "removeHistoryContent";
		
		/**
		 * The list of commands to remvoe from the history stack. 
		 */		
		public var contentList:Array;
		
		/**
		 * Constructor.
		 *  
		 * @param type The type of command.
		 * @param list The list of items that should be removed.
		 * 
		 */		
		public function RemoveHistoryContentCommand(type:String, list:Array)
		{
			super(type);
			contentList = list;
		}
	}
}