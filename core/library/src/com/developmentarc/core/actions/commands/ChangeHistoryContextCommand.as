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
	 * The ChangeContextCommand allows for the system to change the current
	 * history stack context allowing for specificing what actions are being applied
	 * to which stack.  This is useful for wizards, modality, multi-view/document
	 * applications, etc.
	 * 
	 * @author "James Polanco"
	 * 
	 */
	public class ChangeHistoryContextCommand extends AbstractCommand
	{
		/**
		 * Dispatched when the history context should be changed. 
		 */
		static public const CHANGE_CONTEXT:String = "changeContext";
		
		/**
		 * Defines the default context used by the history stack. Context is an
		 * optional system and by default the system uses the default value.
		 */
		static public const DEFAULT_CONTEXT:String = "defaultContext";
		
		/**
		 * The history context to set the application to. 
		 */		
		public var context:String;
		
		/**
		 * When switching to a non-default stack, this flag is used
		 * to determine if the stack should be saved or destroyed upon
		 * changing to a different context. 
		 */		
		public var saveStack:Boolean = false;
		
		/**
		 * Used to clear the target stack if any existing content exists
		 * in the target context. 
		 */		
		public var clearStack:Boolean = false;
		
		/**
		 * Constructor.
		 *  
		 * @param type  The type of command, default is change context.
		 * @param context The context to change to, the default is predefined.
		 * 
		 */		
		public function ChangeHistoryContextCommand(type:String = CHANGE_CONTEXT, context:String = DEFAULT_CONTEXT)
		{
			super(type);
			this.context = context;
		}
	}
}