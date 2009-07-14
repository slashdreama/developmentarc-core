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
package com.developmentarc.core.datastructures.mapping
{
	import mx.core.IMXMLObject;

	/**
	 * The MapInstance binds a class type to the property/setter
	 * that should be used to pass the pushed data in.
	 *  
	 * @author James Polanco
	 * 
	 */
	public class MapInstance implements IMXMLObject
	{
		/**
		 * The corresponding class to the instance mapping. 
		 */
		public var classType:Class;
		/**
		 * The property/setter on the instance that should have the value
		 * set to the incoming data. 
		 */
		public var property:String;
		
		/**
		 * Enables grouping of complex data in a name/value pair so that
		 * a single MapTarget can have data organized and then branched
		 * into different instances.  This property is optional and the
		 * value assigned MUST exist in the data being pushed.
		 * 
		 * <p>For example, the application first needs to process the data
		 * and store aspects of it in different locations.  By defining the
		 * complexProperty value, the same MapTarget can take the data object and
		 * store parts of it in different instances.  If the data was configured as
		 * { foo: "bar", baz: "boo"} and the complexProperty was set to "baz" for
		 * this instance the target instance would get the "boo" value.</p>
		 */
		public var complexProperty:String;
		
		/**
		 * Constructor. 
		 * 
		 */
		public function MapInstance()
		{
		}
		
		/* PUBLIC ACCESSORS */
		
		// public accessor for id
		private var _id:String;
		
		/**
		 * ID of the component. This value becomes the instance name of the object 
		 * and should not contain any white space or special characters. Each 
		 * component throughout an application should have a unique id.
		 * 
		 * <p>If your application is going to be tested by third party tools, give 
		 * each component a meaningful id. Testing tools use ids to represent the 
		 * control in their scripts and having a meaningful name can make scripts 
		 * more readable. For example, set the value of a button to submit_button 
		 * rather than b1 or button1.</p>
		 * 
		 */
		public function get id():String {
			return _id;
		}
		
		public function set id(value:String):void {
			_id = value;
		}
		
		// public accessor for document
		private var _document:Object;
		
		/**
		 * A reference to the document object associated with this UIComponent. 
		 * A document object is an Object at the top of the hierarchy of a Flex 
		 * application, MXML component, or AS component.
		 * 
		 */
		public function get document():Object {
			return _document;
		}
		
		public function set document(value:Object):void {
			_document = value;
		}

		/**
		 * Called when the MapInstance is initialized via MXML. 
		 * @param document The current document.
		 * @param id The MXML defined id.
		 * 
		 */
		public function initialized(document:Object, id:String):void {
			this.document = document;
			this.id = id;
		}
		
	}
}