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
package com.developmentarc.framework.controllers
{
	import com.developmentarc.framework.controllers.events.TaskEvent;
	import com.developmentarc.framework.controllers.interfaces.ITask;
	import com.developmentarc.framework.controllers.interfaces.ITaskGroup;
	import com.developmentarc.framework.datastructures.utils.HashTable;
	import com.developmentarc.framework.datastructures.utils.PriorityQueue;
	
	import flash.events.EventDispatcher;

	public class TaskController extends EventDispatcher
	{
		protected var taskQueue:PriorityQueue;
		protected var activeTasks:HashTable;
		protected var notReadyQueue:HashTable;
		
		private var __activeTaskLimit:uint = 2;
		private var __isBlocked:Boolean = false;
		
		public function TaskController()
		{
			super(this);
			
			taskQueue = new PriorityQueue();
			activeTasks = new HashTable();
			notReadyQueue = new HashTable();
		}
		
		public function set activeTaskLimit(value:uint):void
		{
			__activeTaskLimit = value;
		}
		
		public function get activeTaskLimit():uint
		{
			return __activeTaskLimit;
		}
		
		public function addTask(task:ITask):void
		{
			// apply overrides
			// if overrides dont override this task add task
			if(applyOverrides(task)) { 
			
				// determine priority and placement
				task.inQueue();
				taskQueue.addItem(task, task.priority);
			}
			else {
				// Trigger Ignore on task
				task.ignore();
			}
			// call next, to check queue state
			next();
		}
		
		/**
		 * <p>
		 * Used to find and remove any tasks in the current
		 * queue that are overriden by a new task that has been
		 * added to the controller. This includes those tasks that are active.
		 * </p>
		 * <p>
		 * If the new task is selfOverriding two scenarios will play out.
		 * 
		 * <ul>
		 * 	<li>If new task has same type and a different uid as a task in the queue or active queue the existing task is removed and canceled, the new task is then added to the queue.</li>
		 *  <li>If new task has same type and the same uid as a queued or active task, the new task is ignored and not added to they system.</li>
		 * </ul>
		 * </p>
		 * @param newTask New Task to be added to queue
		 * 
		 * @return Boolean True if newTasks overrides were processed,otherwise false
		 */
		protected function applyOverrides(newTask:ITask):Boolean
		{
			var overrides:Array = newTask.taskOverrides;
			
			//// no overrides and no not selfoverriding
			if(overrides.length < 1 && !newTask.selfOverride) return true; 
			
			// loop over and find all the matched type
			var newList:Array = new Array();
			var match:Boolean;
			
			var itemList:Array = taskQueue.items.concat(activeTasks.getAllKeys());
			
			// Handle self override 
			// Loop over all tasks looking for self override
			if(newTask.selfOverride) {
				match = false;
				for each(var task:ITask in itemList)
				{
					if(newTask.type == task.type) {
						// Already one in the queue with same type and uid, disregard new task
						if(newTask.uid == task.uid) {
							return false;
						}
						else {
							// Found a match, cancel it
							if(task is ITask) ITask(task).cancel();
							
						}
					}
					// Only add task that are not active
					else if(!activeTasks.containsKey(task)) {
						newList.push(task);
						match = true;
					}
				}	
			}
			// Set new itemList after removing selfoverrides, reset newList
			itemList = (match) ? newList : itemList;
			newList = new Array();
			
			var len:int = overrides.length;	
			// Task overrides - only if new task is not disregarded based on selfoverrides
			for each(task in itemList)
			{
				match = false;
				for(var i:uint = 0; i < len; i++) 
				{ 
					if(task.type == overrides[i]) 
					{
						// found a match, cancel it
						match == true; 
						// Cancel task		
						ITask(task).cancel();
					}
				}
				// Only add task that are not active
					if(!match && !activeTasks.containsKey(task)) {
						
						newList.push(task);
					}
			}
			// update to the stripped list
			
			var newTaskQueue:PriorityQueue = new PriorityQueue();
			
			for each(task in newList) {
				newTaskQueue.addItem(task, task.priority);
			}
			taskQueue = newTaskQueue;
			
			return true;
		}
		
		protected function next():void
		{
			// make sure we have tasks, if not exit
			if(__isBlocked || !taskQueue.hasItems) return;
			
			// see if we can handle a new task
			if(activeTasks.length < __activeTaskLimit)
			{
				// we need to take action, first check ready queue then go to task queue
				var nextTask:ITask = ITask(taskQueue.peek());
				
				// If nextTask is canceled pop from queue
				if(nextTask.phase == TaskEvent.TASK_CANCEL) {
					taskQueue.next();
					// Recursion, call this method again for next item
					this.next();
					return;
				}
				// determine if it is a task or task base
				var task:ITask;
				if(nextTask is ITaskGroup)
				{
					// If no more tasks are in the group,pop group from queue
					// and call next and return;
					if(!ITaskGroup(nextTask).hasTask) { 
						taskQueue.next();
						this.next();	
						return;
					}
					
					// Mark group as in queue
					if(nextTask.phase != TaskEvent.TASK_START) {
						nextTask.start();
					}
					
					task = ITaskGroup(nextTask).next();
					
					
				} else {
					task = ITask(taskQueue.next());
				}
				
				
				// determine if the tasks are ready
				if(task.ready)
				{
					// determine if the task is blocking, is so set up the block
					__isBlocked = task.isBlocker;
					
					// start the task and add it to the active task list
					task.addEventListener(TaskEvent.TASK_COMPLETE, handleTaskEvent);
					task.addEventListener(TaskEvent.TASK_CANCEL, handleTaskEvent);
					task.addEventListener(TaskEvent.TASK_ERROR, handleTaskEvent);
					activeTasks.addItem(task, true);
					task.start();
					// see if we can add more tasks
					if(activeTasks.length < __activeTaskLimit) next();
				} else {
					// the task is not ready, add to the not ready queue
					task.addEventListener(TaskEvent.TASK_READY, handleTaskEvent);
					notReadyQueue.addItem(task, true);
					task.inWaitingForReady();
					next();
				}
			}
		}
		
		protected function handleTaskEvent(event:TaskEvent):void
		{
			var task:ITask = ITask(event.currentTarget);
			
			switch(event.type)
			{
				case TaskEvent.TASK_CANCEL:
				case TaskEvent.TASK_COMPLETE:
				case TaskEvent.TASK_ERROR:
					// remove from the active queue
					activeTasks.remove(task);
					task.removeEventListener(TaskEvent.TASK_COMPLETE, handleTaskEvent);
					task.removeEventListener(TaskEvent.TASK_CANCEL, handleTaskEvent);
					task.removeEventListener(TaskEvent.TASK_ERROR, handleTaskEvent);
					
					// unblock, if the task is a blocker
					if(task.isBlocker) __isBlocked = false;
					
					next();
				break;
				
				case TaskEvent.TASK_READY:
					// remove from the not ready task, add to the front of the line and call next
					notReadyQueue.remove(task);
					task.removeEventListener(TaskEvent.TASK_READY, handleTaskEvent);
					taskQueue.addItem(task, 1); // set to one to override all but zero
					next();
				break;
			}
		}
		
	}
}