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
package com.developmentarc.core.services.requests
{
	import com.developmentarc.core.services.dispatchers.WebserviceDispatcher;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.soap.SOAPHeader;

	/**
	 * The WebserviceRequest is the base class for creating calls to the webservices
	 * using the WebserviceDelegate. When a request is generated, the start() method is called
	 * invoke the webservice based on the wsdl and method name passed to the constructor.  This
	 * request uses the wsdl as the path to the server, the method name as the operation and
	 * passes the requestData object to Webservice Operation to configure the query.
	 * 
	 * <p>When data is returned the WebserviceRequest phase is updated and the provided parser
	 * class is used to format the data.  Once the data has been passed the saveData() method
	 * is called by the delegate on the request.  This allows for developers to respond to the
	 * data and store it in a desired location.<p>
	 * 
	 * <p>* NOTE: HTTPRequest is Flex specific and you will need the Flex 3.0+ SDK.</p>
	 * 
	 * @author "James Polanco"
	 * 
	 */
	public class WebserviceRequest extends AbstractRequest
	{
		/**
		 * When a webservice instance is created the dispatcher, the connection to the
		 * service can be left open or closed once the operation and the request is
		 * complete.  When set to true, the service is left open for future calls, if
		 * set to false the service is disconnected upon completion of the calls.
		 * 
		 * <p>It is generally good practice to keep the connection open because
		 * it increases performance on subsequent calls. If you know the service will
		 * no longer be used after the initial operations then setting the value to
		 * false will help free up memory by disconnecting and removing the service.</p> 
		 */
		public var keepConnection:Boolean = true;
		
		/**
		 * The data being sent to the operation (method) on the service.  The data
		 * can be formatted in an Object, and if so SOAP XML will be generated by
		 * the operation from the object, or XML can be provided and will be sent
		 * to the server as is by the operation. 
		 */		
		public var requestData:Object;
		
		/**
		 * Defines the SOAP header to be used for the request's operation.  This enables
		 * a custom header data for authentication and QName support. 
		 */		
		public var header:SOAPHeader;
		
		/**
		 * The assigned async token to the request once the send() method is called
		 * on the webservice operation. 
		 */		
		public var token:AsyncToken;
		
		/**
		 * Constructor configures the request.
		 *  
		 * @param type The unique type for the service request.
		 * @param wsdl The WSDL path to the SOAP service.
		 * @param methodName The operation name to call on the service.
		 * @param requestData The data to pass to the service (Object or XML)
		 * @param parserClass The parser class used to format the data on return.
		 * @param mode Defines if the service is live or mock.	
		 * @param mockClass The class used to generate mock data.
		 * 
		 */		
		public function WebserviceRequest(type:String, 
										  wsdl:String, 
										  methodName:String,
										  requestData:Object,
										  parserClass:Class, 
										  mode:String=MODE_LIVE, 
										  mockClass:Class=null) {
			
			super(type, wsdl, methodName, WebserviceDispatcher, parserClass, mode, mockClass);
			
			this.requestData = requestData;

		}
		
		/**
		 * The method name of the service that the request uses, defined at construction. 
		 * 
		 */		
		public function get methodName():String { return source; }
		
		/**
		 * The wsdl path of the service, defined at construction.
		 * 
		 */		
		public function get wsdl():String { return uri; }
		
		/**
		 * Blank override that allows developers to use this request without having
		 * to override it to prevent the errors from the Abstract.  Its recommended
		 * to override this in a new class to provide the ability to save the data in
		 * a valid location as required.
		 *  
		 * @param data The data returned by the parser.
		 * 
		 */		
		override public function saveData(data:*):void {
			// default response is nothing, allows parser to handle storage if required
		}
		
	}
}