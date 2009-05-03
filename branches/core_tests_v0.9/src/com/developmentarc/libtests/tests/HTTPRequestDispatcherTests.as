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

package com.developmentarc.libtests.tests
{
	import com.developmentarc.core.services.dispatchers.HTTPRequestDispatcher;
	import com.developmentarc.core.services.events.DispatcherEvent;
	import com.developmentarc.core.services.requests.HTTPRequest;
	import com.developmentarc.libtests.elements.service.TestHTTPRequest;
	import com.developmentarc.libtests.elements.service.TestHTTPRequestDispatcher;
	import com.developmentarc.libtests.elements.service.TestTaskParser;
	
	import flexunit.framework.TestCase;
	
	import mx.rpc.http.HTTPService;
	
	/**
	 * Class tests the HTTPRequest and HTTPDispatcher which are both part of
	 * DevelopmentArc's service layer
	 */
	public class HTTPRequestDispatcherTests extends TestCase
	{
		public function HTTPRequestDispatcherTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Method tests that the HTTPService is created correct based on data from both request and parser
		 */
		 public function testServiceCreation():void {
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'.xml');
			
			setNewTaskParams(request);
			
			// create parser (delegate would do this for real)
			var parser:TestTaskParser = new request.parserClass();
			
			// create dispatcher (delegate would do this for real)
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// dispatch request (should create service request with data)
			dispatcher.dispatch(request, parser);
			
			// Test - Method
			assertTrue("Service method should be GET", request.method == dispatcher.httpService.method);
			
			// Test resultFormat
			assertTrue("Service resultFormat should be same as parser", dispatcher.httpService.resultFormat == parser.resultFormat);
		} 
		/**
		 * Test retrieves data from server via GET
		 */
		 public function testGet():void {
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/1.xml');
			
			setNewTaskParams(request);
			
			// create parser (delegate would do this for real)
			var parser:TestTaskParser = new request.parserClass();
			
			// create dispatcher (delegate would do this for real)
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleGetResult, 1000), false, 0, true);
			// dispatch request (should create service request with data)
			dispatcher.dispatch(request, parser);
			
			// Test - Has the url been created?
			assertTrue("Service should have same url defined in request", (request.uri + request.source + HTTPRequestDispatcher.buildQueryString(request.params)) == dispatcher.httpService.url);
		} 
		
		/**
		 * Test Posts new data to server (pretend to create a new record (REST)
		 */
		public function testPost():void {
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_POST,'.xml');
			
			setNewTaskParams(request);
			
			// create parser (delegate would do this for real)
			var parser:TestTaskParser = new request.parserClass();
			
			// create dispatcher (delegate would do this for real)
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// listen to result event
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handlePostResult, 1000), false, 0, true);
			
			// dispatch request (should create service request with data)
			dispatcher.dispatch(request, parser);
			
			// Test - Has the url been created?
			assertTrue("Service should have same url defined in request", (request.uri + request.source) == dispatcher.httpService.url);
		
		}
				
		/**
		 * Method verifies result is dispatched from Dispatcher on good url
		 */
		 public function testDispatchEventResult():void {
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/1.xml');
			
			// create parser (delegate would do this for real)
			var parser:TestTaskParser = new request.parserClass();
			
			// create dispatcher (delegate would do this for real)
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// listen for result (success)
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleResult, 5000), false, 0, true);
			
			// dispatch request (should create service request with data)
			dispatcher.dispatch(request, parser);
			
		} 
		/**
		 * Method verifies fault is dispatched from Dispatcher on bad url
		 */
		 public function testDispatchEventFault():void {
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/bad/url/.xml');
			
			setNewTaskParams(request);
			
			// create parser (delegate would do this for real)
			var parser:TestTaskParser = new request.parserClass();
			
			// create dispatcher (delegate would do this for real)
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// listen for fault
			dispatcher.addEventListener(DispatcherEvent.FAULT, addAsync(handleFault, 1000), false, 0, true);
			
			// dispatch request (should create service request with data)
			dispatcher.dispatch(request, parser);
		} 
		
		/**
		 * Verifies two get requests can be sent using the HTTPRequestDispatcher. 
		 */
		public function testTwoRequestsGetToGet():void {
			var request1:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/1.xml');
			var request2:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/20.xml');	
			
			// create parser 
			var parser:TestTaskParser = new request1.parserClass();
			
			// create dispatcher
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// dispatch request 
			dispatcher.dispatch(request1, parser);
			
			// Hold on to httpService
			var firstHTTPService:HTTPService = dispatcher.httpService;		

			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleTwoRequestsResults, 1000), false, 0, true);
			// set parser 
			parser = new request2.parserClass();

			// dispatch request 
			dispatcher.dispatch(request2, parser);
		
			// Hold on to httpService
			var secondHTTPService:HTTPService = dispatcher.httpService;
			
			assertTrue("Verifies only one http service was created", firstHTTPService == secondHTTPService);
		}
		
		/**
		 * Verify a Get then a Post request both work as expected
		 */
		public function testTwoRequestsGetToPost():void {
			// create requests
			var getRequest:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/1.xml');
			var postRequest:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_POST,'.xml');	
			
			setNewTaskParams(postRequest);
			
			// FIRST REQUEST
			// create parser 
			var parser:TestTaskParser = new getRequest.parserClass();
			
			// create dispatcher
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// dispatch request 
			dispatcher.dispatch(getRequest, parser);		

			// SECOND REQUEST
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleTwoRequestsResults, 5000), false, 0, true);

			// set parser 
			parser = new postRequest.parserClass();

			// dispatch request 
			dispatcher.dispatch(postRequest, parser);
		}
		
		/**
		 * Verify a Post and then a Get request work as expected
		 */
		public function testTwoRequestsPostToGet():void {
			var postRequest:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_POST,'.xml');
			var getRequest:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/1.xml');	
			
			setNewTaskParams(postRequest);
			
			// FIRST REQUEST
			// create parser 
			var parser:TestTaskParser = new postRequest.parserClass();
			
			// create dispatcher
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// dispatch request 
			dispatcher.dispatch(postRequest, parser);		

			// SECOND REQUEST
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleTwoRequestsResults, 1000), false, 0, true);

			// set parser 
			parser = new getRequest.parserClass();

			// dispatch request 
			dispatcher.dispatch(getRequest, parser);
		}
		
		/**
		 * Verify a Post and  Post requeset work as expected
		 */
		public function testTwoRequestsPostToPost():void {
			var request1:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_POST,'.xml');
			var request2:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_POST,'.xml');	
			
			// create params
			setNewTaskParams(request1);
			setNewTaskParams(request2);
			
			// create parser 
			var parser:TestTaskParser = new request1.parserClass();
			
			// create dispatcher
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// dispatch request 
			dispatcher.dispatch(request1, parser);		
			
			// add listener
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleTwoRequestsResults, 1000), false, 0, true);
			
			// set parser 
			parser = new request2.parserClass();

			// dispatch request 
			dispatcher.dispatch(request2, parser);
		}
		
		/**
		 * Verify if a fault occurs another request works as expected
		 */
		public function testTwoRequestFirstFault():void {
			var faultRequest:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_POST,'');
			var goodRequest:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_POST,'.xml');	
			
			// create params
			setNewTaskParams(faultRequest);
			setNewTaskParams(goodRequest);
			
			// create parser 
			var parser:TestTaskParser = new faultRequest.parserClass();
			
			// create dispatcher
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			// dispatch request 
			dispatcher.dispatch(faultRequest, parser);		
			
			// add listener
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleTwoRequestsResults, 1000), false, 0, true);
			
			// set parser 
			parser = new goodRequest.parserClass();

			// dispatch request 
			dispatcher.dispatch(goodRequest, parser);
		}
		
		/**
		 * Test verifies dispatcher cancels request correctly.
		 */
		public function testCancel():void {
			var slowRequest:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/slow');
			
			// create parser 
			var parser:TestTaskParser = new slowRequest.parserClass();
			
			// create dispatcher
			var dispatcher:TestHTTPRequestDispatcher = new TestHTTPRequestDispatcher();
			
			
			dispatcher.addEventListener(DispatcherEvent.RESULT, addAsync(handleCancelIfResult, 1000,null,handleCancelIfNoResult), false, 0, true);
			
			// dispatch request 
			var key:* = dispatcher.dispatch(slowRequest, parser);		
			
			// cancel it
			dispatcher.cancel(slowRequest, key);		
			
			assertTrue("Last result should be null", dispatcher.httpService.lastResult == null);	

		}
		// Event handler Methods
		public function handleGetResult(event:DispatcherEvent):void {
			assertTrue("Name should be 'test'", event.result.name == "TaskFromServer");
		}
		
		public function handlePostResult(event:DispatcherEvent):void {
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET);
			setNewTaskParams(request)
			assertTrue("Result name should match request name. See setNewTaskParams()", event.result.name == request.name);
			assertTrue("Result description should match request description. See setNewTaskParams()", event.result.description == request.description);
			assertTrue("Result completed should match request completed. See setNewTaskParams()", event.result.completed == request.completed);
		}
		public function handlePutResult(event:DispatcherEvent):void {
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET);
			setNewTaskParams(request)
			assertTrue("Result name should match request name. See setNewTaskParams()", event.result.name == request.name);
			assertTrue("Result description should match request description. See setNewTaskParams()", event.result.description == request.description);
			assertTrue("Result completed should match request completed. See setNewTaskParams()", event.result.completed == request.completed);
		}
		public function handleResult(event:DispatcherEvent):void {
			// No need to do anything
		}
		public function handleFault(event:DispatcherEvent):void {
			// No need to do anything
		}
		public function handleTwoRequestsResults(event:DispatcherEvent):void {
			// No need to do anything. As long as the method is called
		}
		public function handleCancelIfResult(event:DispatcherEvent):void {
			assertTrue("When Cancel, Result should not dispatch", false);
		}
		public function handleCancelIfNoResult(event:DispatcherEvent):void {
			// No need to do anything, Method verifies cancel worked
		}
		
		
		// Utility methods
		private function setNewTaskParams(request:TestHTTPRequest):void {
			request.name = "TaskNew";
			request.description = "A new test Task";
			request.completed = false;
		}
		
	}
}