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
	import com.developmentarc.framework.utils.InstanceFactory;
	import com.developmentarc.libtests.elements.instances.InstanceClass;
	import com.developmentarc.libtests.elements.instances.InstanceClassTwo;
	
	import flexunit.framework.TestCase;

	public class InstanceFactoryTests extends TestCase
	{
		public function InstanceFactoryTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Verifies that requested instance is the same every time.
		 * 
		 */
		public function testBasicInstanceFactory():void
		{
			// create factory
			var factory:InstanceFactory = new InstanceFactory();
			
			// create an instance
			var instanceOne:InstanceClass = InstanceClass(factory.getInstance(InstanceClass));
			var instanceTwo:InstanceClassTwo = InstanceClassTwo(factory.getInstance(InstanceClassTwo));
			
			// verify the same instance is handed back
			assertTrue("the instances did not match", instanceOne === InstanceClass(factory.getInstance(InstanceClass)));
			assertTrue("the instances did not match", instanceTwo === InstanceClassTwo(factory.getInstance(InstanceClassTwo)));
		}
		
		/**
		 * Used to verify that Instances are unique to each InstanceFactory. 
		 * 
		 */
		public function testTwoInstanceFactories():void
		{
			// create factory
			var factory:InstanceFactory = new InstanceFactory();
			var factoryTwo:InstanceFactory = new InstanceFactory();
			
			// create an instance
			var instanceOne:InstanceClass = InstanceClass(factory.getInstance(InstanceClass));
			var instanceTwo:InstanceClass = InstanceClass(factoryTwo.getInstance(InstanceClass));
			
			// verify the same instance is handed back
			assertTrue("the instances matched, this is incorrect.", instanceOne !== instanceTwo);
		}
		
		/**
		 * Verifies that clearInstance() removes the current instance within
		 * the factory. 
		 * 
		 */
		public function testClearInstance():void
		{
			// create factory
			var factory:InstanceFactory = new InstanceFactory();
			
			// create an instance
			var instanceOne:InstanceClass = InstanceClass(factory.getInstance(InstanceClass));
			var instanceTwo:InstanceClass = InstanceClass(factory.getInstance(InstanceClass));
			
			// verify the same instance is handed back
			assertTrue("the instances did not match", instanceOne === instanceTwo);
			
			// clear the instance
			factory.clearInstance(InstanceClass);
			
			// get a new instance, verify they do not match
			instanceTwo = InstanceClass(factory.getInstance(InstanceClass));
			assertTrue("the instances matched.", instanceOne !== instanceTwo);
		}
		
		/**
		 * Verifies that clearAllInstances() removes any existing instances of items
		 * and the next time getInstance() is called a new instance is returned.
		 * 
		 */
		public function testClearAllInstances():void
		{
			// create factory
			var factory:InstanceFactory = new InstanceFactory();
			
			// create an instance
			var instanceOne:InstanceClass = InstanceClass(factory.getInstance(InstanceClass));
			var instanceTwo:InstanceClassTwo = InstanceClassTwo(factory.getInstance(InstanceClassTwo));
			
			// verify the same instance is handed back
			assertTrue("the instances did not match", instanceOne === InstanceClass(factory.getInstance(InstanceClass)));
			assertTrue("the instances did not match", instanceTwo === InstanceClassTwo(factory.getInstance(InstanceClassTwo)));
			
			// clear all the instances and make sure they do not match
			factory.clearAllInstances();
			assertTrue("the instances did not clear.", instanceOne !== InstanceClass(factory.getInstance(InstanceClass)));
			assertTrue("the instances did not clear.", instanceTwo !== InstanceClassTwo(factory.getInstance(InstanceClassTwo)));

		}
		
	}
}