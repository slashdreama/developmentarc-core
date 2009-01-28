/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2009 DevelopmentArc LLC
 * version 1.0
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
package com.developmentarc.libtests
{
	import com.developmentarc.flexunit.TestUtils;
	import com.developmentarc.libtests.tests.AdjustableDateTests;
	import com.developmentarc.libtests.tests.BrowserLocationUtilTest;
	import com.developmentarc.libtests.tests.EventBrokerTests;
	import com.developmentarc.libtests.tests.HashTableTests;
	import com.developmentarc.libtests.tests.InstanceFactoryTests;
	import com.developmentarc.libtests.tests.PriorityQueueTests;
	import com.developmentarc.libtests.tests.QueueTests;
	import com.developmentarc.libtests.tests.SelectionControllerTests;
	import com.developmentarc.libtests.tests.SelectionGroupTests;
	import com.developmentarc.libtests.tests.SingletonFactoryTest;
	import com.developmentarc.libtests.tests.TaskControllerTests;
	import com.developmentarc.libtests.tests.TaskGroupTests;
	
	import flexunit.flexui.TestRunnerBase;
	import flexunit.framework.TestSuite;
	
	import mx.core.Application;
	import mx.events.FlexEvent;

	public class LibraryTestingApplication extends Application
	{
		[Bindable]
		public var test_runner:TestRunnerBase;
		
		// CLASS LINKERS -- ENABLES EASE OF COMMENTING OUT/IN TESTS //
		private var eventbroker:EventBrokerTests;
		private var selectioncontroller:SelectionControllerTests;
		private var selectionGroup:SelectionGroupTests
		private var hashtable:HashTableTests;
		private var queue:QueueTests;
		private var instancefactory:InstanceFactoryTests;
		private var adjustabledata:AdjustableDateTests;
		private var singletonfactory:SingletonFactoryTest;
		private var taskcontroller:TaskControllerTests;
		private var priorityqueue:PriorityQueueTests;
		private var taskgroup:TaskGroupTests;
		private var browserLocationUtil:BrowserLocationUtilTest;
		
		public function LibraryTestingApplication()
		{
			super();
			
			// register self events
			this.addEventListener(FlexEvent.CREATION_COMPLETE, handleCreationComplete);
		}
		
		protected function handleCreationComplete(event:FlexEvent):void
		{
			test_runner.test = createSuite();
			test_runner.startTest();
		}
		
		protected function createSuite():TestSuite
		{
			var suite:TestSuite = new TestSuite();
			
			// current test suites
			
			//*
			suite.addTest( TestUtils.generateFullSuite(EventBrokerTests) );
			suite.addTest( TestUtils.generateFullSuite(SelectionControllerTests) );
			suite.addTest( TestUtils.generateFullSuite(SelectionGroupTests) );
			suite.addTest( TestUtils.generateFullSuite(HashTableTests) );
			suite.addTest( TestUtils.generateFullSuite(QueueTests) );
			suite.addTest( TestUtils.generateFullSuite(InstanceFactoryTests) );
			suite.addTest( TestUtils.generateFullSuite(AdjustableDateTests) );
			suite.addTest( TestUtils.generateFullSuite(SingletonFactoryTest) );
			suite.addTest( TestUtils.generateFullSuite(SelectionControllerTests) );
			suite.addTest( TestUtils.generateFullSuite(TaskGroupTests) );
			suite.addTest( TestUtils.generateFullSuite(PriorityQueueTests) );
			suite.addTest( TestUtils.generateFullSuite(TaskControllerTests) );
			suite.addTest( TestUtils.generateFullSuite(BrowserLocationUtilTest) );
			//*/
			
			return suite;
		}
		
	}
}