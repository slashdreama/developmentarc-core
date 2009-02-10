package com.developmentarc.debugloggerpanel.dataobjects
{
	import com.developmentarc.framework.utils.LocalConnectionManager;
	
	import flash.events.EventDispatcher;

	public class ConnectionDO extends EventDispatcher
	{
		public var id:String;
		public var connection:LocalConnectionManager;
		public var name:String;
		public var active:Boolean = true;
		
		public function ConnectionDO()
		{
			super(this);
		}
		
	}
}