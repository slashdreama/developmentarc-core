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
	import com.developmentarc.framework.utils.SingletonFactory;
	import com.developmentarc.libtests.elements.instances.InstanceClass;
	import com.developmentarc.libtests.elements.instances.InstanceClassTwo;
	
	import flexunit.framework.TestCase;

	public class SingletonFactoryTest extends TestCase
	{
		public var instanceOne:InstanceClass;
		public var instanceTwo:InstanceClassTwo;
		
		public function SingletonFactoryTest(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Verifies that the singleton factory returns the same instance on
		 * multiple requests. 
		 * 
		 */
		public function testSingletonFactory():void
		{		
			// create an instance
			instanceOne = InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass));
			instanceTwo = InstanceClassTwo(SingletonFactory.getSingletonInstance(InstanceClassTwo));
			
			// verify the same instance is handed back
			assertTrue("the instances did not match", instanceOne === InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass)));
			assertTrue("the instances did not match", instanceTwo === InstanceClassTwo(SingletonFactory.getSingletonInstance(InstanceClassTwo)));
			
			singletonAcrossMethods();
		}
		
		/**
		 * used to verify that calling across methods returns the same instance (singleton state). 
		 * 
		 */
		public function singletonAcrossMethods():void
		{
			// verify the same instance is handed back
			assertTrue("the instances did not match", instanceOne === InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass)));
			assertTrue("the instances did not match", instanceTwo === InstanceClassTwo(SingletonFactory.getSingletonInstance(InstanceClassTwo)));
		}
		
		/**
		 * Verifies that clearInstance() removes the current instance within
		 * the factory. 
		 * 
		 */
		public function testClearInstance():void
		{		
			// create an instance
			var instanceOneNew:InstanceClass = InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass));
			var instanceTwoNew:InstanceClass = InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass));
			
			// verify the same instance is handed back
			assertTrue("the instances did not match", instanceOneNew === instanceTwoNew);
			
			// clear the instance
			SingletonFactory.clearSingletonInstance(InstanceClass);
			
			// get a new instance, verify they do not match
			instanceTwoNew = InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass));
			assertTrue("the instances matched.", instanceOneNew !== instanceTwoNew);
		}
		
		/**
		 * Verifies that clearAllInstances() removes any existing instances of items
		 * and the next time getInstance() is called a new instance is returned.
		 * 
		 */
		public function testClearAllInstances():void
		{
			// create an instance
			var instanceOneNew:InstanceClass = InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass));
			var instanceTwoNew:InstanceClassTwo = InstanceClassTwo(SingletonFactory.getSingletonInstance(InstanceClassTwo));
			
			// verify the same instance is handed back
			assertTrue("the instances did not match", instanceOneNew === InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass)));
			assertTrue("the instances did not match", instanceTwoNew === InstanceClassTwo(SingletonFactory.getSingletonInstance(InstanceClassTwo)));
			
			// clear all the instances and make sure they do not match
			SingletonFactory.clearAllSingletonInstances();
			assertTrue("the instances did not clear.", instanceOneNew !== InstanceClass(SingletonFactory.getSingletonInstance(InstanceClass)));
			assertTrue("the instances did not clear.", instanceTwoNew !== InstanceClassTwo(SingletonFactory.getSingletonInstance(InstanceClassTwo)));

		}
	}
}