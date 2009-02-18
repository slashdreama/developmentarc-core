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
package com.developmentarc.libtests.elements.service
{
	import com.developmentarc.core.services.mocks.AbstractMockDispatcher;
	import com.developmentarc.core.services.parsers.IParser;
	import com.developmentarc.core.services.requests.IRequest;
	
	/**
	 * Class provides a mock dispatcher for a request providing a generic
	 * object which is duck typed to a TaskDO (name, description, completed.
	 */
	public class MockDispatcher extends AbstractMockDispatcher
	{

		public static const NAME:String = "MockTask";
		public static const DESCRIPTION:String = "This is a mock task";
		public static const COMPLETED:Boolean = false;

		public function MockDispatcher()
		{
		}
		
		/**
		 * Method mocks a generic object with three properties; name, description, completed
		 */
		override public function dispatch(request:IRequest, parser:IParser):* {
			
			
			var data:Object = {};
			data.name = NAME;
			data.description = DESCRIPTION;
			data.completed = COMPLETED;
			
			this.result = data;
			
			return super.dispatch(request, parser);
		}
	}
}