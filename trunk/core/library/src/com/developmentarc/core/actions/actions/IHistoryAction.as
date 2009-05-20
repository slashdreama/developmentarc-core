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
 package com.developmentarc.core.actions.actions
{
	import flash.events.Event;
	/**
	 * Interface represents the basics of a simple Action with history capabilities that is
	 * used by the HistoryActionDelegate and Command structure.
	 * 
	 * @author Aaron Pedersen
	 * 
	 */
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
		 * 
		 * @param command Dispatched command that triggered call to action.
 		 */
		function redo(command:Event):void;
	}
}