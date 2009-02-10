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
	import com.developmentarc.framework.controllers.SelectionController;
	import com.developmentarc.libtests.elements.selectiongroup.SelectionObject;
	
	import flexunit.framework.TestCase;

	public class SelectionControllerTests extends TestCase
	{

		/**
		 * Constructor. 
		 * @param param
		 * 
		 */
		public function SelectionControllerTests(methodName:String=null)
		{
			super(methodName);
		}
		
	override public function tearDown():void
		{
			// reset the instance of the SelectionController
			SelectionController.clearAllGroups();
		}
		
		/**
		 * This test creates two selectable items and then adds them to a new selection group.  
		 * Once added to the group the code the selects the first item and then
		 * verifies that only the first item was selected.  Then the code selects the
		 * second item and verifies that the the first is now deslected and the second is
		 * selected.
		 * 
		 */
		public function testBasicSelection():void
		{
			// create two selection object
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			
			// select item 1
			SelectionController.selectItem(selection1);
			
			// verify that 1 is selected and 2 is deselected
			assertTrue("Selection1 should be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			
			// select item 2
			SelectionController.selectItem(selection2);
			
			// verify that 1 is now deselected and 2 is selected
			assertFalse("Selection1 should be deselected.", selection1.selected);
			assertTrue("Selection2 should be selected.", selection2.selected);
		}
		
		/**
		 * This tests verifies the independence of selection groups.  The test creates four
		 * selectable items and then groups the first two as a selection grouping and the
		 * last two as a different selection group.  The test verifies that the groups have
		 * unique generated ids and then begins selecting each item in the groups and makes
		 * sure that the selection is maintained across groupings. 
		 * 
		 */
		public function testBasicMultipleSelectionGroups():void
		{
			// create four selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			var selection4:SelectionObject = new SelectionObject();
			
			// get an id and then add the first two objects to the controller
			var firstGroupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, firstGroupID);
			SelectionController.addItem(selection2, firstGroupID);
			
			// get a new id and verify that it is different the the first 
			var secondGroupId:int = SelectionController.generateNewId();
			assertFalse("Group ID one should be different then group ID two.", firstGroupID == secondGroupId);
			
			// add the last two items to the new group
			SelectionController.addItem(selection3, secondGroupId);
			SelectionController.addItem(selection4, secondGroupId);
			
			// select item 1 in group 1
			SelectionController.selectItem(selection1);
			
			// verify that 1 is selected and all others are deselected
			assertTrue("Selection1 should be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			assertFalse("Selection4 should be deselected.", selection4.selected);
			
			// select item 3 in the second group
			SelectionController.selectItem(selection3);
			
			// verify that 3 is now selected and 2/4 are deselected
			assertTrue("Selection1 should be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertTrue("Selection3 should be selected.", selection3.selected);
			assertFalse("Selection4 should be deselected.", selection4.selected);
			
			// select item 2 in the first group
			SelectionController.selectItem(selection2);
			
			// verify that 2 is now selected and 1/4 are deselected
			assertFalse("Selection1 should be deselected.", selection1.selected);
			assertTrue("Selection2 should be selected.", selection2.selected);
			assertTrue("Selection3 should be selected.", selection3.selected);
			assertFalse("Selection4 should be deselected.", selection4.selected);
			
			// select item 4 in the second group
			SelectionController.selectItem(selection4);
			
			// verify that 4 is now selected and 1/3 are deselected
			assertFalse("Selection1 should be deselected.", selection1.selected);
			assertTrue("Selection2 should be selected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			assertTrue("Selection4 should be selected.", selection4.selected);
		}
		
		/**
		 * This tests that when an item is not in a selection group it is still selected
		 * but that the rest of the items in the controller are not affected.  The test
		 * first creates three items then adds the first two to a selection group.  The
		 * test then selects the 3rd item and verifies that the only it is selected and
		 * the rest of the items are not affected. 
		 * 
		 */
		public function testSelectionOfNongroupedItems():void
		{
			// create three selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			
			// select the first item, verify that only its selection changes
			SelectionController.selectItem(selection1);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// select the 3rd item which is not in a group
			SelectionController.selectItem(selection3);
			
			// verify that only the 3rd items selection changed
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertTrue("Selection3 should be selected.", selection3.selected);
		}
		
		/**
		 * This test verifies that any selected items in a group are deselected when
		 * the deselectAll() method is called passing in the group id number.  This is
		 * done by creating two items, adding them to the group, selecting one item,
		 * then calling deselect all.  The test then verifies that both items are
		 * deselected. 
		 * 
		 */
		public function testBasicDeselectAll():void
		{
			// create two selection object
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			
			// select item 1
			SelectionController.selectItem(selection1);
			
			// verify that 1 is selected and 2 is deselected
			assertTrue("Selection1 should be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			
			// deselect all
			SelectionController.deselectAll(groupID);
			
			// verify that both are deselected
			assertFalse("Selection1 should be deselected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
		}
		
		/**
		 * This test verifies that passing in an invalid group id to the
		 * deselectAll() method does not change the selection of any existing
		 * groups.  This  is done by creating a group, setting a select state
		 * then calling deselect all on an invalid group and verifying that
		 * the original group has not changed.
		 * 
		 */
		public function testDeselectAllWithInvalidGroup():void
		{
			// create two selection object
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			
			// select item 1
			SelectionController.selectItem(selection1);
			
			// verify that 1 is selected and 2 is deselected
			assertTrue("Selection1 should be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			
			// deselect all with an invalid group
			SelectionController.deselectAll(1234);
			
			// verify that 1 is selected and 2 is deselected
			assertTrue("Selection1 should be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
		}
		
		/**
		 * This test verifies that when an item is added to a selection group
		 * that when the getItemGroup() for the item is called that it corrrect
		 * group id is returned.  This test verifies this by creating an item, 
		 * generating a group id, adding the item to the generated id and then
		 * requesting the group id for the item.
		 * 
		 */
		public function testGetGroupIDForValidItem():void
		{
			// create a selection object
			var selection1:SelectionObject = new SelectionObject();
			
			// get a new id and then add the object to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			
			// get the id and verify that it matches
			var reportedID:int = SelectionController.getItemGroup(selection1);
			assertTrue("The reported ID should be the same as the set group id.", groupID == reportedID);
		}
		
		/**
		 * This test verifies that requesting an group id for an item currently not
		 * being tracked that the return value is -1. This test verifies this by
		 * creating a selection object that is not grouped and then requests the
		 * id for the item.
		 * 
		 */
		public function testGetGroupIdWithInvalidItem():void
		{
			// create a selection object
			var selection1:SelectionObject = new SelectionObject();
			
			// ask the controller what the id for the object is
			var reportedID:int = SelectionController.getItemGroup(selection1);
			
			// verify that the id is -1
			assertTrue("The reported id should be -1.", (reportedID == -1 ? true : false));
		}
		
		/**
		 * Tests that when removeAllItems from a group is called that the
		 * grouped items are truly removed and no longer affected by the
		 * grouping.  This is verified by grouping three objects and selecting
		 * one of the items.  The items are then removed from their group and
		 * then deselect is called which should not affect the current selection
		 * status and then the group id for the three items is verified to be -1.
		 * 
		 */
		public function testRemoveAllItemsFromValidGroup():void
		{
			// create three selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			SelectionController.addItem(selection3, groupID);
			
			// select the first item, verify that only its selection changes
			SelectionController.selectItem(selection1);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// call remove all then verify that changing selection is not affected
			SelectionController.removeAllItems(groupID);
			
			SelectionController.deselectAll(groupID);
			assertTrue("Selection1 was deselected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// also verify these items are not longer bound to a group
			assertTrue("Selection1 should be in group -1.", (SelectionController.getItemGroup(selection1) == -1));
			assertTrue("Selection2 should be in group -1.", (SelectionController.getItemGroup(selection2) == -1));
			assertTrue("Selection3 should be in group -1.", (SelectionController.getItemGroup(selection3) == -1));
		}
		
		/**
		 * Tests that attempting to remove all from a non-existing group does not
		 * throw an error nor effect any existing items.  This is verified by creating
		 * a group and then attempting remove all on a non-existing group id. The existing
		 * group is then manipulated and tested to make sure that the group stays correctly
		 * linked.
		 * 
		 */
		public function testRemoveAllItemsForInvalidGroup():void
		{
			// create three selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			SelectionController.addItem(selection3, groupID);
			
			// select the first item, verify that only its selection changes
			SelectionController.selectItem(selection1);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// call remove all on an invalid group then verify that changing selection is correct
			SelectionController.removeAllItems(333);
			
			SelectionController.deselectAll(groupID);
			assertFalse("Selection1 should be deselected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// also verify these items are not longer bound to a group
			assertTrue("Selection1 should be in a group.", (SelectionController.getItemGroup(selection1) == groupID));
			assertTrue("Selection2 should be in a group.", (SelectionController.getItemGroup(selection2) == groupID));
			assertTrue("Selection3 should be in a group.", (SelectionController.getItemGroup(selection3) == groupID));
		}
		
		/**
		 * Tests that removing a single item from a grouping does remove the item
		 * and does not effect the rest of the group.  This is verified by creating
		 * a group and then selecting the first item. The first item is then removed
		 * from the grouping and the second item in the group is selected.  The test
		 * checks to make sure the first item is still selected and the second item
		 * is now selected.  The test then deselects the group and verifies that the
		 * first item is still selected and the rest are deselected. 
		 * 
		 */
		public function testRemoveSingleItemFromGroup():void
		{
			// create three selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			SelectionController.addItem(selection3, groupID);
			
			// select the first item, verify that only its selection changes
			SelectionController.selectItem(selection1);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// remove item one, select item 2
			SelectionController.removeItem(selection1);
			SelectionController.selectItem(selection2);
			
			// verify that 1 and 2 are selected
			assertTrue("Selection1 should be selected.", selection1.selected);
			assertTrue("Selection2 should be selected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// deselect the existing group and make sure 1 is still selected
			SelectionController.deselectAll(groupID);
			assertTrue("Selection1 should still be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
		}
		
		/**
		 * Tests that removing an ungrouped item does not through an error nor
		 * does it affect the grouping of the item.  This is verified by creating
		 * an ungrouped item, attempting to remove it from the controller and
		 * then verifying that it is still ungrouped.
		 * 
		 */
		public function testRemovingUngroupedItem():void
		{
			// create a selection object
			var selection1:SelectionObject = new SelectionObject();
			
			// ask the controller what the id for the object is
			SelectionController.removeItem(selection1);
			
			// verify that the id is -1
			assertTrue("The reported id should be -1.", (SelectionController.getItemGroup(selection1) == -1));
		}
		
		/**
		 * Tests that clearAllGroups() resets the controller to its default state.
		 * This is verified by adding a group of object, validting is selection,
		 * cleaing the controller, then attempting to both deselect the previous
		 * group and also verify the group id is -1. 
		 * 
		 */		
		public function testClearAll():void
		{
			// create three selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupID:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupID);
			SelectionController.addItem(selection2, groupID);
			SelectionController.addItem(selection3, groupID);
			
			// select the first item, verify that only its selection changes
			SelectionController.selectItem(selection1);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// clear the controller
			SelectionController.clearAllGroups();
			
			// deselect the existing group and make sure 1 is still selected
			SelectionController.deselectAll(groupID);
			assertTrue("Selection1 should still be selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			
			// also verify these items are not longer bound to a group
			assertTrue("Selection1 should be in group -1.", (SelectionController.getItemGroup(selection1) == -1));
			assertTrue("Selection2 should be in group -1.", (SelectionController.getItemGroup(selection2) == -1));
			assertTrue("Selection3 should be in group -1.", (SelectionController.getItemGroup(selection3) == -1));
		}
		
		/**
		 * Tests that regouping an item does not cause and error and
		 * properly maps the item to the new group.  This is verified by
		 * creating two groups and then mapping one item from group one
		 * into group two.  The test then manipulates the selection in
		 * the groups and verifies that the selection is handled as selected. 
		 * 
		 */
		public function testRegrouping():void
		{
			// create six selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			var selection4:SelectionObject = new SelectionObject();
			var selection5:SelectionObject = new SelectionObject();
			var selection6:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupOne:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupOne);
			SelectionController.addItem(selection2, groupOne);
			SelectionController.addItem(selection3, groupOne);
			
			// get a new id and then add the objects to the controller
			var groupTwo:int = SelectionController.generateNewId();
			SelectionController.addItem(selection4, groupTwo);
			SelectionController.addItem(selection5, groupTwo);
			SelectionController.addItem(selection6, groupTwo);
			
			// select one in each group
			SelectionController.selectItem(selection1);
			SelectionController.selectItem(selection4);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertFalse("Selection2 should be deselected.", selection2.selected);
			assertFalse("Selection3 should be deselected.", selection3.selected);
			assertTrue("Selection4 was not selected.", selection4.selected);
			assertFalse("Selection5 should be deselected.", selection5.selected);
			assertFalse("Selection6 should be deselected.", selection6.selected);
			
			// regroup selection 3
			SelectionController.addItem(selection3, groupTwo);
			
			// select one in each group
			SelectionController.selectItem(selection2);
			SelectionController.selectItem(selection3);
			assertFalse("Selection1 should be deselected.", selection1.selected);
			assertTrue("Selection2 should be selected.", selection2.selected);
			assertTrue("Selection3 should be selected.", selection3.selected);
			assertFalse("Selection4 should be deselected.", selection4.selected);
			assertFalse("Selection5 should be deselected.", selection5.selected);
			assertFalse("Selection6 should be deselected.", selection6.selected);
		}
		
		/**
		 * verifies that when select all is called all of the groups
		 * items are selected.  This test also verifies that if an invalid groupd
		 * is passed the selection is not affected. 
		 * 
		 */
		public function testSelectAll():void
		{
			// create six selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupOne:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupOne);
			SelectionController.addItem(selection2, groupOne);
			SelectionController.addItem(selection3, groupOne);
			
			SelectionController.selectAll(groupOne);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertTrue("Selection2 was not selected.", selection2.selected);
			assertTrue("Selection3 was not selected.", selection3.selected);
			
			SelectionController.selectAll(333);
			assertTrue("Selection1 was not selected.", selection1.selected);
			assertTrue("Selection2 was not selected.", selection2.selected);
			assertTrue("Selection3 was not selected.", selection3.selected);
		}
		
		/**
		 * Verifies that getAllItemsInGroup() returns the complete
		 * list of items within the group id.  
		 * 
		 */
		public function testGetAllItems():void
		{
			// create six selection objects
			var selection1:SelectionObject = new SelectionObject();
			var selection2:SelectionObject = new SelectionObject();
			var selection3:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupOne:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupOne);
			SelectionController.addItem(selection2, groupOne);
			SelectionController.addItem(selection3, groupOne);
			
			// get the list back
			var list:Array = SelectionController.getAllItemsInGroup(groupOne);
			
			assertTrue("The length of the returned list is incorrect.", list.length == 3);
			assertTrue("The 0 position of the list contained the incorrect item.", selection1 === list[0]);
			assertTrue("The 1 position of the list contained the incorrect item.", selection2 === list[1]);
			assertTrue("The 2 position of the list contained the incorrect item.", selection3 === list[2]);
		}
		
		/**
		 * Verify that getAllItemsInGroup() returns an empty array when
		 * provided an invalid group id.
		 * 
		 */
		public function testGetAllItemsInvalidID():void
		{
			// create six selection objects
			var selection1:SelectionObject = new SelectionObject();
			
			// get a new id and then add the objects to the controller
			var groupOne:int = SelectionController.generateNewId();
			SelectionController.addItem(selection1, groupOne);
			
			// get the list back
			var list:Array = SelectionController.getAllItemsInGroup(123456);
			
			// the list should be empty
			assertTrue("The length of the returned list is incorrect.", list.length == 0);
		}
	}
}