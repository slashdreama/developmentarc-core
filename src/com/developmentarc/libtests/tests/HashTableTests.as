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
	import com.developmentarc.framework.datastructures.utils.HashTable;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * This Suite tests all the functionality of the HashTable and verifies
	 * that the HashTable behaves as designed.
	 * @author James Polanco
	 * 
	 */
	public class HashTableTests extends TestCase
	{
		/**
		 * TestCase Constructor.
		 *  
		 * @param methodName Test method to run.
		 * 
		 */
		public function HashTableTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * verifies that items can be added to the HashTable and then 
		 * retrieved using the provided key 
		 * 
		 */
		public function testAddAndRetrieveItem():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var item1:Object = {id: "item1"};
			var key2:Object = {id: "key2"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item2 == hash.getItem(key2)));
		}
		
		/**
		 * Verifies that the same item can be added twice with different keys
		 * and also that the item can be retrieved using the different keys 
		 * 
		 */
		public function testSameItemWithDifferentKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key2)));
		}
		
		/**
		 * verifies that when adding different items with the same key 
		 * overwrites the original key/item pair 
		 * 
		 */
		public function testAddItemsUsingTheSameKey():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			
			// add item2 using key 1
			hash.addItem(key1, item2);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item2 == hash.getItem(key1)));
		}
		
		/**
		 * verifies that an item that is added by a key is then removed 
		 * from the HashTable with the key 
		 * 
		 */
		public function testAddAndRemoveItem():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var item1:Object = {id: "item1"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			
			// remove the item and verify that it is gone
			hash.remove(key1);
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key1));
		}
		
		/**
		 * verifies that an item which is in the HashTable multiple times 
		 * can be removed by the specific key provided 
		 * 
		 */
		public function testAddRemoveSameItemDifferentKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item1);
			
			// get the item
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key2)));
			
			// remove the item and verify that it is gone
			hash.remove(key1);
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key1));
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key2)));
			
			hash.remove(key2);
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key2));
		}
		
		/**
		 * verifies that adding multiple items then calling removeAll() clears the HashTable. 
		 * 
		 */
		public function testAddMultipleItemsThenRemoveAll():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// get the items
			assertTrue("The retrieved item does not match the item put in.",(item1 == hash.getItem(key1)));
			assertTrue("The retrieved item does not match the item put in.",(item2 == hash.getItem(key2)));
			assertTrue("The retrieved item does not match the item put in.",(item3 == hash.getItem(key3)));
			
			// remove all
			hash.removeAll();
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key1));
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key2));
			assertFalse("The item should no longer be in the HashTable.", hash.getItem(key3));
		}
		
		/**
		 * verify that adding key pairs and then requesting locations 
		 * returns the correct key 
		 * 
		 */
		public function testAddKeyCheckPosition():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// check the position
			assertTrue("The retrieved item does not match the item put in.",(key1 == hash.getKeyAt(0)));
			assertTrue("The retrieved item does not match the item put in.",(key2 == hash.getKeyAt(1)));
			assertTrue("The retrieved item does not match the item put in.",(key3 == hash.getKeyAt(2)));
		}
		
		/**
		 * verify that calling getAllItmes() returns all the items 
		 * that have been added to the Hashtable in the order they where
		 * added.
		 * 
		 */
		public function testAddItemsGetAllItems():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// check that we got all the items back
			var list:Array = hash.getAllItems();
			
			assertTrue("The list of items count is not correct.", list.length == 3);
			assertTrue("The retrieved item does not match the item put in.",(item1 == list[0]));
			assertTrue("The retrieved item does not match the item put in.",(item2 == list[1]));
			assertTrue("The retrieved item does not match the item put in.",(item3 == list[2]));
		}
		
		/**
		 * verify that adding multiple pairs returns all the keys that have been added 
		 * 
		 */
		public function testAddKeysGetAllKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			hash.addItem(key3, item3);
			
			// check that we got all the items back
			var list:Array = hash.getAllKeys();
			
			assertTrue("The list of items count is not correct.", list.length == 3);
			assertTrue("The retrieved item does not match the item put in.",(key1 == list[0]));
			assertTrue("The retrieved item does not match the item put in.",(key2 == list[1]));
			assertTrue("The retrieved item does not match the item put in.",(key3 == list[2]));
		}
		
		/**
		 * verify that the HashTable properly identifies an existing item in the table
		 * 
		 */
		public function testVerifyExistingItems():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Item should exist.", hash.containsItem(item1));
			assertTrue("Item should exist.", hash.containsItem(item2)); 
			
			// remove the item and verify that it no longer contains the key
			hash.remove(key1);
			assertFalse("Key should not exist.", hash.containsItem(item1));
		}
		
		/**
		 * verifies that the HashTable properly returns a negative response 
		 * for a non-existing item
		 * 
		 */
		public function testVerifyNonExistingItems():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Item should exist.", hash.containsItem(item1));
			assertTrue("Item should exist.", hash.containsItem(item2)); 
			assertFalse("Item should not exist.", hash.containsItem(item3)); 
		}
		
		/**
		 * verify that the HashTable properly identifies an existing key in the table
		 * 
		 */
		public function testVerifyExistingKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Key should exist.", hash.containsKey(key1));
			assertTrue("Key should exist.", hash.containsKey(key2));
			
			// remove the item and verify that it no longer contains the key
			hash.remove(key1);
			assertFalse("Key should not exist.", hash.containsKey(key1));
		}
		
		/**
		 * verifies that the HashTable properly returns a negative response 
		 * for a non-existing key
		 * 
		 */
		public function testVerifyNonExistingKeys():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify existing items
			assertTrue("Key should exist.", hash.containsKey(key1));
			assertTrue("Key should exist.", hash.containsKey(key2)); 
			assertFalse("Key should not exist.", hash.containsItem(key3)); 
		}
		
		/**
		 * verifies that the hashtable responds with the proper value 
		 * when the item is empty and when it contains items
		 * 
		 */
		public function testIsEmpty():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			
			// verify the hash table returns empty
			assertTrue("The HashTable should be empty.", hash.isEmpty);
			
			// add the pair to the table
			hash.addItem(key1, item1);
			hash.addItem(key2, item2);
			
			// verify the table is not empty
			assertFalse("The HashTable should not be empty.", hash.isEmpty);
			
			// remove all then verify that the table is empty
			hash.removeAll();
			assertTrue("The HashTable should be empty.", hash.isEmpty);
		}
		
		/**
		 * verifies that the correct length is returned for the content. 
		 * 
		 */
		public function testLength():void
		{
			// create the test items and table
			var hash:HashTable = new HashTable();
			var key1:Object = {id: "key1"};
			var key2:Object = {id: "key2"};
			var key3:Object = {id: "key3"};
			var item1:Object = {id: "item1"};
			var item2:Object = {id: "item2"};
			var item3:Object = {id: "item3"};
			
			// verify the hash table returns empty
			assertTrue("The HashTable length should be 0.", hash.length == 0);
			
			// add the pair to the table and verify length
			hash.addItem(key1, item1);
			assertTrue("The HashTable length should be 1.", hash.length == 1);
			
			hash.addItem(key2, item2);
			assertTrue("The HashTable length should be 2.", hash.length == 2);
			
			hash.addItem(key3, item3);
			assertTrue("The HashTable length should be 3.", hash.length == 3);
			
			// remove one by onw and verify length
			hash.remove(key3);
			assertTrue("The HashTable length should be 2.", hash.length == 2);
			hash.remove(key2);
			assertTrue("The HashTable length should be 1.", hash.length == 1);
			hash.remove(key1);
			assertTrue("The HashTable length should be 0.", hash.length == 0);
		}
	}
}