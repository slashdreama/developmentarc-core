package com.developmentarc.libtests.elements.tasks
{
	import com.developmentarc.core.actions.actions.AbstractAction;

	public class TestTaskPriority0 extends TestTask
	{
		public static const TYPE:String = "Priority_zero";
		public static const PRIORITY:int = 0;
		
		public function TestTaskPriority0(type:String="", priority:int=5)
		{
			super(TestTaskPriority2.TYPE, TestTaskPriority0.PRIORITY);
		}
		
	}
}