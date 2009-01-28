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
	import com.developmentarc.flexunit.TestUtils;
	import com.developmentarc.framework.datastructures.utils.Queue;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class QueueTests extends TestCase
	{		
		public function QueueTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Test adding a single item to the queue, call next() to retrieve 
		 * the item using LIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingNextLIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.LIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.next()));
		}
		
		/**
		 * Test adding a single item to the queue, call next() to retrieve 
		 * the item using FIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingNextFIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.FIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.next()));
		}
		
		/**
		 * Test adding a single item to the queue, call last() to retrieve 
		 * the item using FIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingLastLIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.LIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.last()));
		}
		
		/**
		 * Test adding a single item to the queue, call last() to retrieve 
		 * the item using LIFO mode, and then verify that the Queue is empty. 
		 * 
		 */
		public function testSingleItemUsingLastFIFO():void
		{
			// create queue and test item
			var queue:Queue = new Queue(Queue.FIFO);
			var item:Object = {key:"item"};
			
			// add the item to the queue, call next() verify item is returned
			queue.add(item);
			assertTrue("The proper item was not returned.", (item == queue.last()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling 
		 * next() pulls items from first in to last out.
		 * 
		 */
		public function testMultipleItemsUsingNextLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling 
		 * next() pulls last item first working to first out last.
		 * 
		 */
		public function testMultipleItemsUsingNextFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
		}
		
		/**
		 * Verifies that the same items can exist multiple times within
		 * the Queue and that the items are returned in the proper order
		 * when using next() and LIFO. 
		 * 
		 */
		public function testMultipleItemsUsingSameItemAndNextLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};

			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
		}
		
		/**
		 * Verifies that the same items can exist multiple times within
		 * the Queue and that the items are returned in the proper order
		 * when using next() and FIFO. 
		 * 
		 */
		public function testMultipleItemsUsingSameItemAndNextFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};

			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
		}
		
		/**
		 * Verifies that the same items can exist multiple times within
		 * the Queue and that the items are returned in the proper order
		 * when using last() and LIFO. 
		 * 
		 */
		public function testMultipleItemsUsingSameItemAndLastLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};

			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
		}
		
		/**
		 * Verifies that the same items can exist multiple times within
		 * the Queue and that the items are returned in the proper order
		 * when using last() and FIFO. 
		 * 
		 */
		public function testMultipleItemsUsingSameItemAndLastFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};

			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling last() 
		 * pulls the first item in the queue and then works forward.
		 * 
		 */
		public function testMultipleItemsUsingLastLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
			assertTrue("The item3 was not returned.", (item3 == queue.last()));
			assertTrue("The item4 was not returned.", (item4 == queue.last()));
		}
		
		/**
		 * Test that adding multiple items to the queue and then calling last() 
		 * pulls the last item from the list and works backwards.
		 * 
		 */
		public function testMultipleItemsUsingLastFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// retrieve and verify that the last one is the first item
			// pulled out of the queue calling next()
			assertTrue("The item4 was not returned.", (item4 == queue.last()));
			assertTrue("The item3 was not returned.", (item3 == queue.last()));
			assertTrue("The item2 was not returned.", (item2 == queue.last()));
			assertTrue("The item1 was not returned.", (item1 == queue.last()));
		}
		
		/**
		 * Test that calling next() and last() on an empty queue throws 
		 * no errors and returns null.
		 * 
		 */
		public function testNextAndLastOnEmptyQueue():void
		{
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			
			// verify the empty queue returns null
			assertNull("The result was not a null value", queue.next());
			assertNull("The result was not a null value", queue.last());
			
			// add an item, pull it and verify next() and last() are null
			queue.add(item1);
			assertTrue("The item4 was not returned.", (item1 == queue.next()));
			
			// verify the empty queue returns null
			assertNull("The result was not a null value", queue.next());
			assertNull("The result was not a null value", queue.last());
		}
		
		/**
		 *  Test that an item can be added to the start of the queue 
		 * when content in the queue already exists using FIFO
		 * 
		 */
		public function testAddItemAtStartOfQueueFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the start of the queue
			queue.addAt(item4, 0);
			
			// verify that item 4 was added to the start of the queue
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
		}
		
		/**
		 * Test that an item can be added to the start of the queue 
		 * when content in the queue already exists using LIFO
		 * 
		 */
		public function testAddItemAtStartOfQueueLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the start of the queue
			queue.addAt(item4, 0);
			
			// verify that item 4 was added to the start of the queue, but is returned last
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
		}
		
		/**
		 * Test that an item can be added to the end of the queue when 
		 * content has already been added by passing in the end of the 
		 * queue position while using FIFO.
		 * 
		 */
		public function testAddItemAtEndOfQueueFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the start of the queue
			queue.addAt(item4, 3);
			
			// verify that item 4 was added to the end of the queue
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
		}
		
		/**
		 * Test that an item can be added to the end of the queue when 
		 * content has already been added by passing in the end of the 
		 * queue position while using FIFO.
		 * 
		 */
		public function testAddItemAtEndOfQueueLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the end of the queue
			queue.addAt(item4, 3);
			
			// verify that item 4 was added to the end of the queue
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
		}
		
		/**
		 * Test that an item can be inserted into the middle of the queue when 
		 * content has already been added to the the queue. 
		 * 
		 */
		public function testAddItemAtMiddleOfQueueFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the middle of the queue
			queue.addAt(item4, 1);
			
			// verify that item 4 was added to the middle of the queue
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
		}
		
		/**
		 * Test that an item can be inserted into the middle of the queue when 
		 * content has already been added to the the queue. 
		 * 
		 */
		public function testAddItemAtMiddleOfQueueLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the middle of the queue
			queue.addAt(item4, 1);
			
			// verify that item 4 was added to the middle of the queue
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
		}
		
		/**
		 * Verify that passing a negative value to addAt() puts the item at the start 
		 * of the queue (position 0 which is independent of the queue type).
		 * 
		 */
		public function testAddItemAtInvalidPositionNegativeFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the a negative value of the queue
			queue.addAt(item4, -3);
			
			// verify that item 4 was added to the middle of the queue
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
		}
		
		/**
		 * Verify that passing a negative value to addAt() puts the item at the start 
		 * of the queue (position 0 which is independent of the queue type).
		 * 
		 */
		public function testAddItemAtInvalidPositionNegativeLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at a negative value of the queue
			queue.addAt(item4, -3);
			
			// verify that item 4 was added to the start of the queue
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
		}
		
		/**
		 * Verify that passing a negative value to addAt() puts the item at the start 
		 * of the queue (position 0 which is independent of the queue type).
		 * 
		 */
		public function testAddItemAtInvalidPositionPositiveFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the middle of the queue
			queue.addAt(item4, 12);
			
			// verify that item 4 was added to the end of the queue
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
		}
		
		/**
		 * Verify that passing a negative value to addAt() puts the item at the start 
		 * of the queue (position 0 which is independent of the queue type).
		 * 
		 */
		public function testAddItemAtInvalidPositionPositiveLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			
			// add the last item at the middle of the queue
			queue.addAt(item4, 12);
			
			// verify that item 4 was added to the end of the queue
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
		}
		
		/**
		 * Verifies that calling the default remove() removes the item
		 * when it exists only once in the queue.  The order of the queue
		 * should only be shifted and should return the values in the order
		 * specified by the Queue Type. 
		 * 
		 */
		public function testRemoveItemFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// remove item1
			queue.remove(item1);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that calling the default remove() removes the item
		 * when it exists only once in the queue.  The order of the queue
		 * should only be shifted and should return the values in the order
		 * specified by the Queue Type. 
		 * 
		 */
		public function testRemoveItemLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// remove item1
			queue.remove(item1);
			
			// verify that the items come out in the correct order
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that attempting to remove an item that is not within
		 * the Queue does not throw an error, nor does it cause
		 * the Queue to change its defined order. 
		 * 
		 */
		public function testRemoveInvalidItemFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// remove item1
			queue.remove(item1);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that attempting to remove an item that is not within
		 * the Queue does not throw an error, nor does it cause
		 * the Queue to change its defined order. 
		 * 
		 */
		public function testRemoveInvalidItemLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			var item3:Object = {key:"item3"};
			var item4:Object = {key:"item4"};
			
			// add the items in order to the queue
			queue.add(item2);
			queue.add(item3);
			queue.add(item4);
			
			// remove item1
			queue.remove(item1);
			
			// verify that the items come out in the correct order
			assertTrue("The item4 was not returned.", (item4 == queue.next()));
			assertTrue("The item3 was not returned.", (item3 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a number count to remove only removes
		 * the number of items requested, when the item exists more the
		 * one time in the Queue. 
		 * 
		 */
		public function testRemoveOneItemWhenMultipleExistFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1, 1);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a number count to remove only removes
		 * the number of items requested, when the item exists more the
		 * one time in the Queue. 
		 * 
		 */
		public function testRemoveOneItemWhenMultipleExistLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1, 1);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a number count to remove only removes
		 * the number of items requested, when the item exists more the
		 * one time in the Queue. 
		 * 
		 */
		public function testRemoveTwoItemsWhenMultipleExistFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1, 2);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a number count to remove only removes
		 * the number of items requested, when the item exists more the
		 * one time in the Queue. 
		 * 
		 */
		public function testRemoveTwoItemsWhenMultipleExistLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1, 2);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a number count to remove only removes
		 * the number of items requested, when the item exists more the
		 * one time in the Queue. 
		 * 
		 */
		public function testRemoveAllItemsWhenMultipleExistFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1);
			
			// verify that the items come out in the correct order
			assertTrue("The item4 was not returned.", (item2 == queue.next()));
			assertTrue("The item4 was not returned.", (item2 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a number count to remove only removes
		 * the number of items requested, when the item exists more the
		 * one time in the Queue. 
		 * 
		 */
		public function testRemoveAllItemsWhenMultipleExistLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a negative number to remove() does
		 * not change the order of the queue, nor should it remove any
		 * items.
		 * 
		 */
		public function testRemoveWithNegativeNumberLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1, -3);
			
			// verify that the items come out in the correct order
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that providing a negative number to remove() does
		 * not change the order of the queue, nor should it remove any
		 * items.
		 * 
		 */
		public function testRemoveWithNegativeNumberFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.remove(item1, -3);
			
			// verify that the items come out in the correct order
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that remove at correctly removes the first
		 * item of the queue when passed 0.
		 * 
		 */
		public function testRemoveAtStartUsingFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.removeAt(0);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that remove at correctly removes the first
		 * item of the queue when passed 0.
		 * 
		 */
		public function testRemoveAtStartUsingLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.removeAt(0);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt() correctly removes the last
		 * item of the queue when passed 4.
		 * 
		 */
		public function testRemoveAtLastUsingFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.removeAt(4);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt correctly removes the last
		 * item of the queue when passed 4.
		 * 
		 */
		public function testRemoveAtLastUsingLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.removeAt(4);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt() correctly removes the middle
		 * item of the queue when passed 2.
		 * 
		 */
		public function testRemoveAtMiddleUsingFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.removeAt(2);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt() correctly removes the middle
		 * item of the queue when passed 2.
		 * 
		 */
		public function testRemoveAtMiddleUsingLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove item1
			queue.removeAt(2);
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt() correctly handles being passed an
		 * invalid negative number.
		 * 
		 */
		public function testRemoveAtInvalidNegativeFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove none
			assertFalse("False should have been returned.", queue.removeAt(-10));
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt() correctly handles being passed an
		 * invalid negative number.
		 * 
		 */
		public function testRemoveAtInvalidNegativeLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove none
			assertFalse("False should have been returned.", queue.removeAt(-10));
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt() correctly handles being passed an
		 * invalid positive number.
		 * 
		 */
		public function testRemoveAtInvalidPositiveFIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.FIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove none
			assertFalse("False should have been returned.", queue.removeAt(int.MAX_VALUE));
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertTrue("The item2 was not returned.", (item2 == queue.next()));
			assertTrue("The item1 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verifies that removeAt() correctly handles being passed an
		 * invalid positive number.
		 * 
		 */
		public function testRemoveAtInvalidPositiveLIFO():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove none
			assertFalse("False should have been returned.", queue.removeAt(int.MAX_VALUE));
			
			// verify that the items come out in the correct order
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertTrue("The item1 was not returned.", (item2 == queue.next()));
			assertTrue("The item2 was not returned.", (item1 == queue.next()));
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verify that removing all items does remove all the items from
		 * the Queue. 
		 * 
		 */
		public function testRemoveAll():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			queue.add(item2);
			queue.add(item1);
			
			// remove none
			queue.removeAll();
			
			// verify that the items come out in the correct order
			assertNull("Null should have been returned.", queue.next());
		}
		
		/**
		 * Verify that has items properly returns false when empty
		 * and true when items exists.
		 * 
		 */
		public function testHasItems():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			
			// verify that hasItems is false
			assertFalse("The Queue should return false.", queue.hasItems);
			
			// add the items in order to the queue
			queue.add(item1);
			
			// verify that hasItems is false
			assertTrue("The Queue should return true.", queue.hasItems);
			
			// remove none
			queue.removeAll();
			
			// verify that hasItems is false
			assertFalse("The Queue should return false.", queue.hasItems);
		}
		
		/**
		 * Verify that has the proper length is returned.
		 * 
		 */
		public function testLength():void
		{
			// create queue and test items
			var queue:Queue = new Queue(Queue.LIFO);
			var item1:Object = {key:"item1"};
			var item2:Object = {key:"item2"};
			
			// verify that the length is valid
			assertTrue("The Queue should return false.", queue.length == 0);
			
			// add the items in order to the queue
			queue.add(item1);
			
			// verify that the length is valid
			assertTrue("The Queue should return false.", queue.length == 1);
			
			// add the items in order to the queue
			queue.add(item1);
			queue.add(item1);
			queue.add(item1);
			queue.add(item1);
			
			// verify that the length is valid
			assertTrue("The Queue should return false.", queue.length == 5);
			
			// remove none
			queue.removeAll();
			
			// verify that the length is valid
			assertTrue("The Queue should return false.", queue.length == 0);
		}
	}
}