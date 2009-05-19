package com.developmentarc.core.actions.commands
{
	import com.developmentarc.core.actions.commands.AbstractHistoryCommand;

	public class HistoryCommand extends AbstractHistoryCommand
	{
		
		public static const UNDO:String = "undoCommand";
		public static const REDO:String = "redoCommand";
		
		public function HistoryCommand(type:String)
		{
			super(type);
		}
		
	}
}