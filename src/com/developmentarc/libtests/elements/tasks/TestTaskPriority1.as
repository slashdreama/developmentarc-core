package com.developmentarc.libtests.elements.tasks
{
	import com.developmentarc.framework.controllers.abstracts.AbstractTask;

	public class TestTaskPriority1 extends TestTask
	{
		public static const TYPE:String = "Priority_one";
		public static const PRIORITY:int = 0;
		
		public function TestTaskPriority1(type:String="", priority:int=5)
		{
			super(TestTaskPriority1.TYPE, TestTaskPriority1.PRIORITY);
		}
		
	}
}