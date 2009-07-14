package com.developmentarc.libtests.elements.datamapping
{
	import com.developmentarc.core.datastructures.mapping.DataMap;
	import com.developmentarc.core.datastructures.mapping.MapDataWrapper;
	
	import flash.events.EventDispatcher;

	public class MapItemOne extends EventDispatcher
	{
		public var targetOne:*;
		public var targetTwo:*;
		
		public var wrapperType:String;
		public var wrapperData:*;
		public var wrapperParams:Object;
		
		public function MapItemOne()
		{
			super(this);
			DataMap.registerClient(this);
		}
		
		public function set data(value:MapDataWrapper):void {
			wrapperType = value.type;
			wrapperData = value.data;
			wrapperParams = value.parameters;
		}
		
	}
}