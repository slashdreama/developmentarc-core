package com.developmentarc.actions.commands
{
	import com.developmentarc.core.actions.commands.AbstractHistoryCommand;

	public class TestNoHistoryCommand extends AbstractHistoryCommand
	{
		public static const TYPE_NO_HISTORY:String = "noHistoryCommand";
		
		public function TestNoHistoryCommand(type:String, useHistory:Boolean=true)
		{
			super(type, false);
		}
	}
}