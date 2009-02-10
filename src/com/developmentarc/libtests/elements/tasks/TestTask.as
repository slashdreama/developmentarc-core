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
package com.developmentarc.libtests.elements.tasks
{
	import com.developmentarc.framework.controllers.abstracts.AbstractTask;
	import com.developmentarc.framework.controllers.events.TaskEvent;

	public class TestTask extends AbstractTask
	{
		static public const BASIC_TASK:String = "BASIC_TASK";
		static public const NOT_READY:String = "NOT_READY";
		static public const BLOCKING_TASK:String = "BLOCKING_TASK";
		
		protected var isReady:Boolean = true;
		protected var isBlocked:Boolean = false;
		
		public function TestTask(type:String = BASIC_TASK, priority:int=5)
		{
			super(type,priority);
			
			switch(type)
			{
				case NOT_READY:
					isReady = false;
				break;
				
				case BLOCKING_TASK:
					isBlocked = true;
				break;
			}
		}
		
		override public function get ready():Boolean
		{
			return isReady;
		}
		
		override public function get isBlocker():Boolean {
			return isBlocked;
		}
		
		public function triggerComplete():void
		{
			complete();
		}
		
		public function triggerError():void
		{
			error();
		}
		
		public function triggerCancel():void
		{
			cancel();
		}
		
		public function triggerReady():void
		{
			isReady = true;
			dispatchEvent(new TaskEvent(TaskEvent.TASK_READY));
		}
		
	}
}