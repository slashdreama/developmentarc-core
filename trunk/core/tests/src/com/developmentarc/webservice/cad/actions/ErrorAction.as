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
package com.developmentarc.webservice.cad.actions
{
	import com.developmentarc.core.actions.actions.AbstractAction;
	import com.developmentarc.webservice.cad.commands.WebserviceCommand;
	import com.developmentarc.webservice.services.parsers.WebserviceObjectParser;
	import com.developmentarc.webservice.services.requests.TestWebserviceRequest;
	
	import flash.events.Event;
	
	public class ErrorAction extends AbstractAction
	{
		public function ErrorAction()
		{
			super();
		}
		
		override public function applyAction(command:Event):void {
			var zipcode:uint = WebserviceCommand(command).zipcode;
			var wsdl:String = "http://developmentarc.com/foo";
			var method:String = "GetWeatherByZipCode";
			var data:Object = {ZipCode: zipcode};
			var request:TestWebserviceRequest = new TestWebserviceRequest(TestWebserviceRequest.WEATHER_WEBSERVICE_REQUEST,wsdl,method,data,WebserviceObjectParser);
			request.start();
		}
	}
}