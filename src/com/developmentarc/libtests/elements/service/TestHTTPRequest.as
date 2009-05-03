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
	import com.developmentarc.core.services.requests.HTTPRequest;

	/**
	 * Class is used to test the HTTPRequest via the test server on 
	 * DevelopmentArc.com
	 */
	public class TestHTTPRequest extends HTTPRequest
	{
		
		/**
		 * Property name for the request parameters
		 */
		public var name:String;
		
		/**
		 * Propety description for the request parameters
		 */
		public var description:String;
		
		/**
		 * Property completed for the request parameters
		 */
		public var completed:Boolean;
		
		public var data:TaskDO;
		
		/**
		 * Holds other requests in the test, so you have reference when
		 * verifying a single request via  listener event
		 */
		public var otherRequests:Array;
		
		/**
		 * Constructor
		 * 
		 * @param type Type of request. GET or POST
		 * @param source API to request
		 */
		public function TestHTTPRequest(type:String, source:String="")
		{
			super(type, "http://test.developmentarc.com/tasks", source, TestHTTPRequestDispatcher, TestTaskParser);
			
			otherRequests = new Array();
		}
		
		override public function get method():String {
			return type;
		}
		
		/**
		 * Method returns an object with name, description, completed
		 */
		override public function get params():Object {
			var parameters:Object = new Object();
			
			parameters["name"] = name;
			parameters["description"] = description;
			parameters["completed"] = completed;
			
			return parameters;		
		}
		
		/**
		 * Saves data locally so test can verify
		 */
		override public function saveData(data:*):void {
			data = TaskDO(data);
		}
	}
}