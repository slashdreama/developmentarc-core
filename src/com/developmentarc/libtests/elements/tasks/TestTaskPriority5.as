package com.developmentarc.libtests.elements.tasks
{
	import com.developmentarc.core.actions.actions.AbstractAction;

	public class TestTaskPriority5 extends TestTask
	{
		public static const TYPE:String = "Priority_five";
		public static const PRIORITY:int = 5;
		
		public function TestTaskPriority5(type:String="", priority:int=5)
		{
			super(TestTaskPriority5.TYPE, TestTaskPriority5.PRIORITY);
		}	
		
	}
}