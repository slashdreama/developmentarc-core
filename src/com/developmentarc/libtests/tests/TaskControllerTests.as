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
	import com.developmentarc.framework.controllers.TaskController;
	import com.developmentarc.framework.controllers.abstracts.AbstractTask;
	import com.developmentarc.framework.controllers.events.TaskEvent;
	import com.developmentarc.framework.controllers.interfaces.ITask;
	import com.developmentarc.framework.datastructures.tasks.TaskGroup;
	import com.developmentarc.libtests.elements.tasks.TestTask;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority0;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority1;
	import com.developmentarc.libtests.elements.tasks.TestTaskPriority2;
	
	import flexunit.framework.TestCase;

	public class TaskControllerTests extends TestCase
	{
		public var controller:TaskController;
		
		public function TaskControllerTests(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			// create a new controller
			controller = new TaskController();
		}
		
		override public function tearDown():void
		{
			controller = null;
		}
		
		/**
		 * Verify that adding a task that is ready to the controller 
		 * successfully adds the task, calls next() and the task is started() 
		 * 
		 */		
		public function testAddTaskReady():void
		{
			var task:TestTask = new TestTask();
			task.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart, 100), false, 0, true);
			controller.addTask(task);
			
		}
		
		/**
		 * Verify that when an item is added but not started, the 
		 * queued state is set and defined .
		 * 
		 */		
		public function testAddTaskTestQueued():void
		{
			controller.activeTaskLimit = 1; // set to one for this test
			var task:TestTask = new TestTask();
			task.addEventListener(TaskEvent.TASK_QUEUED, addAsync(handleTaskQueued, 100), false, 0, true);
			
			var blockerTask:TestTask = new TestTask();
			controller.addTask(blockerTask);
			controller.addTask(task);
		}
		
		/**
		 * Verify that adding a task that is not ready is added to 
		 * the controller, next() is called but the task is not run 
		 * yet is put in not ready queue.
		 * 
		 */
		public function testAddTaskNotReady():void
		{
			var task:TestTask = new TestTask(TestTask.NOT_READY);
			task.addEventListener(TaskEvent.TASK_WAITING_FOR_READY, addAsync(handleTaskInWaiting, 100), false, 0, true);
			controller.addTask(task);
		}
		
		/**
		 * Verify that adding a task that is not ready is put into the 
		 * task list then change the task to ready state and verify 
		 * it is started.
		 * 
		 */		
		public function testAddTaskChangeReady():void
		{
			var task:TestTask = new TestTask(TestTask.NOT_READY);
			task.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart, 500), false, 0, true);
			controller.addTask(task);
			task.triggerReady();
		}
		
		/**
		 * Verify that adding a task group will execute on item
		 */
		 public function testAddTaskGroupWithOneTask():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	
			task1.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
			taskGroup.addTask(task1);
			controller.addTask(taskGroup);
		 }
		 
		 /**
		 * Verify that adding a task group will execute two items
		 */
		 public function testAddTaskGroupWithTwoTask():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			// Listen to second task, verify it started
			task1.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
			
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);

			controller.addTask(taskGroup);
			task0.triggerComplete();
		 }
		 
		 public function testTaskGroupRemoveTask():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			// Listen to task, verify it was canceled after removed from group
			task0.addEventListener(TaskEvent.TASK_CANCEL, addAsync(handleTaskCanceled,500),false, 0,true);
			// Add task to group
			taskGroup.addTask(task0);
			// Add group to controller
			controller.addTask(taskGroup);
			// Remove task from group
			taskGroup.removeTask(task0);
			// Verify task is removed from group
			assertFalse("Task should be removed from group", taskGroup.getTaskIndex(task0) >= 0);
		 }
		 
		 /**
		 * Test verifies that removing an item from a group will still fire next item in queue
		 */ 
		 public function testTaskGroupRemoveTasks():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2:TestTaskPriority2 = new TestTaskPriority2();
		 			 	
			// Listen to task, verify it was canceled after removed from group
			task2.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
			// Add task to group
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			taskGroup.addTask(task2);			
			// Add group to controller
			controller.addTask(taskGroup);
			// Remove Second item
			taskGroup.removeTask(task1);
			// Mark first task as complete, third task should start
			task0.triggerComplete();
		 }
		 /**
		 * Test verifies TaskController's ability to handle Canceled Tasks
		 */
		 public function testTaskCancel():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2:TestTaskPriority2 = new TestTaskPriority2();
		 	
		 	// Verify third task starts,when second is canceled and first is completed
		 	task2.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
		 	
		 	// Add Three tasks to controller
		 	controller.addTask(task0);
		 	controller.addTask(task1);
		 	controller.addTask(task2);
		 	// Cancel second task in queue
		 	task1.cancel();
		 	// Fake complete
		 	task0.triggerComplete();
		 }
		 
		 /**
		 * Test verifies TaskController's ability to handle Canceled Tasks
		 */
		 public function testTaskGroupCancel():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP",0);
		 	
		 	var task0ToGroup:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1ToGroup:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2NotInGroup:TestTaskPriority2 = new TestTaskPriority2();
		 	
		 	// Add Two tasks to group
		 	taskGroup.addTask(task0ToGroup);
		 	taskGroup.addTask(task1ToGroup);
		 	
		 	// Add Group controller
		 	controller.addTask(taskGroup);
		 	// Add task to controller
		 	controller.addTask(task2NotInGroup);
		 	
		 	// Verify third task starts,when group is canceled
		 	task2NotInGroup.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
		 	
		 	// Cancel group
		 	taskGroup.cancel();
		 }
		 public function testGroupInQueue():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP",0);
		 	var taskGroupQueued:TaskGroup = new TaskGroup("Another",0);
		 	
		 	var task0ToGroup:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1ToGroup:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2InGroup2:TestTaskPriority2 = new TestTaskPriority2();
		 	
		 	// Add Two tasks to group
		 	taskGroup.addTask(task0ToGroup);
		 	taskGroup.addTask(task1ToGroup);
		 	// Add one task to second group
		 	taskGroupQueued.addTask(task2InGroup2);
		 	// Verify group is marked as InQueue
		 	taskGroupQueued.addEventListener(TaskEvent.TASK_QUEUED, addAsync(handleTaskQueued,500),false, 0,true);
		 	// Add Group controller
		 	controller.addTask(taskGroup);
		 	controller.addTask(taskGroupQueued);
		 }
		 
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the same type and Id. New Group should not be added
		 */
		 public function testTaskGroupOverrideWithSameTypesSameId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var taskGroup:TaskGroup = new TaskGroup("SAME_GROUP", 0, 00000, true);
		 	var taskGroupIgnore:TaskGroup = new TaskGroup("SAME_GROUP", 0, 00000, true);
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	
		 	// Add a task to each group
		 	taskGroup.addTask(task0);
		 	taskGroupIgnore.addTask(task1);
		 	
		 	// Verify  second group is ignored since both groups have same id and uid
		 	taskGroupIgnore.addEventListener(TaskEvent.TASK_IGNORED, addAsync(handleTaskIgnore, 500),false,0,true);
		 	// Add both groups to controller
		 	controller.addTask(taskGroup);
		 	controller.addTask(taskGroupIgnore);
		 }
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the same type and differnt Ids
		 */
		 public function testTaskGroupOverrideWithSameTypeDifferentId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var taskGroup1:TaskGroup = new TaskGroup("SAME_GROUP", 0, 00000, true);
		 	var taskGroup2:TaskGroup = new TaskGroup("SAME_GROUP", 0, 99999, true);
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	
		 	// Add a task to each group
		 	taskGroup1.addTask(task0);
		 	taskGroup2.addTask(task1);
		 	
		 	// Add both groups to controller
		 	controller.addTask(taskGroup1);
		 	controller.addTask(taskGroup2);
			
			// Verify  First task group is complete and second is started
			assertTrue("First Task Group should be complete", taskGroup1.phase == TaskEvent.TASK_COMPLETE);
			assertTrue("Second Task Group should be started", taskGroup2.phase == TaskEvent.TASK_START);
		 }
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the different type and s Ids
		 */
		 public function testTaskGroupOverrideWithDifferentTypesSameId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var taskGroup1:TaskGroup = new TaskGroup("GROUP_1", 0, 00000, true);
		 	var taskGroup2:TaskGroup = new TaskGroup("GrOUP_2", 0, 00000, true);
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	
		 	// Add a task to each group
		 	taskGroup1.addTask(task0);
		 	taskGroup2.addTask(task1);
		 	
		 	// Add both groups to controller
		 	controller.addTask(taskGroup1);
		 	controller.addTask(taskGroup2);
			
			// Verfiy first task is started and second is queued
			assertTrue("First Task Group should be started", taskGroup1.phase == TaskEvent.TASK_START);
			assertTrue("Second Task Group should be queued", taskGroup2.phase == TaskEvent.TASK_QUEUED);
		 }
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the different type and differnt Ids
		 */
		 public function testTaskGroupOverrideWithDifferentTypesDifferentId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var taskGroup1:TaskGroup = new TaskGroup("GROUP_1", 0, 00000, true);
		 	var taskGroup2:TaskGroup = new TaskGroup("GrOUP_2", 0, 99999, true);
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	
		 	// Add a task to each group
		 	taskGroup1.addTask(task0);
		 	taskGroup2.addTask(task1);
		 	
		 	// Add both groups to controller
		 	controller.addTask(taskGroup1);
		 	controller.addTask(taskGroup2);
			
			// Verfiy first task is started and second is queued
			assertTrue("First Task Group should be started", taskGroup1.phase == TaskEvent.TASK_START);
			assertTrue("Second Task Group should be queued", taskGroup2.phase == TaskEvent.TASK_QUEUED);
		 }
		 
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the same type and Id. New task should not be added
		 */
		 public function testTaskOverrideWithSameTypesSameId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var taskIgnore:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	
		 	// Add both tasks to controller
		 	controller.addTask(task1);
		 	controller.addTask(taskIgnore);
		 	
		 	// Verify second task is ignored since both tasks have same id and uid
		 	taskIgnore.addEventListener(TaskEvent.TASK_IGNORED, addAsync(handleTaskIgnore, 500),false,0,true);
		 	
		 	// Add both tasks to controller
		 	controller.addTask(task1);
		 	controller.addTask(taskIgnore);
		 }
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the same type and differnt Ids
		 */
		 public function testTaskOverrideWithSameTypeDifferentId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var task2:ITask = new AbstractTask("SAME_TYPE", 0, 99999,true);
		 	
		 	// Add both tasks to controller
		 	controller.addTask(task1);
		 	controller.addTask(task2);
			
			// Verify  First task is canceled and second is started
			assertTrue("First Task should be canceled", task1.phase == TaskEvent.TASK_CANCEL);
			assertTrue("Second Task should be started", task2.phase == TaskEvent.TASK_START);
		 }
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the different type and s Ids
		 */
		 public function testTaskOverrideWithDifferentTypesSameId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var task2:ITask = new AbstractTask("DIFFERNT_TYPE", 0, 11111,true);
		 	
		 	// Add both tasks to controller
		 	controller.addTask(task1);
		 	controller.addTask(task2);
			
			// Verfiy first task is started and second is queued
			assertTrue("First Task should be started", task1.phase == TaskEvent.TASK_START);
			assertTrue("Second Task should be queued", task2.phase == TaskEvent.TASK_QUEUED);
		 }
		 /**
		 * Test verifies the override capabilities of a Task
		 * when both tasks are of the different type and differnt Ids
		 */
		 public function testTaskOverrideWithDifferentTypesDifferentId():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var task1:ITask = new AbstractTask("SAME_TYPE", 0, 11111,true);
		 	var task2:ITask = new AbstractTask("DIFFERNT_TYPE", 0, 99999,true);
		 	
		 	// Add both tasks to controller
		 	controller.addTask(task1);
		 	controller.addTask(task2);
			
			// Verfiy first task is started and second is queued
			assertTrue("First Task should be started", task1.phase == TaskEvent.TASK_START);
			assertTrue("Second Task should be queued", task2.phase == TaskEvent.TASK_QUEUED);
		 }
		 
		 public function testTaskError():void {
		 	controller.activeTaskLimit = 1; // set to one for this test
		 	var task1:TestTask = new TestTask();
		 	var task2:TestTask = new TestTask();
		 	
			// Add tasks to controller
			controller.addTask(task1);
			controller.addTask(task2);
			
			// Trigger error
			task1.triggerError();
			
			// Verify first task has errored and second has started in queue
			assertTrue("First task should be errored", task1.phase == TaskEvent.TASK_ERROR);		 
			assertTrue("Second task should be started", task2.phase == TaskEvent.TASK_START);
		 }
		 
		 /**
		  * This test verifies that adding a blocking task does block
		  * any other task that are added to the queue.  The default queue count
		  * is two concurrent items so this test should verify that the concurrent
		  * items are held empty until complete. 
		  * 
		  */
		 public function testTaskBlocking():void {
		 	var blockingTask:TestTask = new TestTask(TestTask.BLOCKING_TASK);
		 	var task1:TestTask = new TestTask();
		 	var task2:TestTask = new TestTask();
		 	
		 	// add the task
		 	controller.addTask(blockingTask);
		 	controller.addTask(task1);
		 	controller.addTask(task2);
		 	
		 	// verify that task1 one is queued and not started
		 	assertTrue("Task1 phase was not set to queued.", task1.phase == TaskEvent.TASK_QUEUED);
		 	assertTrue("Task2 phase was not set to queued.", task2.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// complete the blocker and make sure 1 and two are active.
		 	blockingTask.triggerComplete();
		 	assertTrue("Task1 phase was not set to start.", task1.phase == TaskEvent.TASK_START);
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 }
		 
		 /**
		  * verify that having more then one current item works for the queue. 
		  * 
		  */
		 public function testConcurrentItemsComplete():void {
		 	var task1:TestTask = new TestTask();
		 	var task2:TestTask = new TestTask();
		 	var task3:TestTask = new TestTask();
		 	var task4:TestTask = new TestTask();
		 	
		 	// add the tasks
		 	controller.addTask(task1);
		 	controller.addTask(task2);
		 	controller.addTask(task3);
		 	controller.addTask(task4);
		 	
		 	// make sure the first two are active and the last two are not
		 	assertTrue("Task1 phase was not set to start.", task1.phase == TaskEvent.TASK_START);
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to queued.", task3.phase == TaskEvent.TASK_QUEUED);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// complete the first task
		 	task1.triggerComplete();
		 	
		 	// verify that 2 and 3 are active and 4 is not
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// complete the second task
		 	task2.triggerComplete();
		 	
		 	// verify that 3 and 4 are active
		 	assertTrue("Task4 phase was not set to start.", task4.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		 }
		 
		 /**
		  * verify that having more then one current item works for the queue with errors 
		  * 
		  */
		 public function testConcurrentItemsError():void {
		 	var task1:TestTask = new TestTask();
		 	var task2:TestTask = new TestTask();
		 	var task3:TestTask = new TestTask();
		 	var task4:TestTask = new TestTask();
		 	
		 	// add the tasks
		 	controller.addTask(task1);
		 	controller.addTask(task2);
		 	controller.addTask(task3);
		 	controller.addTask(task4);
		 	
		 	// make sure the first two are active and the last two are not
		 	assertTrue("Task1 phase was not set to start.", task1.phase == TaskEvent.TASK_START);
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to queued.", task3.phase == TaskEvent.TASK_QUEUED);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// error the first task
		 	task1.triggerError();
		 	
		 	// verify that 2 and 3 are active and 4 is not
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// error the second task
		 	task2.triggerError();
		 	
		 	// verify that 3 and 4 are active
		 	assertTrue("Task4 phase was not set to start.", task4.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		 }
		 
		 /**
		  * verify that having more then one current item works for the queue with cancel 
		  * 
		  */
		 public function testConcurrentItemsCancel():void {
		 	var task1:TestTask = new TestTask();
		 	var task2:TestTask = new TestTask();
		 	var task3:TestTask = new TestTask();
		 	var task4:TestTask = new TestTask();
		 	
		 	// add the tasks
		 	controller.addTask(task1);
		 	controller.addTask(task2);
		 	controller.addTask(task3);
		 	controller.addTask(task4);
		 	
		 	// make sure the first two are active and the last two are not
		 	assertTrue("Task1 phase was not set to start.", task1.phase == TaskEvent.TASK_START);
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to queued.", task3.phase == TaskEvent.TASK_QUEUED);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// cancel the first task
		 	task1.triggerCancel();
		 	
		 	// verify that 2 and 3 are active and 4 is not
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// error the second task
		 	task2.triggerCancel();
		 	
		 	// verify that 3 and 4 are active
		 	assertTrue("Task4 phase was not set to start.", task4.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		 }
		 
		/**
		 * Verify that groups work with concurrent calls. 
		 * 
		 */
		public function testConcurrentWithGroup():void {
			var group:TaskGroup = new TaskGroup("test");
			var task1:TestTask = new TestTask();
		 	var task2:TestTask = new TestTask();
		 	var task3:TestTask = new TestTask();
		 	var task4:TestTask = new TestTask();
		 	
		 	// add 1 - 3 to group
		 	group.addTask(task1);
			group.addTask(task2);
			group.addTask(task3);
			
			// add group and 4 to controller
			controller.addTask(group);
			controller.addTask(task4);
			
			// make sure the first two are active and the last two are not
		 	assertTrue("Task1 phase was not set to start.", task1.phase == TaskEvent.TASK_START);
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to queued.", task3.phase == TaskEvent.TASK_QUEUED);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// complete the first task
		 	task1.triggerComplete();
		 	
		 	// verify that 2 and 3 are active and 4 is not
		 	assertTrue("Task2 phase was not set to start.", task2.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		 	assertTrue("Task4 phase was not set to queued.", task4.phase == TaskEvent.TASK_QUEUED);
		 	
		 	// complete the second task
		 	task2.triggerComplete();
		 	
		 	// verify that 3 and 4 are active
		 	assertTrue("Task4 phase was not set to start.", task4.phase == TaskEvent.TASK_START);
		 	assertTrue("Task3 phase was not set to start.", task3.phase == TaskEvent.TASK_START);
		}		
		 
		 
		public function testTaskGroupTaskPriority():void {
			var taskGroup:TaskGroup = new TaskGroup("BLAH", 3);
			
			var groupTask1:TestTask = new TestTask();
			var groupTask2:TestTask = new TestTask();
			var groupTask3:TestTask = new TestTask();
			
			var taskHighPriority:TestTask = new TestTaskPriority1();
			
			
			taskGroup.addTask(groupTask1);
			taskGroup.addTask(groupTask2);
			taskGroup.addTask(groupTask3);
			
			controller.addTask(taskGroup);
			controller.addTask(taskHighPriority);
			
			
			groupTask1.triggerComplete();	
			groupTask2.triggerComplete();
			
			assertTrue("Third group task should have started", groupTask3.phase == TaskEvent.TASK_START);
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