package com.developmentarc.libtests.elements.service
{
	import com.developmentarc.core.services.events.DispatcherEvent;
	
	import flash.events.Event;
	
	import mx.rpc.events.FaultEvent;
	
	public class FaultMockDispatcher extends MockDispatcher
	{
		public function FaultMockDispatcher()
		{
			super();
			this.eventType = DispatcherEvent.FAULT;
		}
		/**
		 * Method mocks a FaultEvent to test AbstactMockDispatcher's fault functionality
		 */
		override public function createFaultEvent():Event {
			var faultEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT);
			
			return faultEvent;
		}
	}
}