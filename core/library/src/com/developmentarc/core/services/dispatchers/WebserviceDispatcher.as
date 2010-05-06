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
package com.developmentarc.core.services.dispatchers
{
	import com.developmentarc.core.datastructures.utils.HashTable;
	import com.developmentarc.core.services.events.DispatcherEvent;
	import com.developmentarc.core.services.parsers.IParser;
	import com.developmentarc.core.services.requests.IRequest;
	import com.developmentarc.core.services.requests.WebserviceRequest;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;

	/**
	 * Class defines a dispatcher that wraps an instance of the Webservice class provided by Flex.  This class should be 
	 * used for any Webservice (WSDL) calls made in the serivce layer. The goal is to provide a Webserive manager, 
	 * that all requests can use to execute their required call.
	 * 
	 *  <p>* NOTE: Webservice is Flex specific and you will need the Flex 4.0+ SDK.</p>
	 * 
	 * <p>When using this dispatcher a WebserviceRequest or an extension is necessary to provide the method and content type of
	 * the incoming request which will be leveraged by the Webservice.</p>
	 * 
	 * <p>
	 * <b>Events</b>
	 * <br />
	 * <p>A DispatcherEvent.RESULT is dispatched upon a successful response from the Webservice.  The dispatcher bundles
	 * the unique id of the request, the resulting data, and the original event.</p>
	 * 
	 * <p>Upon a failure of the Webservice, a DispatcherEvent.FAULT is dispathced with the unique id and the original event.</p>
	 * @author "James Polanco"
	 * 
	 */
	public class WebserviceDispatcher extends AbstractDispatcher
	{
		/**
		 * Defines the active services used within the dispatcher. 
		 */		
		protected var activeServices:HashTable;
		
		/**
		 * Defines the active operations and their calls within the dispatcher. 
		 */		
		protected var activeOperations:HashTable;
		
		protected var activeRequests:HashTable;
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function WebserviceDispatcher()
		{
			super();
			construct();
		}
		
		/**
		 * Method takes the given request (IRequest) and parser (IParser) and updates the Webservice
		 * with the unique data of the request. The parser is important because it defines the resultFormat 
		 * of the data passed back from the service.
		 * 
		 * <p>When a request is dispatched through the WebserivceDispatcher, the dispatcher checks for the
		 * existance of the current service wsdl. If a service does not already exist for the requested wsdl path
		 * a new service is generated and used for dispatching. Webservices allow for multiple endpoints (methods) on a single
		 * wsdl location, and by default the dispatcher does not close the Webservices after all ther operations
		 * have been applied to improve performance.</p>
		 * 
		 * <p>If you wish for the dispather to disconnect the wsdl after all the operations have been completed, 
		 * set the keepConnection flag to false on all the requests that use the wsdl.</p>
		 * 
		 * <p>The request data that is provided by the request instance should either be in Object form, which
		 * will be converted to SOAP XML by the service automatically, or the data should be in XML form that the
		 * WSDL service is expecting.</p>
		 * 
		 * @param request IRequest for the desired request.
		 * @param parser IParser associated with the provied request.
		 * 
		 * @return * AsyncToken provided when calling send on the Operation.
		 */
		override public function dispatch(request:IRequest, parser:IParser):* {
			// configure the service
			var wsr:WebserviceRequest = WebserviceRequest(request);
			var service:WebService = getService(wsr.wsdl, wsr.keepConnection);
			
			var operation:Operation = Operation(service.getOperation(wsr.methodName));
			operation.request = wsr.requestData;
			operation.addEventListener(FaultEvent.FAULT, handleFault, false, 0, true);
			operation.addEventListener(ResultEvent.RESULT, handleResult, false, 0, true);
			
			var token:AsyncToken = wsr.token = operation.send();
			trackOperation(operation, token, request);
			
			return token;
		}
		
		/**
		 * Method cancels a given request based on the AsyncToken that is provided.
		 * 
		 * @param request The request needs to be a WebserviceRequest to provide the bound token.
		 * @param * AsyncToken Unique id of the request to cancel.
		 */
		override public function cancel(request:IRequest, key:*):void {
			var wsdl:String = WebserviceRequest(request).wsdl;
			var token:AsyncToken = WebserviceRequest(request).token;
			
			if(activeOperations.containsKey(wsdl)) {
				var table:HashTable = HashTable(activeOperations.getItem(wsdl));
				var id:String = token.message.messageId;
				if(table.containsKey(id)) {
					var operation:Operation = table.getItem(id);
					operation.cancel(id);
					clearServiceIfRequired(WebService(operation.service), id, token);
				}
			}
		}
		
		/**
		 * helper method to construct properties and allow JIT. 
		 * 
		 */		
		protected function construct():void {
			activeServices = new HashTable();
			activeOperations = new HashTable();
			activeRequests = new HashTable();
		}

		/**
		 * method handles FaultEvent.FAULT events that are dispatched from the Webservice Operation.
		 * The method will map the event token (AsyncToken) and the original event to a new 
		 * DispatcherEvent with a type of FAULT and dispatch.
		 * 
		 * @param event FaultEvent from a given request.
		 */
		protected function handleFault(event:FaultEvent):void
		{
			// this is a service level fault, ignore the operation fault
			if(!event.token) return;
			
			var operation:Operation = Operation(event.currentTarget);
			operation.removeEventListener(FaultEvent.FAULT, handleFault);
			operation.removeEventListener(ResultEvent.RESULT, handleResult);
			
			clearServiceIfRequired(WebService(operation.service), event.token.message.messageId, event.token);
			
			var dispatcherEvent:DispatcherEvent = new DispatcherEvent(DispatcherEvent.FAULT);
			// Mapping origin event to new event
			dispatcherEvent.uid = event.token;
			dispatcherEvent.originalEvent = event;
			dispatchEvent(dispatcherEvent);
		}
		
		/**
		 * Method handles service faults, usually created by a down server, invalid path
		 * or some other kind of fatal error.  This method clears all the instances of the requests
		 * and marks them as errored.
		 * 
		 * @param event The dispatched service event.
		 * 
		 */		
		protected function handleServiceFault(event:FaultEvent):void {
			// we have a service fault, error out all the requests
			var service:WebService = WebService(event.currentTarget);
			var requests:Array = HashTable(activeRequests.getItem(service.wsdl)).getAllKeys();
			var len:int = requests.length;
			for (var i:int = 0; i < len; i++) {
				var dispatcherEvent:DispatcherEvent = new DispatcherEvent(DispatcherEvent.FAULT);
				// Mapping origin event to new event
				dispatcherEvent.uid = AsyncToken(requests[i]);
				dispatcherEvent.originalEvent = event;
				dispatchEvent(dispatcherEvent);
			}
			
			clearServiceIfRequired(service, undefined, null);
		}

		/**
		 * Method handles ResultEvent.RESULT events that are dispatched from the Webservice Operation.
		 * The method will take the event token (AsyncToken), result data and the original event
		 * and bundle it inside of a DispatcherEvent with a type of RESULT and dispatch.
		 * 
		 * @param event ResultEvent from a given request.
		 */
		protected function handleResult(event:ResultEvent):void
		{
			var operation:Operation = Operation(event.currentTarget);
			operation.removeEventListener(FaultEvent.FAULT, handleFault);
			operation.removeEventListener(ResultEvent.RESULT, handleResult);
			
			clearServiceIfRequired(WebService(operation.service), event.token.message.messageId, event.token);
			
			var dispatcherEvent:DispatcherEvent = new DispatcherEvent(DispatcherEvent.RESULT);
			
			// Mapping origin event to new event
			dispatcherEvent.uid = event.token;
			dispatcherEvent.result = event.result;
			dispatcherEvent.originalEvent = event;
			
			dispatchEvent(dispatcherEvent);
		}
		
		/**
		 * Used to track the current operation and its associated calls based
		 * on the async token.  This allows the dispatcher to determine when and
		 * if the assoicated service should be disconnected once all items are done.
		 * 
		 * @param operation The operation being applied.
		 * @param token The generated async token from send() command.
		 * 
		 */		
		protected function trackOperation(operation:Operation, token:AsyncToken, request:IRequest):void {
			// track the operations
			var wsdl:String = WebService(operation.service).wsdl;
			if(activeOperations.containsKey(wsdl)) {
				HashTable(activeOperations.getItem(wsdl)).addItem(token.message.messageId, true);
			} else {
				var table:HashTable = new HashTable();
				table.addItem(token.message.messageId, true);
				activeOperations.addItem(wsdl, table);
			}
			
			// track the requests
			if(activeRequests.containsKey(wsdl)) {
				HashTable(activeRequests.getItem(wsdl)).addItem(token, request);
			} else {
				var tableRequest:HashTable = new HashTable();
				tableRequest.addItem(token, request);
				activeRequests.addItem(wsdl, tableRequest);
			}
		}
		
		/**
		 * Checks to determine of the current service has completed all of the associated
		 * calls and if the service is marked to be removed.  If all the calls are done
		 * and the webservice is marked as to be disconnected, it is the shutdown and
		 * removed.
		 *  
		 * @param operation The associated operation for the service.
		 * @param id The token message id.
		 * 
		 */		
		protected function clearServiceIfRequired(service:WebService, id:String, token:AsyncToken):void {
			var wsdl:String = service.wsdl;
			
			// clean up operations and the service
			var activeTokens:HashTable = HashTable(activeOperations.getItem(wsdl));
			if(id){ activeTokens.remove(id); } else { activeTokens.removeAll(); }
			if(activeTokens.isEmpty && !activeServices.containsKey(wsdl)) {
				// all calls are done, remove the service
				service.disconnect();
				service.removeEventListener(FaultEvent.FAULT, handleServiceFault);
				activeOperations.remove(wsdl);
			}
			
			// clean up the requests
			var requests:HashTable = HashTable(activeRequests.getItem(wsdl));
			if(token){ requests.remove(token); } else { requests.removeAll(); }
			if(requests.isEmpty) {
				activeRequests.remove(wsdl);
			}
		}
		
		/**
		 * Method returns a service based on the provided wsdl string.  If the service
		 * already exists and the user has marked it as keepConnected (default) then
		 * the same instance is returned to the caller. Otherwise a new instance is generated
		 * and returned.
		 *  
		 * @param wsdl The WSDL service path.
		 * @param keepConnection Defines if the service should be kept upon call completion.
		 * @return 
		 * 
		 */		
		protected function getService(wsdl:String, keepConnection:Boolean):WebService {
			if(activeServices.containsKey(wsdl)) {
				return WebService(activeServices.getItem(wsdl));
			}
			
			var service:WebService = new WebService();
			service.wsdl = wsdl;
			service.addEventListener(FaultEvent.FAULT, handleServiceFault, false, 0, true);
			service.loadWSDL();
			if(keepConnection) activeServices.addItem(wsdl, service);
			return service;
		}
	}
}