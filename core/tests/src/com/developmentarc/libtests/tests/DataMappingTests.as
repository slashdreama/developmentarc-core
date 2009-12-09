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
package com.developmentarc.libtests.tests
{
	import com.developmentarc.core.datastructures.mapping.DataMap;
	import com.developmentarc.core.datastructures.mapping.MapInstance;
	import com.developmentarc.core.datastructures.mapping.MapStore;
	import com.developmentarc.core.datastructures.mapping.MapTarget;
	import com.developmentarc.libtests.elements.datamapping.ClearDataMap;
	import com.developmentarc.libtests.elements.datamapping.MapItemOne;
	import com.developmentarc.libtests.elements.datamapping.MapItemTwo;
	
	import flexunit.framework.TestCase;
	
	import mx.collections.ArrayCollection;

	/**
	 * The data mapping tests are used to verify that the DataMap and
	 * dependent classes function correctly.
	 *  
	 * @author James Polanco
	 * 
	 */
	public class DataMappingTests extends TestCase
	{
		public const TEST_ONE:String = "testOne";
		public const TEST_TWO:String = "testTwo";
		public const TEST_THREE:String = "testThree";
		
		/**
		 * Constructor.
		 *  
		 * @param methodName
		 * 
		 */
		public function DataMappingTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Resets the DataMap after each test. 
		 * 
		 */
		override public function tearDown():void {
			super.tearDown();
			
			ClearDataMap.reset();
		}
		
		/**
		 * Verifies that a single item can be mapped and that calling
		 * save() on the DataMap updates the bound property correctly. 
		 * 
		 */
		public function testSingleTarget():void {
			
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = inst;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
						
			// call save() and verify value
			var data:String = "hello";
			DataMap.save(TEST_ONE, data);
			assertTrue("The data was not saved in the targetOne property correctly.", data == mapItemOne.targetOne);
		}
		
		/**
		 * Verify that having different targets only updates the correct property for
		 * the assigned target when dispatched.
		 * 
		 */		
		public function testMultiTarget():void {
			// create the instances
			var inst1:MapInstance = new MapInstance();
			inst1.classType = MapItemOne;
			inst1.property = "targetOne";
			
			var inst2:MapInstance = new MapInstance();
			inst2.classType = MapItemOne;
			inst2.property = "targetTwo";
			
			// create the targets
			var target1:MapTarget = new MapTarget();
			target1.type = TEST_ONE;	
			target1.instances = inst1;
			
			var target2:MapTarget = new MapTarget();
			target2.type = TEST_TWO;	
			target2.instances = inst2;
			
			// create the map
			var map:DataMap = createDataMap([target1, target2]);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
						
			// call save() and verify value
			var data:String = "hello";
			DataMap.save(TEST_ONE, data);
			assertTrue("The data was not saved in the targetOne property correctly.", data == mapItemOne.targetOne);
			assertUndefined("Target two should not have updated with the TEST_ONE binding.", mapItemOne.targetTwo);
			
			data = "foo";
			DataMap.save(TEST_TWO, data);
			assertTrue("Target two was not updated with the TEST_TWO message.", data == mapItemOne.targetTwo);
			assertTrue("Target one should not have changed", mapItemOne.targetOne == "hello");
		}
		
		/**
		 * Verifies that multiple instances in a single target are
		 * updated when a message is saved.
		 * 
		 */
		public function testMulitInstance():void {
			// create the instances
			var inst1:MapInstance = new MapInstance();
			inst1.classType = MapItemOne;
			inst1.property = "targetOne";
			
			var inst2:MapInstance = new MapInstance();
			inst2.classType = MapItemOne;
			inst2.property = "targetTwo";
			
			var inst3:MapInstance = new MapInstance();
			inst3.classType = MapItemTwo;
			inst3.property = "targetTwo";
			
			var inst4:MapInstance = new MapInstance();
			inst4.classType = MapItemTwo;
			inst4.property = "targetOne";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = [inst1, inst2, inst3, inst4];
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the item
			var mapItemOne:MapItemOne = new MapItemOne();
			var mapItemTwo:MapItemTwo = new MapItemTwo();
			
			// call save() and verify values
			var data:String = "bar";
			DataMap.save(TEST_ONE, data);
			assertTrue("The data was not saved in the MapItemOne.targetOne property correctly.", data == mapItemOne.targetOne);
			assertTrue("The data was not saved in the MapItemOne.targetTwo property correctly.", data == mapItemOne.targetTwo);
			assertTrue("The data was not saved in the MapItemTwo.targetOne property correctly.", data == mapItemTwo.targetOne);
			assertTrue("The data was not saved in the MapItemTwo.targetTwo property correctly.", data == mapItemTwo.targetTwo);
		}
		
		/**
		 * Verifies that having multiple instances of the same class type
		 * are all updated when bound to an MapInstance. 
		 * 
		 */		
		public function testMultiClassInstance():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = inst;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var item1:MapItemOne = new MapItemOne();
			var item2:MapItemOne = new MapItemOne();
			var item3:MapItemOne = new MapItemOne();
			var item4:MapItemOne = new MapItemOne();
			
			// call save() and verify value
			var data:String = "hello";
			DataMap.save(TEST_ONE, data);
			assertTrue("The data was not saved in the targetOne property correctly for item1.", data == item1.targetOne);
			assertTrue("The data was not saved in the targetOne property correctly for item2.", data == item2.targetOne);
			assertTrue("The data was not saved in the targetOne property correctly for item3.", data == item3.targetOne);
			assertTrue("The data was not saved in the targetOne property correctly for item4.", data == item4.targetOne);
		}
		
		/**
		 * Verify that a class can unregister and it no longer recieves updates. 
		 * 
		 */		
		public function testUnregister():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = inst;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
						
			// call save() and verify value
			var data:String = "hello";
			DataMap.save(TEST_ONE, data);
			assertTrue("The data was not saved in the targetOne property correctly.", data == mapItemOne.targetOne);
			
			DataMap.unregisterClient(mapItemOne);
			DataMap.save(TEST_ONE, "foo");
			assertTrue("The data should not have been updated.", data == mapItemOne.targetOne);
		}
		
		/**
		 * Used to verify that unregister does not throw an error before or
		 * after a data map is created. 
		 * 
		 */
		public function testUnregisterInvalidClass():void {
			
			// test before configured
			var ac:ArrayCollection = new ArrayCollection();
			DataMap.unregisterClient(ac);
			
			// configure
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = inst;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			//test after configured
			DataMap.unregisterClient(ac);
		}
		
		/**
		 * Verify that when useDataWrapper is set the passed
		 * data is configued as a data wrapper object. 
		 * 
		 */		
		public function testWrapper():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "data";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.useDataWrapper = true;
			target.type = TEST_ONE;	
			target.instances = inst;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
						
			// call save() and verify value
			var data:String = "hello";
			DataMap.save(TEST_ONE, data, {update: true});
			assertTrue("The wrapper type was not defined.", mapItemOne.wrapperType == TEST_ONE);
			assertTrue("The data was not set correctly in the wrapper.", mapItemOne.wrapperData == data);
			assertTrue("The wrapper parameters were not defined correctly.", mapItemOne.wrapperParams.hasOwnProperty("update"));
		}
		
		/**
		 * Verify that sub properties can be defined for complex business logic
		 * generation. 
		 * 
		 */
		public function testComplexObject():void {
			// create the instances
			var inst1:MapInstance = new MapInstance();
			inst1.classType = MapItemOne;
			inst1.property = "targetOne";
			inst1.complexProperty = "foo";
			
			var inst2:MapInstance = new MapInstance();
			inst2.classType = MapItemOne;
			inst2.property = "targetTwo";
			inst2.complexProperty = "bar";
			
			var inst3:MapInstance = new MapInstance();
			inst3.classType = MapItemTwo;
			inst3.property = "targetOne";
			inst3.complexProperty = "baz";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = [inst1, inst2, inst3];
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
			var mapItemTwo:MapItemTwo = new MapItemTwo();
						
			// call save() and verify value
			var data:Object = {foo: "hello", bar: "goodbye", baz: "jinks"};
			DataMap.save(TEST_ONE, data);
			assertTrue("The complex linkage did not bind foo to inst1.", mapItemOne.targetOne == "hello");
			assertTrue("The complex linkage did not bind foo to inst2.", mapItemOne.targetTwo == "goodbye");
			assertTrue("The complex linkage did not bind foo to inst3.", mapItemTwo.targetOne == "jinks");
		}
		
		/**
		 * Verify that we an incrementally update instances
		 * that rely on the complex data object. 
		 * 
		 */		
		public function testComplexObjectMissingItem():void {
			// create the instances
			var inst1:MapInstance = new MapInstance();
			inst1.classType = MapItemOne;
			inst1.property = "targetOne";
			inst1.complexProperty = "foo";
			
			var inst2:MapInstance = new MapInstance();
			inst2.classType = MapItemOne;
			inst2.property = "targetTwo";
			inst2.complexProperty = "bar";
			
			var inst3:MapInstance = new MapInstance();
			inst3.classType = MapItemTwo;
			inst3.property = "targetOne";
			inst3.complexProperty = "baz";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = [inst1, inst2, inst3];
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
			var mapItemTwo:MapItemTwo = new MapItemTwo();
						
			// call save() and verify value
			var data:Object = {foo: "hello", bar: "goodbye", baz: "jinks"};
			DataMap.save(TEST_ONE, data);
			assertTrue("The complex linkage did not bind foo to inst1.", mapItemOne.targetOne == "hello");
			assertTrue("The complex linkage did not bind bar to inst2.", mapItemOne.targetTwo == "goodbye");
			assertTrue("The complex linkage did not bind baz to inst3", mapItemTwo.targetOne == "jinks");
			
			// update a subset of the data
			data = {foo: "goodbye", bar: "hello"};
			DataMap.save(TEST_ONE, data);
			assertTrue("The complex linkage did not bind foo to inst1.", mapItemOne.targetOne == "goodbye");
			assertTrue("The complex linkage did not bind bar to inst2.", mapItemOne.targetTwo == "hello");
			assertTrue("The complex linkage did not update mapItemTwo.targetOne", mapItemTwo.targetOne == "jinks");
		}
		
		/**
		 * Verify that sub properties can be defined for complex business logic
		 * generation that also use a wrapper class.
		 * 
		 */
		public function testComplexObjectWrapper():void {
			// create the instances
			var inst1:MapInstance = new MapInstance();
			inst1.classType = MapItemOne;
			inst1.property = "data";
			inst1.complexProperty = "foo";
			
			var inst2:MapInstance = new MapInstance();
			inst2.classType = MapItemTwo;
			inst2.property = "data";
			inst2.complexProperty = "bar";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.useDataWrapper = true;
			target.type = TEST_ONE;	
			target.instances = [inst1, inst2];
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
			var mapItemTwo:MapItemTwo = new MapItemTwo();
						
			// call save() and verify value
			var data:Object = {foo: "hello", bar: "goodbye"};
			DataMap.save(TEST_ONE, data, {update: true});
			assertTrue("The wrapper type was not defined for mapItemOne.", mapItemOne.wrapperType == TEST_ONE);
			assertTrue("The data was not set correctly in the wrapper for mapItemOne.", mapItemOne.wrapperData == "hello");
			assertTrue("The wrapper parameters were not defined correctly for mapItemOne.", mapItemOne.wrapperParams.hasOwnProperty("update"));
			
			assertTrue("The wrapper type was not defined for mapItemTwo.", mapItemTwo.wrapperType == TEST_ONE);
			assertTrue("The data was not set correctly in the wrapper for mapItemTwo.", mapItemTwo.wrapperData == "goodbye");
			assertTrue("The wrapper parameters were not defined correctly for mapItemTwo.", mapItemTwo.wrapperParams.hasOwnProperty("update"));
		}
		
		/**
		 * Verify that calling a non-existing instance type does not 
		 * cause a system conflict. 
		 * 
		 */		
		public function testNonExistingInstance():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = inst;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			DataMap.save(TEST_THREE, "foo");
		}
		
		/**
		 * Verify that calling save to an undefined map does not throw an error. 
		 * 
		 */
		public function testNonDefinedMap():void {
			DataMap.save(TEST_THREE, "foo");
		}
		
		/**
		 * Verify that calling save with no targets defined does not throw an error. 
		 * 
		 */
		public function testNonDefinedInstance():void {
			var map:DataMap = new DataMap();
			DataMap.save(TEST_THREE, "foo");
		}
		
		/**
		 * Verify that an unmapped type in an instance throws
		 * a valid error when attempted to be called. 
		 * 
		 */		
		public function testUndefinedType():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the target (missing the type)
			var target:MapTarget = new MapTarget();
			target.instances = inst;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
						
			// call save() and verify value
			var data:String = "hello";
			
			var errorThown:Boolean = false;
			try {
				DataMap.save(TEST_ONE, data);
			} catch (e:Error) {
				errorThown = true;
			}
			
			assertTrue("The DataMap did not throw an error for an undefined type.", errorThown);
		}
		
		/**
		 * Verify that when an instance does not have a class defined
		 * that a proper error is thrown. 
		 * 
		 */		
		public function testUndefinedClass():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.property = "targetOne";
			
			// create the target (missing the type)
			var target:MapTarget = new MapTarget();
			target.instances = inst;
			target.type = TEST_ONE;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
						
			// call save() and verify value
			var data:String = "hello";
			
			var errorThown:Boolean = false;
			try {
				DataMap.save(TEST_ONE, data);
			} catch (e:Error) {
				errorThown = true;
			}
			
			assertTrue("The DataMap did not throw an error for an undefined type.", errorThown);
		}
		
		/**
		 * Verify that when an instance does not have a property defined
		 * that a proper error is thrown. 
		 * 
		 */		
		public function testUndefinedProperty():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne
			
			// create the target (missing the type)
			var target:MapTarget = new MapTarget();
			target.instances = inst;
			target.type = TEST_ONE;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
						
			// call save() and verify value
			var data:String = "hello";
			
			var errorThown:Boolean = false;
			try {
				DataMap.save(TEST_ONE, data);
			} catch (e:Error) {
				errorThown = true;
			}
			
			assertTrue("The DataMap did not throw an error for an undefined type.", errorThown);
		}
		
		/**
		 * Verifies that creating a data store and saving data to the 
		 * map before other instances are created, does store the data
		 * and apply it when an instance is added. 
		 * 
		 */	
		
		public function testDataStoreWithNoInstance():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the store
			var store:MapStore = new MapStore();
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = inst;
			target.store = store;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// call save() and verify value
			var data:String = "hello";
			DataMap.save(TEST_ONE, data);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
			
			// verify that the data was set on creation
			assertTrue("The data was not saved in the targetOne property correctly.", data == mapItemOne.targetOne);
		}
		
		/**
		 * Verifies that an instance can be provided as a target for the
		 * store to save data on. This verifies that the data is pulled from
		 * the instance not the internal store. 
		 * 
		 */				
		public function testDataStoreWithInstance():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "targetOne";
			
			// create the store
			var store:MapStore = new MapStore();
			
			// set data prior to the instance
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = inst;
			target.store = store;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// call save() and verify value
			var data:String = "goodbye";
			DataMap.save(TEST_ONE, data);
			
			// create an instance
			store.instance = {foo: null};
			store.property = "foo";
			
			// resave data
			// call save() and verify value
			data = "hello";
			DataMap.save(TEST_ONE, data);
			
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
			
			// verify that the data was set on creation
			assertTrue("The data was not saved in the targetOne property correctly.", data == mapItemOne.targetOne);
		}
		
		/**
		 * Verifies that when loading data from the store when data wrapping
		 * is enabled, that the data wrapper syntax is preserved. 
		 * 
		 */		
		public function testStoreWithDataWrapper():void {
			// create the instance
			var inst:MapInstance = new MapInstance();
			inst.classType = MapItemOne;
			inst.property = "data";
			
			// create the store
			var store:MapStore = new MapStore();
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.useDataWrapper = true;
			target.type = TEST_ONE;	
			target.instances = inst;
			target.store = store;
			
			// create the map
			var map:DataMap = createDataMap(target);
			
			// call save() and verify value
			var data:String = "hello";
			DataMap.save(TEST_ONE, data, {update: true});
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
			
			assertTrue("The wrapper type was not defined.", mapItemOne.wrapperType == TEST_ONE);
			assertTrue("The data was not set correctly in the wrapper.", mapItemOne.wrapperData == data);
			assertTrue("The wrapper parameters were not defined correctly.", mapItemOne.wrapperParams.hasOwnProperty("update"));
		}
		
		/**
		 * Verifies that the store can support complex objects
		 * syntax and pass the data properly to the object during
		 * registration. 
		 * 
		 */		
		public function testStoreWithComplexObject():void {
			// create the instances
			var inst1:MapInstance = new MapInstance();
			inst1.classType = MapItemOne;
			inst1.property = "targetOne";
			inst1.complexProperty = "foo";
			
			var inst2:MapInstance = new MapInstance();
			inst2.classType = MapItemOne;
			inst2.property = "targetTwo";
			inst2.complexProperty = "bar";
			
			var inst3:MapInstance = new MapInstance();
			inst3.classType = MapItemTwo;
			inst3.property = "targetOne";
			inst3.complexProperty = "baz";
			
			// create the target
			var target:MapTarget = new MapTarget();
			target.type = TEST_ONE;	
			target.instances = [inst1, inst2, inst3];
			target.store = new MapStore();
			
			// create the map
			var map:DataMap = createDataMap(target);
						
			// call save() and verify value
			var data:Object = {foo: "hello", bar: "goodbye", baz: "jinks"};
			DataMap.save(TEST_ONE, data);
			
			// create the instance
			var mapItemOne:MapItemOne = new MapItemOne();
			var mapItemTwo:MapItemTwo = new MapItemTwo();
			
			assertTrue("The complex linkage did not bind foo to inst1.", mapItemOne.targetOne == "hello");
			assertTrue("The complex linkage did not bind foo to inst2.", mapItemOne.targetTwo == "goodbye");
			assertTrue("The complex linkage did not bind foo to inst3.", mapItemTwo.targetOne == "jinks");
		}
		
		/**
		 * Verifies that trying to save data to the store using an instance
		 * but not having a property set throws an error. 
		 * 
		 */		
		public function testStoreWithMissingProperty():void {
			var store:MapStore = new MapStore();
			store.instance = {foo: "bar"};
			
			var errorThown:Boolean = false;
			try {
				store.saveData("foo", "bar");
			} catch (e:Error) {
				errorThown = true;
			}
			assertTrue("The DataStore did not throw an error for an undefined property.", errorThown);
		}
		
		/**
		 * Verifies that trying to save data to the store using an instance
		 * but not having a value property name throws an error. 
		 * 
		 */		
		public function testStoreWithInvalidProperty():void {
			var store:MapStore = new MapStore();
			store.instance = new MapItemOne();
			store.property = "foobar";
			
			var errorThown:Boolean = false;
			try {
				store.saveData("foo", "bar");
			} catch (e:Error) {
				errorThown = true;
			}
			assertTrue("The DataStore did not throw an error for an invalid property.", errorThown);
		}
		
		/**
		 * Creates the data map with the targets
		 *  
		 * @param targets The targets to apply to the map
		 * @return the generated DataMap instance
		 * 
		 */
		protected function createDataMap(targets:Object):DataMap {
			var map:DataMap = new DataMap();
			map.targets = targets;
			return map;
		}
		
	}
}