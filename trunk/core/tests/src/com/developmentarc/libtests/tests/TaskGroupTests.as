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
	import com.developmentarc.framework.controllers.abstracts.AbstractTask;
	import com.developmentarc.framework.controllers.events.TaskEvent;
	import com.developmentarc.framework.controllers.interfaces.ITask;
	import com.developmentarc.framework.datastructures.tasks.TaskGroup;
	import com.developmentarc.libtests.elements.tasks.TestTask;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority0;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority1;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority2;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority3;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority4;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority5;
	
	import flexunit.framework.TestCase;

	public class TaskGroupTests extends TestCase
	{
		
		private const GROUP_TYPE:String = "Test_Group";
		private const GROUP_UID:int = 11111;
		
		public var taskGroup:TaskGroup
		
		public function TaskGroupTests(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			// create a new controller
			taskGroup = new TaskGroup(GROUP_TYPE,0,GROUP_UID);
		}
		
		override public function tearDown():void
		{
			taskGroup = null;
		}
		
		// TEST METHODS
		/**
		 * Method tests that a type is saved via the constructor
		 */
		public function testType():void {
			// Test Group has same type as defined in constructor
			assertTrue("Group should have same type as defined in constructor", taskGroup.type == GROUP_TYPE);
		}
		public function testGroupId():void {
			// Test Group has same uid as defined in constructor
			assertTrue("Group should have same uid as defined in constructor", taskGroup.uid == GROUP_UID);
		}
		public function testAddTasks():void {
			var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			var task2:TestTaskPriority2 = new TestTaskPriority2();
			var task3:TestTaskPriority3 = new TestTaskPriority3();
			var task4:TestTaskPriority4 = new TestTaskPriority4();
			var task5:TestTaskPriority5 = new TestTaskPriority5();
			
			// Add first item
			taskGroup.addTask(task4);
			
			// Verify one task can be added to the group
			assertTrue("Task should be first item", taskGroup.getTaskIndex(task4) == 0);
			// Verify only one task is in group
			assertTrue("One task should be in group", taskGroup.tasks.length == 1);
			// Verify a non added task returns -1
			assertTrue("Task should not be in Group", taskGroup.getTaskIndex(task5) == -1);
			
			// Add second item
			taskGroup.addTask(task5);
			
			// Verify priority 5 task is behind priority 4
			assertTrue("Task should be second item", taskGroup.getTaskIndex(task5) == 1);
			// Verify group has two tasks
			assertTrue("Two task should be in group", taskGroup.tasks.length == 2);
			
			// Add third item (task2, should be highest priority)
			taskGroup.addTask(task2);
			// Verify new task is first in priority
			assertTrue("Task should be first item", taskGroup.getTaskIndex(task2) == 0);			
			// Verify 3 items are in group
			assertTrue("Three tasks should be in group", taskGroup.tasks.length == 3);			
			// Verify other 2 tasks are in proper order (4,5)
			assertTrue("Task 4 should be second item in group", taskGroup.getTaskIndex(task4) == 1);
			assertTrue("Task 5 should be third item in group", taskGroup.getTaskIndex(task5) == 2);
			
			// Add fourth item (task3, should be second item)
			taskGroup.addTask(task3);
			
			// Verify 4 items are in group
			
			assertTrue("Four tasks should be in group", taskGroup.tasks.length == 4);			
			// Verify other 5 tasks are in proper order (2,3,4,5)
			assertTrue("Task 2 should be first item in group", taskGroup.getTaskIndex(task2) == 0);
			assertTrue("Task 3 should be second item in group", taskGroup.getTaskIndex(task3) == 1);
			assertTrue("Task 4 should be third item in group", taskGroup.getTaskIndex(task4) == 2);
			assertTrue("Task 5 should be fourth item in group", taskGroup.getTaskIndex(task5) == 3);
			
			
			// Add fifth item (task0, should be first item)
			taskGroup.addTask(task0);
			
			// Verify 5 items are in group
			assertTrue("Five tasks should be in group", taskGroup.tasks.length == 5);	
					
			// Verify proper order (0,2,3,4,5)
			assertTrue("Task 0 should be first item in group", taskGroup.getTaskIndex(task0) == 0);
			assertTrue("Task 2 should be second item in group", taskGroup.getTaskIndex(task2) == 1);
			assertTrue("Task 3 should be third item in group", taskGroup.getTaskIndex(task3) == 2);
			assertTrue("Task 4 should be fourth item in group", taskGroup.getTaskIndex(task4) == 3);
			assertTrue("Task 5 should be fifth item in group", taskGroup.getTaskIndex(task5) == 4);
			
			
			// Add sixth item (task1, should be second item)
			taskGroup.addTask(task1);
			
			// Verify 6 items are in group
			assertTrue("Six tasks should be in group", taskGroup.tasks.length == 6);	
					
			// Verify proper order (0,12,3,4,5)
			assertTrue("Task 0 should be first item in group", taskGroup.getTaskIndex(task0) == 0);
			assertTrue("Task 1 should be secon item in group", taskGroup.getTaskIndex(task1) == 1);
			assertTrue("Task 2 should be third item in group", taskGroup.getTaskIndex(task2) == 2);
			assertTrue("Task 3 should be fourth item in group", taskGroup.getTaskIndex(task3) == 3);
			assertTrue("Task 4 should be fifth item in group", taskGroup.getTaskIndex(task4) == 4);
			assertTrue("Task 5 should be sixth item in group", taskGroup.getTaskIndex(task5) == 5);
		}
		/**
		 * Test verifies that TaskGroup indicates whether it has a task or not
		 */
		public function testHasTask():void {
			var task:TestTask = new TestTask();
			
			// Add one task
			taskGroup.addTask(task);
			
			// Verify group inidicates it has at least one task
			assertTrue("Task Group should have task", taskGroup.hasTask);
			
			// Remove task from group
			taskGroup.removeTask(task);
			
			// Verify the group no has no tasks
			assertFalse("Task Group should NOT have task", taskGroup.hasTask);
		}
		
		/**
		 * Test verifies removing a task works correctly
		 */
		 public function testRemoveTask():void {
		 	var task:TestTaskPriority0 = new TestTaskPriority0();
			
			// Add one task
			taskGroup.addTask(task);
			// Verify task is added
			assertTrue("Task should be added", taskGroup.getTaskIndex(task) >= 0);
			// Remove task
			taskGroup.removeTask(task);
			// Verify task is removed			
			assertFalse("Task should be removed", taskGroup.getTaskIndex(task) >= 0);
		 }
		 
		 /**
		 * Test verifies removing multiple tasks works as expected.
		 * These test do not work with TestContoller
		 */
		 public function testRemoveTasks():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			var task2:TestTaskPriority2 = new TestTaskPriority2();
			var task3:TestTaskPriority3 = new TestTaskPriority3();
			
			// Add three tasks
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			taskGroup.addTask(task2);
			
			// Remove Middle Task
			taskGroup.removeTask(task1);
			
			// Verify 2 tasks remain and are expected two
			assertTrue("Two tasks should be in group", taskGroup.tasks.length == 2);
			assertTrue("Task 0 should still be in group", taskGroup.getTaskIndex(task0) >= 0);
			assertTrue("Task 2 should still be in group", taskGroup.getTaskIndex(task2) >= 0);
			// Verify task removed is not there
			assertFalse("Task 1 should not be in group", taskGroup.getTaskIndex(task1) >= 0);
			
			// Remove last two
			taskGroup.removeTask(task0);
			taskGroup.removeTask(task2);
			// Verify no tasks remain
			assertTrue("No tasks should be in group", taskGroup.tasks.length == 0);
			
			// Add three tasks, again
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			taskGroup.addTask(task2);
			
			// Verify three are added
			assertTrue("Three tasks should be in group", taskGroup.tasks.length == 3);
			// Remove all items
			taskGroup.removeAllTasks();			
			// Verify three are removed
			assertTrue("No tasks should be in group", taskGroup.tasks.length == 0);
		 }
		 /**
		 * Test verifies groups next method functionality
		 */
		 public function testNext():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			var task2:TestTaskPriority2 = new TestTaskPriority2();
			var task3:TestTaskPriority3 = new TestTaskPriority3();
			
			// Add three tasks
			taskGroup.addTask(task2);
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			
			// Verify group next functionality gets tasks based on priority
			assertTrue("Next should return task0", taskGroup.next() == task0);
			assertTrue("Next should return task1", taskGroup.next() == task1);
			assertTrue("Next should return task2", taskGroup.next() == task2);			
		 }
		 /**
		 * Test the TaskGroup cancel functionality. Upon canceling
		 * Group, all tasks within the group should also be canceled.
		 * Verifies the group fires cancel event.
		 */
		 public function testCancelGroup():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			
			// Add two tasks to group
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			
			// Listen for Task Group Cancel Event
			taskGroup.addEventListener(TaskEvent.TASK_CANCEL, addAsync(handleTaskCanceled,500),false, 0,true);
		 	
		 	// Cancel Group
		 	taskGroup.cancel();
		 }
		 /**
		 * Verify group cancel will cancel all tasks in the queue. 
		 * Verifies the task is canceled
		 */
		 public function testCancelGroupVerifyTask():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			
			// Add two tasks to group
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			
			// Listen for Task Group Cancel Event
			task1.addEventListener(TaskEvent.TASK_CANCEL, addAsync(handleTaskCanceled,500),false, 0,true);
			
		 	// Cancel group
		 	taskGroup.cancel();
		 	
		 }
		 /**
		 * Verify the group fires a complete event when all it's tasks
		 * are completed and the group queue is empty 
		 */
		 public function testGroupComplete():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			
			// Listen for Task Group Complete Event
			taskGroup.addEventListener(TaskEvent.TASK_COMPLETE, addAsync(handleTaskComplete,500),false, 0,true);
		 	
		 	taskGroup.next();
		 	taskGroup.next();
		 	
		 	task0.triggerComplete();
		 	task1.triggerComplete();
		 }
		 
		 /**
		 * Verify that a group can not be added to a group
		 */
		 public function testAddGroup():void {
		 	var taskGroup2:TaskGroup = new TaskGroup("TYPE");
		 	var errorThrown:Boolean;
		 	
		 	try {
		 		taskGroup.addTask(taskGroup2);
		 	}
			catch(err:Error) {
				errorThrown = true
			}		 	
			
			assertTrue("Error should have been thrown when group is added to another group");
		 }
		 
		 
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the same type and Id. New task should not be added
		 */
		 public function testTaskOverrideWithSameTypesSameId():void {
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var taskIgnore:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	
		 	// Add both tasks to controller
		 	taskGroup.addTask(task1);
		 	taskGroup.addTask(taskIgnore);
		 	
		 	// Verify second task is ignored since both tasks have same id and uid
		 	taskIgnore.addEventListener(TaskEvent.TASK_IGNORED, addAsync(handleTaskIgnore, 500),false,0,true);
		 	
		 	// Add both tasks to controller
		 	taskGroup.addTask(task1);
		 	taskGroup.addTask(taskIgnore);
		 }
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the same type and differnt Ids
		 */
		 public function testTaskOverrideWithSameTypeDifferentId():void {
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var task2:ITask = new AbstractTask("SAME_TYPE", 0, 99999,true);
		 	
		 	// Add both tasks to controller
		 	taskGroup.addTask(task1);
		 	taskGroup.addTask(task2);
			
			// Verify  First task is canceled
			assertTrue("First task should be canceled", task1.phase == TaskEvent.TASK_CANCEL);
		 }
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the different type and s Ids
		 */
		 public function testTaskOverrideWithDifferentTypesSameId():void {
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var task2:ITask = new AbstractTask("DIFFERNT_TYPE", 0, 11111,true);
		 	
		 	// Add both tasks to controller
		 	taskGroup.addTask(task1);
		 	taskGroup.addTask(task2);
			
			// Verfiy first task is NOT canceled and second is not canceled
			assertTrue("First task should NOT be canceled", task1.phase != TaskEvent.TASK_CANCEL);
			assertTrue("Second task should NOT be canceled", task1.phase != TaskEvent.TASK_CANCEL);
		 }
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the different type and differnt Ids
		 */
		 public function testTaskOverrideWithDifferentTypesDifferentId():void {
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var task2:ITask = new AbstractTask("DIFFERNT_TYPE", 0, 99999,true);
		 	
		 	// Add both tasks to controller
		 	taskGroup.addTask(task1);
		 	taskGroup.addTask(task2);
			
			// Verfiy first task is NOT canceled and second is not canceled
			assertTrue("First task should NOT be canceled", task1.phase != TaskEvent.TASK_CANCEL);
			assertTrue("Second task should NOT be canceled", task1.phase != TaskEvent.TASK_CANCEL);
		 }
		 
		 
		 // test specific handlers
		// generic handlers for task event
		protected function handleTaskQueued(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to queued.", currentTask.phase == TaskEvent.TASK_QUEUED);
		}
		
		protected function handleTaskStart(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to start.", currentTask.phase == TaskEvent.TASK_START);
		}
		
		protected function handleTaskComplete(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to complete.", currentTask.phase == TaskEvent.TASK_COMPLETE);
		}
		
		protected function handleTaskInWaiting(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to in waiting.", currentTask.phase == TaskEvent.TASK_WAITING_FOR_READY);
		}
		protected function handleTaskCanceled(event:TaskEvent):void {
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to cancel.", currentTask.phase == TaskEvent.TASK_CANCEL);
		}
		protected function handleTaskIgnore(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to ignore.", currentTask.phase == TaskEvent.TASK_IGNORED);
		}
	}
}