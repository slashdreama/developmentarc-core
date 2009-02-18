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
package com.developmentarc.core.services.dispatchers
{
	import com.developmentarc.core.services.parsers.IParser;
	import com.developmentarc.core.services.requests.IRequest;
	
	import flash.events.EventDispatcher;
	
	
	[Event(name="dispatcherResult",type="com.developmentarc.core.services.events.DispatcherEvent")]
	[Event(name="dispatcherFault",type="com.developmentarc.core.services.events.DispatcherEvent")]
	/**
	 * <p>Class is the base for all dispatcher classes in the service layer.
	 * The responsibility of the dispatcher is to take a given request and build a service request and execute a call
	 * to a paticular data store. That data store is defined by the custom dispatcher class as is up to the developer to describe
	 * inside of the class. </p>
	 * 
	 * <p>A child class must define the dispatch and cancel methods.  The dispatch method is the gateway to executing a paticular request. 
	 * The RequestDelegate will call this method passing in both the request and parser.  The child class will take the neccessary information out of both
	 * the request and the parser and construct and execute the appropriate data store call.  Cancel must be defined to halt an already executed request.</p>
	 * 
	 * <p>
	 * <b>Mock</b>
	 * A dispatcher class can define a IMockDispatcher via  class refernce which when the dispatcher and the RequestDelegate are in "mock" mode, will be used
	 * to fake, the service request and simple return data in the format expected.  This is useful when developing a system that does not yet have a complete service api
	 * or database constructed.
 	 * </p>
	 * 
	 * @see com.developmentarc.core.services.parsers.AbstractParser AbstractParser
	 * @see com.developmentarc.core.services.requests.AbstractRequest AbstractRequest
	 * @see com.developmentarc.core.services.requests.RequestDelegate
	 * 
	 * @author Aaron Pedersen
	 */
	public class AbstractDispatcher extends EventDispatcher implements IDispatcher
	{
		/* STATIC PROPERTIES */
		public static const MODE_MOCK:String = "MODE_MOCK";
		public static const MODE_LIVE:String = "MODE_LIVE";
		
		/* PRIVATE PROPERTIES */
		/**
		 * @private
		 * Marks the current mode of the dispatcher
		 */
		private var __mode:String;
		
		/**
		 * @private
		 * Class reference to the IMockDispatcher class
		 */
		private var __mockClass:Class
		
		/**
		 * Constuctor
		 * 
		 * @param mockClass - Class reference to IMockClass
		 * @param mode - String defining the mode of the dispathcer class. Default is MODE_LIVE
		 */
		public function AbstractDispatcher(mockClass:Class=null,mode:String=MODE_LIVE) {
			__mockClass = mockClass;
			__mode = mode;
		}
		
		/**
		 * Method takes the given request and parser and constucts the appropriate connection to a data store and executes that connection.
		 * 
		 * @param request IRequest containing detailed information used to construct connection.
		 * @param parser IParser containing information needed to cosntruct the connection.
		 * 
		 * @return * Unique identifier.
		 */
		public function dispatch(request:IRequest, parser:IParser):* {
			throw new Error("Child must implement");
		}
		
		/**
		 * Method used to cancel the connect of the given request.  The class takes 
		 * the provided request and unique key and attempts to cancel the request.
		 * 
		 * @param request IRequest Request data object containg detailed information used to determin connection.
		 * @param * Unique identifier used to help locate the request (connection) to cancel.
		 */
		public function cancel(request:IRequest, key:*):void {
			throw new Error("Child must implement");
		}
		
		/**
		 * The current mode of the application. Default is MOCK_LIVE
		 * 
		 * @return String Mock mode.
		 */
		public function get mode():String {
			return __mode;
		}
		
		/**
		 * Reference to the IMockDispatcher used to mock this disptacher.
		 * 
		 * @return Class Class reference to IMockDispatcher.
		 */
		public function get mockClass():Class {
			return __mockClass;
		}
	}
}