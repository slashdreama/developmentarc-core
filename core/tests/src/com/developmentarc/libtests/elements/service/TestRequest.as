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
	import com.developmentarc.core.services.dispatchers.IDispatcher;
	import com.developmentarc.core.services.parsers.IParser;
	import com.developmentarc.core.services.requests.AbstractRequest;

	/**
	 * Base class for all Test requests in the test suite.  Provides
	 * a way to save teh other requests in the test and the provided parser and 
	 * dispatcher instances.
	 */
	public class TestRequest extends AbstractRequest
	{
		/**
		 * Stores other requests used in the test. Use
		 * for verifying other states of requets.
		 */
		public var otherRequests:Array;
		
		/**
		 * Stores the parser instance used in this request
		 */
		public var parser:IParser;
		
		/**
		 * Stores the dispatcher instance used in this request
		 */
		public var dispatcher:IDispatcher;
		
		/**
		 * Stores "returned" from this request
		 */
		public var data:Object;
		
		/**
		 * Provides a way to tag a request with a name to verify its 
		 * the request you are looking for.
		 */
		public var name:String;
		
		/**
		 * Constructor
		 * @param dispatcherClass Class reference to the IDispatcher class
		 * @param parserClass Class reference to the IParser class
		 */
		public function TestRequest(dispatcherClass:Class, parserClass:Class)
		{
			super("", "", "", dispatcherClass, parserClass);
			otherRequests = new Array();
		}
		
		/**
		 * Method saves data locally
		 */
		override public function saveData(data:*):void {
			this.data = data;
		}
	}
}