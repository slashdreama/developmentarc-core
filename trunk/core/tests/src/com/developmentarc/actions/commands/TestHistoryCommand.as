package com.developmentarc.actions.commands
{
	import com.developmentarc.core.actions.commands.AbstractHistoryCommand;

	public class TestHistoryCommand extends AbstractHistoryCommand
	{
		
		public static const TYPE_FIRST:String = "firstCommandType";
		public static const TYPE_SECOND:String = "secondCommandType";
		public static const TYPE_THIRD:String = "thirdCommandType";
		
		public function TestHistoryCommand(type:String)
		{
			super(type);
		}
		
	}
}