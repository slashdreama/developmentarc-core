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
 * all copies or substantial portions of the Software.f
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
	import com.developmentarc.core.services.RequestDelegate;
	import com.developmentarc.core.services.events.RequestEvent;
	import com.developmentarc.core.services.requests.AbstractRequest;
	import com.developmentarc.core.services.requests.HTTPRequest;
	import com.developmentarc.core.services.requests.IRequest;
	import com.developmentarc.libtests.elements.service.FaultDispatcher;
	import com.developmentarc.libtests.elements.service.FaultParser;
	import com.developmentarc.libtests.elements.service.MockDispatcher;
	import com.developmentarc.libtests.elements.service.ResultDelayDispatcher;
	import com.developmentarc.libtests.elements.service.ResultDispatcher;
	import com.developmentarc.libtests.elements.service.ResultParser;
	import com.developmentarc.libtests.elements.service.TaskDO;
	import com.developmentarc.libtests.elements.service.TestHTTPRequest;
	import com.developmentarc.libtests.elements.service.TestRequest;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import flexunit.framework.TestCase;

	/**
	 * Class tests the RequestDelegate inside of the DevelopmentArc service layer
	 */
	public class RequestDelegateTests extends TestCase
	{
		public function RequestDelegateTests(methodName:String=null)
		{
			super(methodName);
		}
		
		 public  function testRequestDispatched():void {
			// Create request
			var request:IRequest = new TestRequest(ResultDispatcher, ResultParser);
			
			// Listen to request
			request.addEventListener(RequestEvent.DISPATCHED, addAsync(handleEvent, 1000), false, 0, true);
			
			// Start request
			request.start();
		} 
		
		/**
		 * Method verifies error handling from dispatcher.
		 */
		 public function testRequestErrorInDispatcher():void {
			// Create request
			var request:IRequest = new TestRequest(FaultDispatcher,ResultParser);
			
			// Listen to request
			request.addEventListener(RequestEvent.ERROR, addAsync(handleEvent, 1000), false, 0, true);
			
			// Start request
			 request.start();
		}
		/**
		 * Method verifies result is handled from dispatcher.
		 */
		 public function testRequestReturnedDispatcher():void {
			// Create request
			var request:IRequest = new TestRequest(ResultDispatcher,ResultParser);
			
			// Listen to request
			request.addEventListener(RequestEvent.RETURNED, addAsync(handleEvent, 1000), false, 0, true);
			
			// Start request
			request.start();
		} 
		
		/**
		 * Method verifies parsing hook is functioning.
		 */
		 public function testRequestParsing():void {
			// Create request
			var request:IRequest = new TestRequest(ResultDispatcher,ResultParser);
			
			// Listen to request
			request.addEventListener(RequestEvent.PARSING, addAsync(handleEvent, 1000), false, 0, true);
			
			// Start request
			request.start();
		} 
		
		/**
		 * Method verifies error handling from parser.
		 */
		 public function testRequestErrorInParser():void {
			// Create request
			var request:IRequest = new TestRequest(ResultDispatcher,FaultParser);
			
			// Listen to request
			request.addEventListener(RequestEvent.ERROR, addAsync(handleEvent, 1000), false, 0, true);
			
			// Start request
			request.start();
		} 
		
		/**
		 * Method verifies complete is marked when parsing is a success.
		 */
		 public function testRequestComplete():void {
			// Create request
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/1.xml');
			
			// Listen to request
			request.addEventListener(RequestEvent.COMPLETE, addAsync(handleEvent, 1000), false, 0, true);
			
			// Start request
			request.start();
		}
		
		public function testRequestStop():void {
			// Create request
			var request:TestHTTPRequest = new TestHTTPRequest(HTTPRequest.METHOD_GET,'/slow');
			
			// Listen to request
			request.addEventListener(RequestEvent.CANCEL, addAsync(handleRequestStop, 1000), false, 0, true);
			
			// Start request
			request.start();
			
			// Cancel Request
			request.stop();
		} 
		/**
		 * Test verifies two successful requests are handled correctly when
		 * first in is returned first
		 */
		 public function testTwoFIFOSuccessRequests():void {
			// Create request
			var request1:TestRequest = new TestRequest(ResultDispatcher,ResultParser);
			var request2:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			
			// Add reference to other
			request1.otherRequests.push(request2);
			request2.otherRequests.push(request1);
			
			// Listen to second request
			request2.addEventListener(RequestEvent.COMPLETE, addAsync(handleTwoFIFOSuccessRequests, 6000), false, 0, true);
			
			// Start requests
			request1.start();
			setTimeout(request2.start, 100);
				
		}
		/**
		 * Verfies two requests work as expected when first request returns last
		 */
		public function testTwoLIFOSuccessRequests():void {
			// Create request
			var request1:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			var request2:TestRequest = new TestRequest(ResultDispatcher, ResultParser);

			// Add reference to other
			request1.otherRequests.push(request2);
			request2.otherRequests.push(request1);
			
			// Listen to second request
			request1.addEventListener(RequestEvent.COMPLETE, addAsync(handleTwoLIFOSuccessRequests, 6000), false, 0, true);
			
			// Start requests
			request1.start();
			setTimeout(request2.start, 100);

		
		}
		/**
		 * Verifies a request is successful when the another fails during dispatch
		 */
		public function testOneErrorInDispatcherOneSuccess():void {
			// Create request
			var faultRequest:TestRequest = new TestRequest(FaultDispatcher,ResultParser);
			var successRequest:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);

			// Add reference to other
			faultRequest.otherRequests.push(successRequest);
			successRequest.otherRequests.push(faultRequest);
			
			// Listen to second request
			successRequest.addEventListener(RequestEvent.COMPLETE, addAsync(handleOneErrorInDispatcherOneSuccess, 6000), false, 0, true);
			
			// Start requests
			faultRequest.start();
			successRequest.start();
			
		}
		/**
		 * Verifies a request is successful when another request fails during parsing
		 */
		public function testOneErrorInParserOneSuccess():void {
			// Create request
			var faultRequest:TestRequest = new TestRequest(ResultDispatcher, FaultParser);
			var successRequest:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);

			// Add reference to other
			faultRequest.otherRequests.push(successRequest);
			successRequest.otherRequests.push(faultRequest);
			
			// Listen to second request
			successRequest.addEventListener(RequestEvent.COMPLETE, addAsync(handleOneErrorInParserOneSuccess, 6000), false, 0, true);
			
			// Start requests
			faultRequest.start();
			successRequest.start();
		}
		
		/**
		 * Verify a request is successful when another in the system is stopped
		 */
		public function testOneStopOneSuccess():void {
			// Create request
			var stopRequest:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			var successRequest:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);

			// Add reference to other
			stopRequest.otherRequests.push(successRequest);
			successRequest.otherRequests.push(stopRequest);
			
			// Listen to second request
			successRequest.addEventListener(RequestEvent.COMPLETE, addAsync(handleOneStopOneSuccess, 6000), false, 0, true);
			
			// Start requests
			stopRequest.start();
			successRequest.start();
			
			// Stop request
			stopRequest.stop();
		}
		
		public function testTwoRequestsSameDispatcher():void {
			// Create request
			var request1:TestRequest = new TestRequest(ResultDispatcher, ResultParser);
			var request2:TestRequest = new TestRequest(ResultDispatcher, ResultParser);

			// Add reference to other
			request1.otherRequests.push(request2);
			request2.otherRequests.push(request1);
			
			// Listen to second request
			request2.addEventListener(RequestEvent.COMPLETE, addAsync(handleTwoRequestsSameDispatcher, 6000), false, 0, true);
			
			// Start requests
			request1.start();
			request2.start();
		}
		
		/**
		 * Verify two requests work as expected when sharing the same parser
		 */
		public function testTwoRequestsSameParser():void {
			// Create request
			var request1:TestRequest = new TestRequest(ResultDispatcher, ResultParser);
			var request2:TestRequest = new TestRequest(ResultDispatcher, ResultParser);

			// Add reference to other
			request1.otherRequests.push(request2);
			request2.otherRequests.push(request1);
			
			// Listen to second request
			request2.addEventListener(RequestEvent.COMPLETE, addAsync(handleTwoRequestsSameParser, 6000), false, 0, true);
			
			// Start requests
			request1.start();
			request2.start();
		}
		
		public function testThreeRequestSuccessErrorInDispatcherSuccess():void {
			// Create requests
			var successRequest1:TestRequest = new TestRequest(ResultDispatcher, ResultParser);
			var errorRequest:TestRequest = new TestRequest(FaultDispatcher, ResultParser);
			var successRequest2:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			
			// Add reference to others for request we are listening to
			successRequest2.otherRequests.push(successRequest1);
			successRequest2.otherRequests.push(errorRequest);

			// Listen to last request
			successRequest2.addEventListener(RequestEvent.COMPLETE, addAsync(handleThreeRequestSuccessErrorInDispatcherSuccess, 6000), false, 0, true);
			
			// Start requests
			successRequest1.start();
			errorRequest.start();
			successRequest2.start();
		}
		
		/**
		 * Verify three requests, first successful, second error in parser, and third successful
		 */
		public function testThreeRequestSuccessErrorInParserSuccess():void {
			// Create requests
			var successRequest1:TestRequest = new TestRequest(ResultDispatcher, ResultParser);
			var errorRequest:TestRequest = new TestRequest(ResultDispatcher, FaultParser);
			var successRequest2:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			
			// Add reference to others for request we are listening to
			successRequest2.otherRequests.push(successRequest1);
			successRequest2.otherRequests.push(errorRequest);

			// Listen to last request
			successRequest2.addEventListener(RequestEvent.COMPLETE, addAsync(handleThreeRequestSuccessErrorInParserSuccess, 6000), false, 0, true);
			
			// Start requests
			successRequest1.start();
			errorRequest.start();
			successRequest2.start();
		}
		
		/**
		 * Verfiy three requests all work when they are all sucessful
		 */
		public function testThreeRequestSuccessSuccessSuccess():void {
			// Create requests
			var successRequest1:TestRequest = new TestRequest(ResultDispatcher, ResultParser);
			var successRequest2:TestRequest = new TestRequest(ResultDispatcher, ResultParser);
			var successRequest3:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			
			// Add reference to others for request we are listening to
			successRequest3.otherRequests.push(successRequest1);
			successRequest3.otherRequests.push(successRequest2);

			// Listen to last request
			successRequest3.addEventListener(RequestEvent.COMPLETE, addAsync(handleThreeRequestSuccessSuccessSuccess, 6000), false, 0, true);
			
			// Start requests
			successRequest1.start();
			successRequest2.start();
			successRequest3.start();
		}
		
		/**
		 * Verifes a request is successful after two requests fail in the parser
		 */
		public function testThreeRequestErrorInParserErrorInParserSuccess():void {
			// Create requests
			var parserErrorRequest1:TestRequest = new TestRequest(ResultDispatcher, FaultParser);
			var parserErrorRequest2:TestRequest = new TestRequest(ResultDispatcher, FaultParser);
			var successRequest:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			
			// Add reference to others for request we are listening to
			successRequest.otherRequests.push(parserErrorRequest1);
			successRequest.otherRequests.push(parserErrorRequest2);

			// Listen to last request
			successRequest.addEventListener(RequestEvent.COMPLETE, addAsync(handleThreeRequestErrorInParserErrorInParserSuccess, 6000), false, 0, true);
			
			// Start requests
			parserErrorRequest1.start();
			parserErrorRequest2.start();
			successRequest.start();
		}
		
		/**
		 * Verifies a request is successful after two requests fail, one in parser and one is dispatcher
		 */
		public function testThreeRequestErrorInParserErrorInDispatcherSuccess():void {
			// Create requests
			var parserErrorRequest:TestRequest = new TestRequest(ResultDispatcher, FaultParser);
			var dispatchErrorRequest:TestRequest = new TestRequest(FaultDispatcher, ResultParser);
			var successRequest:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			
			// Add reference to others for request we are listening to
			successRequest.otherRequests.push(parserErrorRequest);
			successRequest.otherRequests.push(dispatchErrorRequest);

			// Listen to last request
			successRequest.addEventListener(RequestEvent.COMPLETE, addAsync(handleThreeRequestErrorInParserErrorInDispatcherSuccess, 6000), false, 0, true);
			
			// Start requests
			parserErrorRequest.start();
			dispatchErrorRequest.start();
			successRequest.start();
		}
		
		/**
		 * Verifies a request is successful after two requests fail in dispatcher
		 */
		public function testThreeRequestErrorInDispatcherErrorInDispatcherSuccess():void {
			// Create requests
			var dispatcherErrorRequest1:TestRequest = new TestRequest(FaultDispatcher, ResultParser);
			var dispatcherErrorRequest2:TestRequest = new TestRequest(FaultDispatcher, ResultParser);
			var successRequest:TestRequest = new TestRequest(ResultDelayDispatcher, ResultParser);
			
			// Add reference to others for request we are listening to
			successRequest.otherRequests.push(dispatcherErrorRequest1);
			successRequest.otherRequests.push(dispatcherErrorRequest2);

			// Listen to last request
			successRequest.addEventListener(RequestEvent.COMPLETE, addAsync(handleThreeRequestErrorInDispatcherErrorInDispatcherSuccess, 6000), false, 0, true);
			
			// Start requests
			dispatcherErrorRequest1.start();
			dispatcherErrorRequest2.start();
			successRequest.start();
		}
		 
// Mock Test Metohds
		/**
		 * Verifies real dipatcher is used when RequestDelegate mode is "mock",
		 * but Dispatcher is in "live" mode.
		 */
		 public function testRequestMockModeDispatcherModeLive():void {
			// Set Delegate Mode to Mock
			RequestDelegate.mode = RequestDelegate.MODE_MOCK;
			
			// Create requests
			var request:TestRequest = new TestRequest(ResultDispatcher, ResultParser, AbstractRequest.MODE_LIVE, MockDispatcher);
			
			request.name = "MOCKMODEONE";
			// Listen to last request
			request.addEventListener(RequestEvent.COMPLETE, addAsync(handleDelegateMockModeDispatcherModeLive, 1000), false, 0, true);
			
			// Start requests
			request.start();
			
		} 
		/**
		 * Verifies real dispatcher is used when RequestDelegate mode is "mock", 
		 * and Dispatcher mode is "mock" but no mock dispatcher is assigned in the Request.
		 * This should throw a null exception"
		 */
		 public function testDelegateMockModeDispatcherModeMockNoMockDispatcher():void {
			// Set Delegate Mode 
			RequestDelegate.mode = RequestDelegate.MODE_MOCK;
			
			// Create requests
			var request:TestRequest = new TestRequest(ResultDispatcher, ResultParser, AbstractRequest.MODE_MOCK);
			
			// Start requests
			try {
				request.start();
			}
			catch(err:Error) {
				assertTrue("We should error here because no Mock will be found and we want to let the user know this", true);
				return;
			}
			
			assertTrue("We should not be here, the request should have errored because there is no mock", false);
		} 
		/**
		 * Verifies real dispatcher is used when RequestDelegate is in "live" mode and
		 * the disptacher is in "mock" mode
		 */
		 public function testDelegateLiveModeDispatherModeMock():void {
			
			RequestDelegate.mode = RequestDelegate.MODE_LIVE;
			// Create requests
			var request:TestRequest = new TestRequest(ResultDispatcher, ResultParser, AbstractRequest.MODE_LIVE, MockDispatcher);
			
			// Listen to last request
			request.addEventListener(RequestEvent.COMPLETE, addAsync(handleDelegateLiveModeDispatherModeMock, 1000), false, 0, true);
			
			// Start requests
			request.start();
		} 
		
		/**
		 * Verifies mock dispatcher is used when RequestDelegate mode is "mock", Request mode is
		 * "mock", and a mock dispatcher is provided"
		 */
		public function testDelegateMockModeDispatcherModeMockWithMockDispatcher():void {
			// Set Delegate Mode 
			RequestDelegate.mode = RequestDelegate.MODE_MOCK;
			
			// Create requests
			var request:TestRequest = new TestRequest(ResultDispatcher, ResultParser, AbstractRequest.MODE_MOCK, MockDispatcher);
			
			request.name = 'LASTONE TO NOT WORK';
			
			// Listen to last request
			request.addEventListener(RequestEvent.COMPLETE, addAsync(handleDelegateMockModeDispatcherModeMockWithMockDispatcher, 6000), false, 0, true);
			
			// Start requests
			request.start();
		}
		
		
// Event Method
		public function handleEvent(event:Event):void {
			// We were called.. nothing else to do
		}
		
		public function handleRequestStop(event:Event):void {
			// Verify request have a phase of CANCEL
			assertTrue("Request should be in the cancel phase", IRequest(event.currentTarget).phase == RequestEvent.CANCEL);
		}
		
		public function handleTwoFIFOSuccessRequests(event:Event):void {
			var request2:TestRequest = TestRequest(event.currentTarget);
			var request1:TestRequest = TestRequest(request2.otherRequests.pop());
			
			// Verify both requests are successful
			assertTrue("First request has completed", request1.phase == RequestEvent.COMPLETE);
			assertTrue("Second request has completed", request2.phase == RequestEvent.COMPLETE);
		}
		
		public function handleTwoLIFOSuccessRequests(event:Event):void {
			var request1:TestRequest = TestRequest(event.currentTarget);
			var request2:TestRequest = TestRequest(request1.otherRequests.pop());
			
			// Verify both requests are successful
			assertTrue("First request has completed", request1.phase == RequestEvent.COMPLETE);
			assertTrue("Second request has completed", request2.phase == RequestEvent.COMPLETE);
		}
		
		public function handleOneErrorInDispatcherOneSuccess(event:Event):void {
			var successRequest:TestRequest = TestRequest(event.currentTarget);
			var faultRequest:TestRequest = TestRequest(successRequest.otherRequests.pop());
			
			// Verify both requests are successful
			assertTrue("Failure request should have errored", faultRequest.phase == RequestEvent.ERROR);
			assertTrue("Success request has completed", successRequest.phase == RequestEvent.COMPLETE);
		}
		public function handleOneErrorInParserOneSuccess(event:Event):void {
			var successRequest:TestRequest = TestRequest(event.currentTarget);
			var faultRequest:TestRequest = TestRequest(successRequest.otherRequests.pop());
			
			// Verify both requests are successful
			assertTrue("Failure request should have errored", faultRequest.phase == RequestEvent.ERROR);
			assertTrue("Success request has completed", successRequest.phase == RequestEvent.COMPLETE);
		}
		
		public function handleOneStopOneSuccess(event:Event):void {
			var successRequest:TestRequest = TestRequest(event.currentTarget);
			var stopRequest:TestRequest = TestRequest(successRequest.otherRequests.pop());
			
			// Verify both requests are successful
			assertTrue("Stop request should have canceled", stopRequest.phase == RequestEvent.CANCEL);
			assertTrue("Success request has completed", successRequest.phase == RequestEvent.COMPLETE);
		}
		
		public function handleTwoRequestsSameDispatcher(event:Event):void {
			var request1:TestRequest = TestRequest(event.currentTarget);
			var request2:TestRequest = TestRequest(request1.otherRequests.pop());
			
			assertTrue("Requests should have same dispatcher", request1.dispatcher == request2.dispatcher);
		}
		public function handleTwoRequestsSameParser(event:Event):void {
			var request1:TestRequest = TestRequest(event.currentTarget);
			var request2:TestRequest = TestRequest(request1.otherRequests.pop());
			
			assertTrue("Requests should have same dispatcher", request1.parser == request2.parser);
		}
		
		public function handleThreeRequestSuccessErrorInDispatcherSuccess(event:Event):void {
			var successRequest2:TestRequest = TestRequest(event.currentTarget);
			var errorRequest:TestRequest = TestRequest(successRequest2.otherRequests.pop()); 
			var successRequest1:TestRequest = TestRequest(successRequest2.otherRequests.pop());
			
			assertTrue("First Success should have phase of Complete", successRequest1.phase == RequestEvent.COMPLETE);
			assertTrue("Second Success should have phase of Complete", successRequest2.phase == RequestEvent.COMPLETE);
			assertTrue("Error Request shoudl have Error phase", errorRequest.phase == RequestEvent.ERROR);
		}
		
		public function handleThreeRequestSuccessErrorInParserSuccess(event:Event):void {
			var successRequest2:TestRequest = TestRequest(event.currentTarget);
			var errorRequest:TestRequest = TestRequest(successRequest2.otherRequests.pop()); 
			var successRequest1:TestRequest = TestRequest(successRequest2.otherRequests.pop());
			
			assertTrue("First Success should have phase of Complete", successRequest1.phase == RequestEvent.COMPLETE);
			assertTrue("Second Success should have phase of Complete", successRequest2.phase == RequestEvent.COMPLETE);
			assertTrue("Error Request shoudl have Error phase", errorRequest.phase == RequestEvent.ERROR);
		}
		
		public function handleThreeRequestSuccessSuccessSuccess(event:Event):void {
			var successRequest3:TestRequest = TestRequest(event.currentTarget);
			var successRequest2:TestRequest = TestRequest(successRequest3.otherRequests.pop()); 
			var successRequest1:TestRequest = TestRequest(successRequest3.otherRequests.pop());
			
			assertTrue("First Request should have phase of Complete", successRequest1.phase == RequestEvent.COMPLETE);
			assertTrue("Second Request should have phase of Complete", successRequest2.phase == RequestEvent.COMPLETE);
			assertTrue("Third Request shoudl have Error phase", successRequest3.phase == RequestEvent.COMPLETE);
		}
		
		public function handleThreeRequestErrorInParserErrorInParserSuccess(event:Event):void {
			var successRequest:TestRequest = TestRequest(event.currentTarget);
			var parserErrorRequest2:TestRequest = TestRequest(successRequest.otherRequests.pop()); 
			var parserErrorRequest1:TestRequest = TestRequest(successRequest.otherRequests.pop());
			
			assertTrue("Success Request should have phase of Complete", successRequest.phase == RequestEvent.COMPLETE);
			assertTrue("First Parser Error Request should have phase of Error", parserErrorRequest1.phase == RequestEvent.ERROR);
			assertTrue("Second Parser Error Request should have phase of Error", parserErrorRequest2.phase == RequestEvent.ERROR);
		}
		
		public function handleThreeRequestErrorInParserErrorInDispatcherSuccess(event:Event):void {
			var successRequest:TestRequest = TestRequest(event.currentTarget);
			var dispatcherErrorRequest:TestRequest = TestRequest(successRequest.otherRequests.pop()); 
			var parserErrorRequest1:TestRequest = TestRequest(successRequest.otherRequests.pop());
			
			assertTrue("Success Request should have phase of Complete", successRequest.phase == RequestEvent.COMPLETE);
			assertTrue("Parser Error Request should have phase of Error", parserErrorRequest1.phase == RequestEvent.ERROR);
			assertTrue("Dispatcher  Error Request should have phase of Error", dispatcherErrorRequest.phase == RequestEvent.ERROR);
		}
		
		public function handleThreeRequestErrorInDispatcherErrorInDispatcherSuccess(event:Event):void {
			var successRequest:TestRequest = TestRequest(event.currentTarget);
			var dispatcherErrorRequest2:TestRequest = TestRequest(successRequest.otherRequests.pop()); 
			var dispatcherErrorRequest1:TestRequest = TestRequest(successRequest.otherRequests.pop());
			
			assertTrue("Success Request should have phase of Complete", successRequest.phase == RequestEvent.COMPLETE);
			assertTrue("First Dispatcher Error Request should have phase of Error", dispatcherErrorRequest1.phase == RequestEvent.ERROR);
			assertTrue("Second Dispatcher Error Request should have phase of Error", dispatcherErrorRequest2.phase == RequestEvent.ERROR);
		
		}
		
		public function handleDelegateMockModeDispatcherModeLive(event:Event):void {
			var task:TaskDO = TaskDO(TestRequest(event.currentTarget).data);
			
			assertTrue("Task name should be blank since we are using real dispatcher", task.name == null);
		}
		
		public function handleDelegateMockModeDispatcherModeMockWithMockDispatcher(event:Event):void {
			var task:TaskDO = TaskDO(TestRequest(event.currentTarget).data);
			
			assertTrue("Task name should be of the same value as in MockDispatcher.NAME", task.name == MockDispatcher.NAME);
		}
		public function handleDelegateLiveModeDispatherModeMock(event:Event):void {
			var task:TaskDO = TaskDO(TestRequest(event.currentTarget).data);
			
			assertTrue("Task name should be blank since we are using real dispatcher", task.name == null);
		
		}
	}
}