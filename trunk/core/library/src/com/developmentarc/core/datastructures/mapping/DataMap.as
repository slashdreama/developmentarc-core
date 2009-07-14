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
	import com.developmentarc.core.datastructures.utils.HashTable;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IMXMLObject;
	
	/**
	 * The DataMap is a data mapping utility that allows you to push data to
	 * multiple sources at one time.  By enabling a one to many relationship this
	 * removes the strict coupling of Models to View instances.  This mapping tool
	 * consolidates all of the data binding/relationship references into one configuration
	 * location.
	 * 
	 * <p>The DataMap can be used in place of change watchers to update data in a 
	 * view and/or a model.  It is not recommended to use the DataMap in place of a
	 * model system, but to augment it as a way to handle data updates to models and
	 * other views in a classic MVC structured application.</p>
	 * 
	 * 
	 * @author James Polanco
	 * 
	 */
	public class DataMap implements IMXMLObject
	{
		/* STATIC PRIVATE PROPERTIES */
		static private var _instances:HashTable;
		static private var _clients:HashTable;
		
		/* STATIC PUBLIC METHODS */
		/**
		 * Used to register a client to the data map.  This method should
		 * be done during construction or as early as possible.  If data has
		 * been saved before a client is registered the data will not be pushed
		 * to the client.
		 *  
		 * @param client The client instance to register/
		 * 
		 */
		static public function registerClient(client:Object):void {
			// store client
			if(!_clients) _clients = new HashTable();
			
			// get class instance name
			var className:String = getQualifiedClassName(client);
			var table:HashTable;
			if(_clients.containsKey(className)) {
				// existing type, add it
				table = HashTable(_clients.getItem(className));
				table.addItem(client, true);
			} else {
				// new type, add and create lookup child table
				table = new HashTable();
				table.addItem(client, true);
				_clients.addItem(className, table);
			}
		}
		
		/**
		 * Removes the client object from the DataMap so that any further
		 * saved data is no longer published to the client.
		 * 
		 * @param client The target instance to remove.
		 * 
		 */
		static public function unregisterClient(client:Object):void {
			var className:String = getQualifiedClassName(client);
			if(!_clients || !_clients.containsKey(className)) return; // we do not have it
			
			var instances:HashTable = _clients.getItem(className);
			if(instances.containsKey(client)) instances.remove(client);
			if(instances.isEmpty) _clients.remove(className);
		}
		
		/**
		 * Saves the data to any mapped instances bound to the data type.  The parameters
		 * argument is an optional argument that allows for configuration data or other information
		 * to be passed onto the registered client(s).
		 * 
		 * <p>It's important to note that the parameters data is NOT passed onto the client
		 * unless the useDataWrapper property is set to true on the corresponding MapTarget.
		 * The wrapper object is created dynamically at the time of data push so any registered
		 * clients should expect a MapDataWrapper object as the data type if this is set.</p>
		 *  
		 * @param type The data type that matches the type defined on the MapTarget.
		 * @param data The data to be pushed to the clients.
		 * @param parameters Optional parameter/data object for configuration, requires useDataWrapper set to true on the MapTarget.
		 * 
		 */
		static public function save(type:String, data:*, parameters:Object = undefined):void {
			if(!_instances) return;
			var insts:Array = _instances.getAllKeys();
			var len:int = insts.length;
			for(var i:uint = 0; i < len; i++) {
				DataMap(insts[i])._save(type, data, parameters);
			}
		}
		
		/**
		 * Removes all instances and clients from the data map.  Should not
		 * be used if the data map is defined via MXML.  This is exposed as
		 * protected to be used as an extension for testing.
		 * 
		 */
		static protected function clearDataMap():void {
			// walk through all the hashmaps and clear them
			if(_clients) {
				var maps:Array = _clients.getAllItems();
				for each(var item:HashTable in maps) item.removeAll();
				_clients.removeAll();
			}
			if(_instances) _instances.removeAll();
		}
		
		/**
		 * The DataMap Constructor. 
		 * 
		 */		
		public function DataMap() {
			construct();
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
		
		// public accessor for targets
		private var _targets:Object;
		
		/**
		 * Targets define the MapTarget instances that are mapped within
		 * the DataMap instance.  The data passed should either be a single
		 * MapTarget or an Array of MapTargets.
		 */
		public function get targets():Object {
			return _targets;
		}
		
		public function set targets(value:Object):void {
			// convert to an array
			_targets = value;
		}
		
		/* PUBLIC METHODS */
		/**
		 * Called when the DataMap is initialized via MXML. 
		 * @param document The current document.
		 * @param id The MXML defined id.
		 * 
		 */
		public function initialized(document:Object, id:String):void {
			this.document = document;
			this.id = id;
		}
		
		/* PROTECTED METHODS */
		/**
		 * Used to move init calls out of the constructor. 
		 * 
		 */
		protected function construct():void {
			// store the client
			if(!_instances) _instances = new HashTable();
			_instances.addItem(this, true);
		}
		
		/**
		 * Instance implementation of the save() method.
		 *  
		 * @param type
		 * @param data
		 * @param parameters
		 * 
		 */
		protected function _save(type:String, data:*, parameters:Object = undefined):void {
			// make sure we have targets
			if(!_targets) return;
			
			// find the matching targets
			var targetList:Array = (_targets is Array) ? _targets as Array : [_targets];
			var len:int = targetList.length;
			var target:MapTarget;
			for(var i:uint = 0; i < len; i++) {
				var t:MapTarget = targetList[i];
				// check for undefined types
				if(!t.type) throw Error("The type for a MapTarget was not defined.  Make sure that all Map Targets type's are defined.");
				if(t.type == type) {
					target = t;
					break;
				} 
			}
			
			// matching target not found
			if(!target) return;
			
			// apply client data
			var instances:Array = (target.instances is Array) ? target.instances as Array : [target.instances];
			var iLen:int = instances.length;
			for(var ii:uint = 0; ii < iLen; ii++) {
				var instance:MapInstance = MapInstance(instances[ii]);
				// check that its a valid instance
				if(!instance.classType) throw Error("The classType for a MapInstance was not defined.  Verify that all MapInstances have a classType defined.");
				if(!instance.property) throw Error("The property for a MapInstance was not defined.  Verify that all MapInstances have a property defined.");
				var className:String = getQualifiedClassName(instance.classType);
				// see of we have any clients for this type
				if(_clients.containsKey(className)) {
					// we do, apply the data
					var clients:Array = HashTable(_clients.getItem(className)).getAllKeys();
					var cLen:int = clients.length;
					// loop over instances
					for(var iii:uint = 0; iii < cLen; iii++) {
						var inst:Object = clients[iii];
						// set the data
						if(inst.hasOwnProperty(instance.property)) {
							// see if we have a complex property
							var subdata:* = (instance.complexProperty) ? data[instance.complexProperty] : data;
							inst[instance.property] = (target.useDataWrapper) ? new MapDataWrapper(type, subdata, parameters) : subdata;
						}
					}
				}
			}
		}

	}
}