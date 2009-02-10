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
package com.developmentarc.libtests.elements
{
	import com.developmentarc.framework.utils.EventBroker;
	import com.developmentarc.libtests.tests.EventBrokerTests;
	
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	/**
	 * This class is a helper class for testing the EventBroker. This class provides
	 * an API to enable subscribing the object to the Events and verifying both
	 * Event type and the number of times called.
	 *  
	 * @author James Polanco
	 * 
	 */
	public class EventSubscriber
	{
		/* stores the number of calls made to the methods */
		private var __callCount:int = 0;
		
		/**
		 * Constructor 
		 * 
		 */
		public function EventSubscriber()
		{
		}
		
		/**
		 * The number of times the subscribed methods have been called. 
		 * @return 
		 * 
		 */
		public function get callCount():int
		{
			return __callCount;
		}
		
		/**
		 * This method subscribes the object to the BASIC_EVENT_TYPE and
		 * is bound to callMethodOne().
		 * 
		 */
		public function subscribeMethodOne():void
		{
			EventBroker.subscribe(EventBrokerTests.BASIC_EVENT_TYPE, callMethodOne);
		}
		
		/**
		 * This method subscribes the object to the BASIC_EVENT_TYPE and
		 * is bound to callMethodTwo().
		 * 
		 */
		public function subscribeMethodTwo():void
		{
			EventBroker.subscribe(EventBrokerTests.BASIC_EVENT_TYPE, callMethodTwo);
		}
		
		/**
		 * This method subscribes the object to the SECOND_EVENT_TYPE and
		 * is bound to callMethodThree().
		 * 
		 */
		public function subscribeMethodThree():void
		{
			EventBroker.subscribe(EventBrokerTests.SECOND_EVENT_TYPE, callMethodThree);
		}
		
		/**
		 * Method closure called by EventBroker.
		 * @param event Asserts against BASIC_EVENT_TYPE
		 * 
		 */
		public function callMethodOne(event:Event):void
		{
			Assert.assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE)
			__callCount++;
		}
		
		/**
		 * Method closure called by EventBroker.
		 * @param event Asserts against BASIC_EVENT_TYPE
		 * 
		 */
		public function callMethodTwo(event:Event):void
		{
			Assert.assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE)
			__callCount++;
		}
		
		/**
		 * Method closure called by EventBroker.
		 * @param event Asserts against SECOND_EVENT_TYPE
		 * 
		 */
		public function callMethodThree(event:Event):void
		{
			Assert.assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.SECOND_EVENT_TYPE)
			__callCount++;
		}

	}
}