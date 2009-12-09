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
	
	public class MapStore implements IMXMLObject
	{	
		/**
		 * Stores the optional parameter set proivded during the data
		 * save for data wrapping.  This is not required for the data
		 * to be saved, but enables the ability for the system to pass
		 * this on when new clients are registered. 
		 */		
		public var dataParameters:Object;
		
		public var dataType:String;
		
		// used to store data when an instance is not provided
		private var _internalStore:*;
		
		/**
		 * Constructor. 
		 * 
		 */		
		public function MapStore()
		{
		}
		
		/* PUBLIC ACCESSORS */
		
		// public accessor for instance
		private var _instance:Object;
		
		public function get instance():Object {
			return _instance;
		}
		
		public function set instance(value:Object):void {
			_instance = value;
		}
		
		// public accessor for property
		private var _property:String;
		
		public function get property():String {
			return _property;
		}
		
		public function set property(value:String):void {
			_property = value;
		}
		
		
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
		
		/* PUBLIC METHODS */
		/**
		 * Called when the MapStore is initialized via MXML. 
		 * @param document The current document.
		 * @param id The MXML defined id.
		 * 
		 */
		public function initialized(document:Object, id:String):void {
			this.document = document;
			this.id = id;
		}
		
		public function saveData(type:String, data:*, parameters:Object = null):void {
			this.dataType = type;
			this.dataParameters = parameters;
			
			if(_instance) {
				// we have an instance
				if(!_property) throw new Error("A property was not assigned to the data map store instance for: " + _instance);
				if(_instance.hasOwnProperty(_property)) {
					_instance[_property] = data;
				} else {
					throw new Error("The property "+ _property +" does not exist on the target instance assigned in the data map store.");
				}
			} else {
				// save on our own property
				_internalStore = data;
			}
		}
		
		public function getData():* {
			var out:*;
			if(_instance) {
				// get the value out of the store
				if(!_property) throw new Error("A property was not assigned to the data map store instance for: " + _instance);
				if(_instance.hasOwnProperty(_property)) {
					out = _instance[_property];
				} else {
					throw new Error("The property "+ _property +" does not exist on the target instance assigned in the data map store.");
				}
			} else {
				// get the data from the internal store
				out = _internalStore;
			}
			return out;
		}

	}
}