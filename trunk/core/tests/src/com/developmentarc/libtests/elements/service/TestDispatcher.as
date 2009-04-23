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
	import com.developmentarc.core.datastructures.utils.HashTable;
	import com.developmentarc.core.services.dispatchers.AbstractDispatcher;
	import com.developmentarc.core.services.parsers.IParser;
	import com.developmentarc.core.services.requests.IRequest;
	
	import flash.utils.setTimeout;
	
	/**
	 * <p>Base class for all test dispatchers in the server layer test suite.
	 * Class saves a reference to each request in the system to provide an 
	 * easy way to reference the request and its unique id.</p>
	 * 
	 * <p>This class is does not use a real server but rather fakes it. Its not a 
	 * Mock dispatcher and does take a IMockClass reference when in mock mode.</p>
	 */
	public class TestDispatcher extends AbstractDispatcher
	{
		/**
		 * Stores all requests that are currently dispatched.
		 */
		public var map:HashTable
		
		/**
		 * Delay of the dispatching of the DispatcherEvent.RESULT
		 */ 
		public var delay:uint = 500;
		
		/**
		 * Constructor
		 * 
		 * @param mockClass Class reference to IMockDispatcher. Default is null
		 * @param mode Strig defining the current mode of the dispatcher. Default is MODE_LIVE
		 */
		public function TestDispatcher() {
			super();
			map = new HashTable();
		}
		
		/**
		 * Method creates unique id for request, stores the id in the map based on teh request
		 * and executes a setTimeout to dispatch the DispatcherEvent based on the delay.
		 * 
		 * @param request IRequest
		 * @param parser IParser
		 * 
		 * @return Number Unique Id.
		 */
		override public function dispatch(request:IRequest, parser:IParser):* {
			TestRequest(request).dispatcher = this;
			
			var uid:Number = Math.random();
			
			map.addItem(request, uid);
			
			setTimeout(function():void{fireEvent(request)}, delay);	
			
			return uid;
		}
		protected function fireEvent(request:IRequest):void {
			
		}	
		
		/**
		 * Returns the unique id based on the passed in request.
		 * 
		 * @param request IRequest
		 * 
		 * @return Number Unique id.
		 */
		protected function getUID(request:IRequest):Number {
			return map.getItem(request);
		}
	}
}