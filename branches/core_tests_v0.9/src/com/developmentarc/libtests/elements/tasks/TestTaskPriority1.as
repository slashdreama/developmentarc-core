package com.developmentarc.libtests.elements.tasks
{
	import com.developmentarc.core.actions.actions.AbstractAction;

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