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
	import com.developmentarc.framework.utils.EventBroker;
	import com.developmentarc.libtests.elements.EventSubscriber;
	
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * The EventBrokerTests is a Suite of tests designed to validate the functionality of the EventBroker.
	 * This battery of tests should be run before any new checkin is submitted. 
	 * 
	 * @author James Polanco
	 * 
	 */
	public class EventBrokerTests extends TestCase
	{
		static public const BASIC_EVENT_TYPE:String = "BASIC_EVENT_TYPE"
		static public const SECOND_EVENT_TYPE:String = "SECOND_EVENT_TYPE"
		
		/* PRIVATE PROPERTIES */
		private var methodCount:int = 0;
		
		/**
		 * Constructor.
		 *  
		 * @param methodName Name of the method to run for the test.
		 * 
		 */
		public function EventBrokerTests(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function tearDown():void
		{
			methodCount = 0;
			EventBroker.clearAllSubscriptions();
		}
		
		/**
		 * Verify that the basic ability to subscribe, broadcast and call is functioning
		 * for the the EventBroker. 
		 * 
		 */
		public function testSubscribeBroadcast():void
		{
			// register one method and broadcast
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify the method count is only one
			assertTrue("Method count should be 1.", methodCount == 1);
		}
		
		/**
		 * Verify that the same object may subscribe multiple methods to the same
		 * Event type. 
		 * 
		 */
		public function testMultipleMethodsOnSingleInstance():void
		{
			// register two methods from the same object
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodTwo);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify the call count was two
			assertTrue("Method count should be 2.", methodCount == 2);
		}
		
		/**
		 * verifies that different objects can subscribe to the same event type. 
		 * 
		 */
		public function testMultipleObjectsWithSingleMethods():void
		{
			// create three objects
			var subscriber1:EventSubscriber = new EventSubscriber();
			var subscriber2:EventSubscriber = new EventSubscriber();
			var subscriber3:EventSubscriber = new EventSubscriber();
			
			// subscribe them
			subscriber1.subscribeMethodOne();
			subscriber2.subscribeMethodOne();
			subscriber3.subscribeMethodOne();
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify their calls
			assertTrue("subscriber1: Method count should be 1.", subscriber1.callCount == 1);
			assertTrue("subscriber2: Method count should be 1.", subscriber2.callCount == 1);
			assertTrue("subscriber3: Method count should be 1.", subscriber3.callCount == 1);
		}
		
		/**
		 * verifies that multiple objects can subscribe multiple methods to the same event type. 
		 * 
		 */
		public function testMultipleObjectsWithMultuipleMethods():void
		{
			// create three objects
			var subscriber1:EventSubscriber = new EventSubscriber();
			var subscriber2:EventSubscriber = new EventSubscriber();
			var subscriber3:EventSubscriber = new EventSubscriber();
			
			// subscribe them
			subscriber1.subscribeMethodOne();
			subscriber2.subscribeMethodOne();
			subscriber3.subscribeMethodOne();
			subscriber1.subscribeMethodTwo();
			subscriber2.subscribeMethodTwo();
			subscriber3.subscribeMethodTwo();
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verfiy their calls
			assertTrue("subscriber1: Method count should be 2.", subscriber1.callCount == 2);
			assertTrue("subscriber2: Method count should be 2.", subscriber2.callCount == 2);
			assertTrue("subscriber3: Method count should be 2.", subscriber3.callCount == 2);
		}
		
		/**
		 * verifies that the same object can register different methods to different event types. 
		 * 
		 */
		public function testSameObjectDifferentEvents():void
		{
			// Subscribe to different events with different methods
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			EventBroker.subscribe(SECOND_EVENT_TYPE, validMethodThree);
			
			// broadcast
			EventBroker.broadcast(new Event(SECOND_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 1.", methodCount == 1);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 2.", methodCount == 2);
		}
		
		/**
		 * verifies that different events can be bound to the same method closure. 
		 * 
		 */
		public function testSameObjectSameMethodDifferentEvents():void
		{
			// Subscribe to different events with different methods
			EventBroker.subscribe(BASIC_EVENT_TYPE, handleEvent);
			EventBroker.subscribe(SECOND_EVENT_TYPE, handleEvent);
			
			// broadcast
			EventBroker.broadcast(new Event(SECOND_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 1.", methodCount == 1);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 2.", methodCount == 2);
		}
		
		/**
		 * Verifies that multiple objects can subscribe to different event types 
		 * 
		 */
		public function testMultipleObjectToMultipleEvent():void
		{
			// create three objects
			var subscriber1:EventSubscriber = new EventSubscriber();
			var subscriber2:EventSubscriber = new EventSubscriber();
			var subscriber3:EventSubscriber = new EventSubscriber();
			
			// subscribe them
			subscriber1.subscribeMethodOne();
			subscriber2.subscribeMethodOne();
			subscriber3.subscribeMethodOne();
			subscriber1.subscribeMethodThree();
			subscriber2.subscribeMethodThree();
			subscriber3.subscribeMethodThree();
			
			// broadcast
			EventBroker.broadcast(new Event(SECOND_EVENT_TYPE));
			
			// verfiy their calls
			assertTrue("subscriber1: Method count should be 1.", subscriber1.callCount == 1);
			assertTrue("subscriber2: Method count should be 1.", subscriber2.callCount == 1);
			assertTrue("subscriber3: Method count should be 1.", subscriber3.callCount == 1);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verfiy their calls
			assertTrue("subscriber1: Method count should be 2.", subscriber1.callCount == 2);
			assertTrue("subscriber2: Method count should be 2.", subscriber2.callCount == 2);
			assertTrue("subscriber3: Method count should be 2.", subscriber3.callCount == 2);
		}
		
		/**
		 * verifies that attempting to re-subscribe the same method/event combo does 
		 * not throw an error nor is it broadcasted multiple times.
		 * 
		 */
		public function testResubscribeMethod():void
		{
			// Subscribe to the same event/closure pair twice
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 1.", methodCount == 1);
		}
		
		/**
		 * verifies that broadcasting an event that is not subscribed to does not throw any errors. 
		 * 
		 */
		public function testBroadcastToNoListener():void
		{
			// broadcast
			EventBroker.broadcast(new Event(SECOND_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 0.", methodCount == 0);
		}
		
		/**
		 * verify that unsubscribing does remove the listener. 
		 * 
		 */
		public function testBasicUnsubscribe():void
		{
			// Subscribe different combiniation
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodTwo);
			EventBroker.subscribe(SECOND_EVENT_TYPE, validMethodOne);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 2.", methodCount == 2);
			
			// unsubscribe			
			EventBroker.unsubscribe(BASIC_EVENT_TYPE, validMethodOne);
			EventBroker.unsubscribe(BASIC_EVENT_TYPE, validMethodTwo);
			EventBroker.unsubscribe(SECOND_EVENT_TYPE, validMethodOne);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			EventBroker.broadcast(new Event(SECOND_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 2.", methodCount == 2);
		}
		
		/**
		 * verify that attempting to unsubscribe a listener does not cause an error. 
		 * 
		 */		
		public function testUnsubscribeUnregisteredListener():void
		{
			// Subscribe to the same event/closure pair twice
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			
			// unsubscribe different closure			
			EventBroker.unsubscribe(BASIC_EVENT_TYPE, validMethodTwo);
			
			// unsubscribe different type			
			EventBroker.unsubscribe(SECOND_EVENT_TYPE, validMethodOne);
			
			// unsubscribe diffent object
			var subscriber1:EventSubscriber = new EventSubscriber();
			EventBroker.unsubscribe(SECOND_EVENT_TYPE, subscriber1.callMethodOne);
			
			// broadcast
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			// verify calls
			assertTrue("Method count should be 1.", methodCount == 1);
			assertTrue("Method count should be 0.", subscriber1.callCount == 0);
		}
		
		/**
		 * verify that if the unsubscribe call occurs during broadcasting that broadcasting 
		 * completes before the item is unsubscribed.
		 * 
		 */		
		public function verifyUnsubscribeHappensAfterBroadcast():void
		{
			// subscribe
			EventBroker.subscribe(BASIC_EVENT_TYPE, removeSubscription);
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			
			// broadcast and verify that the count is correct
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			assertTrue("Method count should be 1.", methodCount == 1);
			
			// the subscribed first method should have removed the call to the second method
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			assertTrue("Method count should be 1.", methodCount == 1);
		}
		
		/**
		 * verify that subscription completes after the EventBroker's broadcast phase is complete. 
		 * 
		 */
		public function verifySubscribeHappensAfterBroadcast():void
		{
			// Subscribe
			EventBroker.subscribe(BASIC_EVENT_TYPE, addSubscription);
			
			// broadcast and verify that the count is correct
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			assertTrue("Method count should be 0.", methodCount == 0);
			
			// broadcast again and verify that the new method subscription was called
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			assertTrue("Method count should be 1.", methodCount == 1);
		}
		
		/**
		 * verify the clearing all does remove any existing subscriptions 
		 * 
		 */
		public function testClearAllSubscriptions():void
		{
			// Subscribe
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodTwo);
			
			// create three objects
			var subscriber1:EventSubscriber = new EventSubscriber();
			var subscriber2:EventSubscriber = new EventSubscriber();
			var subscriber3:EventSubscriber = new EventSubscriber();
			
			// subscribe them
			subscriber1.subscribeMethodOne();
			subscriber2.subscribeMethodOne();
			subscriber3.subscribeMethodOne();
			subscriber1.subscribeMethodTwo();
			subscriber2.subscribeMethodTwo();
			subscriber3.subscribeMethodTwo();
			
			EventBroker.clearAllSubscriptions();
			
			// broadcast and verify that the count is correct
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
			
			assertTrue("Method count should be 0.", methodCount == 0);
			assertTrue("subscriber1: Method count should be 0.", subscriber1.callCount == 0);
			assertTrue("subscriber2: Method count should be 0.", subscriber2.callCount == 0);
			assertTrue("subscriber3: Method count should be 0.", subscriber3.callCount == 0);
		}
		
		/* PRIVATE TEST METHODS */
		
		/* simple method to veriy that the event was broadcasted */
		private function validMethodOne(event:Event):void
		{
			assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE)
			methodCount++;
		}
		
		/* simple method to veriy that the event was broadcasted */
		private function validMethodTwo(event:Event):void
		{
			assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE)
			methodCount++;
		}
		
		/* simple method to veriy that the event was broadcasted */
		private function validMethodThree(event:Event):void
		{
			assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.SECOND_EVENT_TYPE)
			methodCount++;
		}
		
		/* this method unsubscribes another method from the EventBroker, this subscribtion changed should
		 * occur AFTER completion of all the broadcasted messages.
		 */
		private function removeSubscription(event:Event):void
		{
			assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE);
			EventBroker.unsubscribe(BASIC_EVENT_TYPE, validMethodOne);
		}
		
		/* This method subscribes another method to the same event type, this method should not receive the
		 * event until the next broadcast.
		 */ 
		private function addSubscription(event:Event):void
		{
			assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE);
			EventBroker.subscribe(BASIC_EVENT_TYPE, validMethodOne);
		}
		
		/* flexible method for event type checking */
		private function handleEvent(event:Event):void
		{
			switch(event.type)
			{
				case SECOND_EVENT_TYPE:
				case BASIC_EVENT_TYPE:
					methodCount++;
				break;
				
				default:
					assertTrue("Invalid event was passed to handleEvent().", false);
			}
		}
		
	}
}