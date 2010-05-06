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

	public class WebserviceRequest extends AbstractRequest
	{
		public var keepConnection:Boolean = true;
		
		public var requestData:Object;
		
		public var token:AsyncToken;
		
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
		
		public function get methodName():String { return source; }
		
		public function get wsdl():String { return uri; }
		
	}
}