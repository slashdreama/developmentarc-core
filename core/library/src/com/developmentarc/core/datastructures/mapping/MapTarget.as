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
	 * The MapTarget defines the relationship between the type of data (identifier)
	 * and the subsciber/clients that get the data pushed to them.  When a DataMap
	 * is created a set of MapTargets are created defining a type (how to indentify/assign data)
	 * and a set of MapInstances that correspond to the client instance to push to.  These
	 * MapTargets are used as a lookup system to match listeners to their data.
	 * 
	 * @author James Polanco
	 * 
	 */
	public class MapTarget implements IMXMLObject
	{
		/**
		 * Defines if the child instances should have their data
		 * wrapped in a MapDataWrapper.  If this is set to true then
		 * the corresponding property type should expect a MapDataWrapper.
		 * 
		 * <p>This wrapping is done dynamkically at the time of data
		 * push and is used to provide additional information.</p> 
		 */
		public var useDataWrapper:Boolean = false;
		
		/**
		 * Constructor. 
		 * 
		 */
		public function MapTarget()
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
		
		// public accessor for type
		private var _type:String;
		
		/**
		 * The type defines when the map target's instances should be processed
		 * passing in the type of data.
		 */
		public function get type():String {
			return _type;
		}
		
		public function set type(value:String):void {
			_type = value;
		}
		
		// public accessor for clients
		private var _instances:Object;
		
		/**
		 * The instances define how he data is mapped to an
		 * instance and the property used.
		 */
		public function get instances():Object {
			return _instances;
		}
		
		public function set instances(value:Object):void {
			_instances = value;
		}
		
		/* PUBLIC METHODS */
		/**
		 * Called when the MapTarget is initialized via MXML. 
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