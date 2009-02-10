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
package com.developmentarc.libtests.elements.selectiongroup
{
	import com.developmentarc.framework.controllers.interfaces.ISelectable;
	
	import mx.core.Container;

	/**
	 * This is a test element that is used to verify selection functionality.  The SelectionOjbect implements
	 * the ISelectableObject interface allowing it to be used in the SelectionController.
	 * 
	 * @author James Polanco
	 * 
	 */
	public class SelectionObject extends Container implements ISelectable
	{
		private var __selected:Boolean = false;
		
		/**
		 * Constructor 
		 * 
		 */
		public function SelectionObject()
		{
		}

		/**
		 * The selected value is true for selected and false for deselected.
		 *  
		 * @param value
		 * 
		 */
		public function set selected(value:Boolean):void
		{
			__selected = value;
		}
		
		public function get selected():Boolean
		{
			return __selected;
		}
		
	}
}