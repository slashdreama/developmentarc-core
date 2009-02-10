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
	import com.developmentarc.framework.datastructures.utils.PriorityQueue;
	
	import flexunit.framework.TestCase;

	public class PriorityQueueTests extends TestCase
	{
		public function PriorityQueueTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Verify that a singe item can be added to the queue and 
		 * then returned with next() 
		 * 
		 */		
		public function testBasicAddToQueue():void
		{
			var queue:PriorityQueue = new PriorityQueue();
			var item:Object = new Object();
			queue.addItem(item);
			
			// verify the right item was returned
			assertTrue("Queue did not return expected item for testBasicAddToQueue().", item === queue.next());
		}
		
		/**
		 * Verify that adding multiple items of the same priority 
		 * to the queue are returned in the order they where added 
		 * by calling next(). 
		 * 
		 */		
		public function testAddingMultipleItemsOfSamePriority():void
		{
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3); 
			
			// verify the right item was returned
			assertTrue("Queue did not return expected item1 for testAddingMultipleItemsOfSamePriority().", item1 === queue.next());
			assertTrue("Queue did not return expected item2 for testAddingMultipleItemsOfSamePriority().", item2 === queue.next());
			assertTrue("Queue did not return expected item3 for testAddingMultipleItemsOfSamePriority().", item3 === queue.next());
		}
		
		/**
		 * Verify that adding items with different priorities are 
		 * sorted and returned correctly 
		 * 
		 */		
		public function testAddingDifferentPriority():void
		{
			// create the queue and 4 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			var item4:Object = new Object();
			
			// add the items in order with different priorites
			queue.addItem(item1);
			queue.addItem(item2, 3); 
			queue.addItem(item3, 0); 
			queue.addItem(item4)
			
			// verify the right item was returned
			assertTrue("Queue did not return expected item1 for testAddingDifferentPriority().", item3 === queue.next());
			assertTrue("Queue did not return expected item2 for testAddingDifferentPriority().", item2 === queue.next());
			assertTrue("Queue did not return expected item3 for testAddingDifferentPriority().", item1 === queue.next());
			assertTrue("Queue did not return expected item4 for testAddingDifferentPriority().", item4 === queue.next());
		}
		
		/**
		 * Verify that removing an item with default setting removes 
		 * all instances from the queue
		 * 
		 */
		public function testRemoveItemDefault():void
		{
			// create the queue and 2 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			
			// add the multiple instance of the same items, in different order
			queue.addItem(item1);
			queue.addItem(item2);
			queue.addItem(item1);
			queue.addItem(item1);
			queue.addItem(item2);
			
			// remove all item1 instance
			queue.removeItem(item1);
			
			// verify that the length is now 2, and calling next returns just item2
			assertTrue("Queue length is incorrect for testRemoveItemDefault().", queue.length == 2);
			assertTrue("Queue did not return expected item2 for testRemoveItemDefault().", item2 === queue.next());
			assertTrue("Queue did not return expected item2 for testRemoveItemDefault().", item2 === queue.next());
			assertFalse("Queue should not have any items left.", queue.hasItems);
		}
		
		/**
		 * Verify that only the requested number of items 
		 * are removed when a value is provided 
		 * 
		 */		
		public function testRemoveItemWithValue():void
		{
			// create the queue and 2 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			
			// add the multiple instance of the same items, in different order
			queue.addItem(item1);
			queue.addItem(item2);
			queue.addItem(item1);
			queue.addItem(item1);
			queue.addItem(item2);
			
			// remove all item1 instance
			queue.removeItem(item1, 2);
			
			// verify that the length is now 3, and calling next returns just item2
			assertTrue("Queue length is incorrect for testRemoveItemWithValue().", queue.length == 3);
			assertTrue("Queue did not return expected item2 for testRemoveItemWithValue().", item2 === queue.next());
			assertTrue("Queue did not return expected item1 for testRemoveItemWithValue().", item1 === queue.next());
			assertTrue("Queue did not return expected item2 for testRemoveItemWithValue().", item2 === queue.next());
			assertFalse("Queue should not have any items left.", queue.hasItems);
		}
		
		/**
		 * Verify that only the requested number of items 
		 * are removed when a value is provided and a priority 
		 * 
		 */		
		public function testRemoveItemWithValueAndPriority():void
		{
			// create the queue and 2 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			
			// add the multiple instance of the same items, in different order, with different priority
			queue.addItem(item1, 0);
			queue.addItem(item2, 1);
			queue.addItem(item1, 1);
			queue.addItem(item2, 2);
			queue.addItem(item1, 2);
			
			// remove item 1 with priority 0 only
			queue.removeItem(item1, 2, 0);
			
			// verify that the length is now 4, and calling next returns the correct order
			assertTrue("Queue length is incorrect for testRemoveItemWithValueAndPriority().", queue.length == 4);
			assertTrue("Queue did not return expected item2 for testRemoveItemWithValue().", item2 === queue.next());
			assertTrue("Queue did not return expected item1 for testRemoveItemWithValue().", item1 === queue.next());
			assertTrue("Queue did not return expected item2 for testRemoveItemWithValue().", item2 === queue.next());
			assertTrue("Queue did not return expected item1 for testRemoveItemWithValue().", item1 === queue.next());
			assertFalse("Queue should not have any items left.", queue.hasItems);
		}
		
		/**
		 * Verify that only the requested number of items 
		 * are removed when a value is provided and a priority 
		 * 
		 */		
		public function testRemoveItemWithMaxValueAndPriority():void
		{
			// create the queue and 2 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			
			// add the multiple instance of the same items, in different order, with different priority
			queue.addItem(item1, 0);
			queue.addItem(item2, 1);
			queue.addItem(item1, 1);
			queue.addItem(item2, 2);
			queue.addItem(item1, 0);
			
			// remove item 1 with priority 0 only
			queue.removeItem(item1, int.MAX_VALUE, 0);
			
			// verify that the length is now 3, and calling next returns the correct order
			assertTrue("Queue length is incorrect for testRemoveItemWithValueAndPriority().", queue.length == 3);
			assertTrue("Queue did not return expected item2 for testRemoveItemWithValue().", item2 === queue.next());
			assertTrue("Queue did not return expected item1 for testRemoveItemWithValue().", item1 === queue.next());
			assertTrue("Queue did not return expected item2 for testRemoveItemWithValue().", item2 === queue.next());
			assertFalse("Queue should not have any items left.", queue.hasItems);
		}
		
		/**
		 * Verify that all items are removed. 
		 * 
		 */		
		public function testRemoveAll():void
		{
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3); 
			
			// remove all and verify that the length, has items and null is retruned on next
			queue.removeAllItems();
			assertTrue("Queue length is incorrect for testRemoveAll().", queue.length == 0);
			assertFalse("Queue should not have any items left.", queue.hasItems);
			assertNull("Next should return null", queue.next())
		}
		
		/**
		 * Verify that null is returned and no error is thrown 
		 * 
		 */
		public function testNextWithNoItems():void
		{
			var queue:PriorityQueue = new PriorityQueue();
			assertNull("Next should return null", queue.next());
		}
		
		/**
		 * Verify that length is returned properly 
		 * 
		 */		
		public function testLength():void
		{
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3);
			
			assertTrue("Queue length is incorrect for testLength().", queue.length == 3);
			queue.next();
			assertTrue("Queue length is incorrect for testLength().", queue.length == 2);
			queue.next();
			assertTrue("Queue length is incorrect for testLength().", queue.length == 1);
			queue.next();
			assertTrue("Queue length is incorrect for testLength().", queue.length == 0);
		}
		
		/**
		 * Verify that the method return the proper values 
		 * when the queue does and does not have data. 
		 * 
		 */
		public function testHasItems():void
		{
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			
			assertTrue("Should have items for testHasItems().", queue.hasItems);
			queue.next();
			assertFalse("Queue should not have any items left.", queue.hasItems);
			queue.addItem(item1);
			assertTrue("Should have items for testHasItems().", queue.hasItems);
			queue.next();
			assertFalse("Queue should not have any items left.", queue.hasItems);
		}
		
		/**
		 * Verify that the priority queue has the ability to view 
		 * the next item in the queue without removing the item 
		 * from the queue itself.
		 * 
		 */
		public function testPeek():void
		{
			// create the queue and 1 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			
			assertTrue("Peek did not show the correct item.", item1 === queue.peek());
			assertTrue("Peek should not have removed the item.", item1 === queue.next());
		}
		
		/**
		 * Verify that a cloned array of the items table is returned. 
		 * 
		 */
		public function testItems():void
		{
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3);
			queue.addItem(item1);
			
			var list:Array = queue.items;
			
			// verify the order is correct
			assertTrue("Queue did not return expected item1 in position 0.", item1 === list[0]);
			assertTrue("Queue did not return expected item1 in position 1.", item2 === list[1]);
			assertTrue("Queue did not return expected item1 in position 2.", item3 === list[2]);
			assertTrue("Queue did not return expected item1 in position 3.", item1 === list[3]);
			
			// change the array, make sure its a clone
			list[0] = item2;			
			assertTrue("Queue did not return expected item1.", item1 === queue.next());
		}
		
		/**
		 * Verify that removing an item from the beginning of the queue works. 
		 * 
		 */
		public function testRemoveAtBegining():void {
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3);
			
			// remove the first item, verify true is returned, the length is now two and the item order is correct
			assertTrue("The removeAt() method did not return true when removing a valid item.", queue.removeAt(0));
			assertTrue("The length of the queue should have been 2.", queue.length == 2);
			assertTrue("Queue did not return expected item2.", item2 === queue.next());
			assertTrue("Queue did not return expected item3.", item3 === queue.next());
		}
		
		/**
		 * Verify that removing an item from the middle of the queue works. 
		 * 
		 */
		public function testRemoveAtMiddle():void {
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3);
			
			// remove the first item, verify true is returned, the length is now two and the item order is correct
			assertTrue("The removeAt() method did not return true when removing a valid item.", queue.removeAt(1));
			assertTrue("The length of the queue should have been 2.", queue.length == 2);
			assertTrue("Queue did not return expected item1.", item1 === queue.next());
			assertTrue("Queue did not return expected item3.", item3 === queue.next());
		}
		
		/**
		 * Verify that removing an item from the end of the queue works. 
		 * 
		 */
		public function testRemoveAtEnd():void {
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3);
			
			// remove the first item, verify true is returned, the length is now two and the item order is correct
			assertTrue("The removeAt() method did not return true when removing a valid item.", queue.removeAt(2));
			assertTrue("The length of the queue should have been 2.", queue.length == 2);
			assertTrue("Queue did not return expected item1.", item1 === queue.next());
			assertTrue("Queue did not return expected item2.", item2 === queue.next());
		}
		
		/**
		 * Verify that removing an invalid postion is handled with no
		 * error and does not modify the queue. 
		 * 
		 */
		public function testRemoveAtInvalidPosition():void {
			// create the queue and 3 test items
			var queue:PriorityQueue = new PriorityQueue();
			var item1:Object = new Object();
			var item2:Object = new Object();
			var item3:Object = new Object();
			
			// add the items in order
			queue.addItem(item1);
			queue.addItem(item2); 
			queue.addItem(item3);
			
			// remove the a bad position, verify false is returned and the queue is unchanged
			assertFalse("The removeAt() method did not return false when removing an invalid position.", queue.removeAt(6));
			assertTrue("The length of the queue should have been 3.", queue.length == 3);
			assertTrue("Queue did not return expected item1.", item1 === queue.next());
			assertTrue("Queue did not return expected item2.", item2 === queue.next());
			assertTrue("Queue did not return expected item3.", item3 === queue.next());
		}
	}
}