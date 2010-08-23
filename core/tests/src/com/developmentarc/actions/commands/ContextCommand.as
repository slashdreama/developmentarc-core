package com.developmentarc.actions.commands
{
	import com.developmentarc.core.actions.commands.HistoryCommand;
	
	public class ContextCommand extends HistoryCommand
	{
		static public const BASIC_CONTEXT:String = "basicContext";
		
		public var value:String;
		
		public function ContextCommand(type:String, value:String)
		{
			super(type);
			this.value = value;
		}
	}
}