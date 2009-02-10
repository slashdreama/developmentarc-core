/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2008 DevelopmentArc
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
	import com.developmentarc.framework.controllers.SelectionController;
	import com.developmentarc.framework.controllers.SelectionGroup;
	import com.developmentarc.libtests.elements.selectiongroup.SelectionGroupObject;
	import com.developmentarc.libtests.elements.selectiongroup.SelectionObject;
	
	import flexunit.framework.TestCase;

	public class SelectionGroupTests extends TestCase
	{
		public function SelectionGroupTests(methodName:String=null)
		{
			super(methodName);
		}
		override public function tearDown():void {
		
		}
		override public function setUp():void {
			
		}
		/**
		 * Testing the creationg of a new selection group. This test assumes upon 
		 * creation a  new group id is created via SelectionController
		 */
		public function testGroupCreation():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			
			assertTrue("Group should have new group id", selectionGroup.groupId > 0);
		}
		/**
		 * Method tests that one item can be added to a selection group
		 */
		public function testAddItem():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem:SelectionObject = new SelectionObject();
			
			selectionGroup.addItem(selectionItem);
			
			assertTrue("Group should have one item added", selectionGroup.items.length == 1);
			assertTrue("Group should have the same item that was added", selectionGroup.items[0] == selectionItem);
			
		}
		/**
		 * Method tests that multiple items can be added to a selection group
		 */
		public function testAddItems():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem1:SelectionObject = new SelectionObject();
			var selectionItem2:SelectionObject = new SelectionObject();
			var selectionItem3:SelectionObject = new SelectionObject();
			
			// Add first item
			selectionGroup.addItem(selectionItem1);
			// Test first item
			assertTrue("Group should have one item added", selectionGroup.items.length == 1);
			assertTrue("Group should have the same item that was added", selectionGroup.items[0] == selectionItem1);
			
			// Add second item
			selectionGroup.addItem(selectionItem2);
			// Test first item
			assertTrue("Group should have two items added", selectionGroup.items.length == 2);
			assertTrue("Group should have the same item that was added", selectionGroup.items[1] == selectionItem2);
			
			// Add second item
			selectionGroup.addItem(selectionItem3);
			// Test first item
			assertTrue("Group should have two items added", selectionGroup.items.length == 3);
			assertTrue("Group should have the same item that was added", selectionGroup.items[2] == selectionItem3);
		}
		
		public function testRemoveItem():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem:SelectionObject = new SelectionObject();
			
			// Add item to group
			selectionGroup.addItem(selectionItem);
			// Test item was added
			assertTrue("Group should have one item added", selectionGroup.items.length == 1);
			assertTrue("Group should have the same item that was added", selectionGroup.items[0] == selectionItem);
			// Remove item from group
			selectionGroup.removeItem(selectionItem);
			// Test item has been removed
			assertTrue("Group should have removed item", selectionGroup.items.length == 0);
			// Test SelectionController does not have reference to the selected item
			assertFalse("SelectionController should not have reference to the item", SelectionController.getItemGroup(selectionItem) == selectionGroup.groupId);
		}
		/**
		 * Method tests the removal of items from a group and test
		 * adding items back and then removing all items
		 */		
		public function testRemoveItems():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem1:SelectionObject = new SelectionObject();
			var selectionItem2:SelectionObject = new SelectionObject();
			var selectionItem3:SelectionObject = new SelectionObject();
			
			// Add two items
			selectionGroup.addItem(selectionItem1);
			selectionGroup.addItem(selectionItem2);
			// Remove first item
			selectionGroup.removeItem(selectionItem1);
			
			// Test only one item exists
			assertTrue("Selection Group should only have one item", selectionGroup.items.length == 1);
			// Test the first item was removed
			assertFalse("First item should not be contained in the group", selectionGroup.items[0] == selectionItem1);
			
			
			// Add item two items
			selectionGroup.addItem(selectionItem1);
			selectionGroup.addItem(selectionItem3);
			// Test three items are in the group
			assertTrue("Selection Group should contain three items", selectionGroup.items.length == 3);
			
			// Remove one item
			selectionGroup.removeItem(selectionItem1);
			// Test only two items remain
			assertTrue("Selection Group should only have one item", selectionGroup.items.length == 2);
			// Remove one item
			selectionGroup.removeItem(selectionItem2);
			// Test only one item remain
			assertTrue("Selection Group should only have one item", selectionGroup.items.length == 1);
			// Remove one item
			selectionGroup.removeItem(selectionItem3);
			// Test only one item remain
			assertTrue("Selection Group should have no items", selectionGroup.items.length == 0);
		}
		/**
		 * Method tests that items can be added as an array via the items property
		 */
		public function testAddItemsWithArray():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem1:SelectionObject = new SelectionObject();
			var selectionItem2:SelectionObject = new SelectionObject();
			var selectionItem3:SelectionObject = new SelectionObject();
			var selectionItems:Array = [selectionItem1,selectionItem2, selectionItem3]
			
			// Add array via items property
			selectionGroup.items = selectionItems;
			// Test three items were added
			assertTrue("Selection group should contain three items", selectionGroup.items.length == 3);
		}
		/**
		 * Method tests that items can be added as an array and then replaced by 
		 * a new array
		 */
		public function testResettingItemsWithArray():void{
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem1:SelectionObject = new SelectionObject();
			var selectionItem2:SelectionObject = new SelectionObject();
			var selectionItem3:SelectionObject = new SelectionObject();
			var selectionItems1:Array = [selectionItem1,selectionItem2, selectionItem3]
			
			// Add array via items property
			selectionGroup.items = selectionItems1;
			
			// Create new batch of selection items
			var selectionItem4:SelectionObject = new SelectionObject();
			var selectionItem5:SelectionObject = new SelectionObject();
			var selectionItems2:Array = [selectionItem4, selectionItem5];
			// Add array via items property (should remove other items)
			selectionGroup.items = selectionItems2;
			// Test three items were added
			assertTrue("Selection group should contain two items", selectionGroup.items.length == 2);						
		}
		/**
		 * Method tests that the group id is read only
		 */
		public function testSettingGroupId():void {
		
			var selectionGroup:SelectionGroup = new SelectionGroup();
			
			var errorThrown:Boolean;
			try {
				selectionGroup.groupId = 123456;
			}
			catch(err:Error) {
				errorThrown = true;
			}
			// Test Error was thrown when setting Group Id (should be read only)
			assertTrue("Error should be thrown", errorThrown);
		}
		/**
		 * Method tests the default Click Event inside of the group
		 */
		public function testDefaultEvent():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem1:SelectionGroupObject = new SelectionGroupObject();
			var selectionItem2:SelectionGroupObject = new SelectionGroupObject();
			
			// Add both items to group
			selectionGroup.items = [selectionItem1, selectionItem2];
			
			// Fire click for first item
			selectionItem1.fireClickEvent();
			
			// Verify first item is selected and second is not
			assertTrue("First item should be selected", selectionItem1.selected);
			assertTrue("Second item should NOT be selected", !selectionItem2.selected);
			
			// Fire click for second item
			selectionItem2.fireClickEvent();
			
			// Verify second item is selected and second is not
			assertTrue("First item should NOT be selected", !selectionItem1.selected);
			assertTrue("Second item should be selected", selectionItem2.selected);
		}
		/**
		 * Method tests the custom Event inside of the group
		 */
		public function testCustomEvent():void {
			var selectionGroup:SelectionGroup = new SelectionGroup();
			var selectionItem1:SelectionGroupObject = new SelectionGroupObject();
			var selectionItem2:SelectionGroupObject = new SelectionGroupObject();
			
			// Set Custom Events
			selectionGroup.events = SelectionGroupObject.CUSTOM_EVENT;
			// Add both items to group
			selectionGroup.items = [selectionItem1, selectionItem2];
			
			
			// Fire click for first item
			selectionItem1.fireCustomEvent();
			
			// Verify first item is selected and second is not
			assertTrue("First item should be selected", selectionItem1.selected);
			assertTrue("Second item should NOT be selected", !selectionItem2.selected);
			
			// Fire click for second item
			selectionItem2.fireCustomEvent();
			
			// Verify second item is selected and second is not
			assertTrue("First item should NOT be selected", !selectionItem1.selected);
			assertTrue("Second item should be selected", selectionItem2.selected);
		}
	}
}