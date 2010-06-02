/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2009 DevelopmentArc LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * ***** END MIT LICENSE BLOCK ***** */
package com.developmentarc.debugloggerpanel
{
	import com.developmentarc.airutils.WindowApplicationManager;
	import com.developmentarc.core.datastructures.utils.HashTable;
	import com.developmentarc.core.utils.LocalConnectionManager;
	import com.developmentarc.core.utils.events.LocalConnectionEvent;
	import com.developmentarc.core.utils.logging.DebugLogger;
	import com.developmentarc.core.utils.logging.DebugMessage;
	import com.developmentarc.debugloggerpanel.dataobjects.ConnectionDO;
	import com.developmentarc.debugloggerpanel.models.DataModel;
	
	import flash.desktop.InteractiveIcon;
	import flash.display.Bitmap;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.CheckBox;
	import mx.controls.ComboBox;
	import mx.controls.DataGrid;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.WindowedApplication;
	import mx.formatters.DateFormatter;

	/**
	 * The DebugLoggerWindowedApplication is the backing Application class for
	 * the DebugLogger AIR Panel. 
	 * 
	 * @author James Polanco
	 * 
	 */
	public class DebugLoggerWindowedApplication extends WindowedApplication
	{
		public var debugMessages:Array;
		public var maxMessages:int = 1000;
		
		/* PUBLIC PROPERTIES */
		[Bindable] public var messageFilterTypes:ArrayCollection;
		[Bindable] public var filteredMessageList:ArrayCollection;
		
		/* PUBLIC COMPONENTS */
		[Bindable] public var status_field:TextArea;
		[Bindable] public var filter_list:ComboBox;
		[Bindable] public var cache_message_toggle:CheckBox;
		[Bindable] public var search_text:TextInput;
		[Bindable] public var message_text:TextArea;
		[Bindable] public var message_list:DataGrid;
		[Bindable] public var toggle_text_button:Button;
		
		/* PROTECTED PROPERTIES */
		protected var connection:LocalConnectionManager;
		protected var model:DataModel;
		protected var dateFormatter:DateFormatter;
		
		/* PRIVATE PROPERTES */
		private var _connected:Boolean = false;
		private var _currentConnectedApps:HashTable;
		private var _windowManager:WindowApplicationManager;
		
		public function DebugLoggerWindowedApplication()
		{
			super();
			construct();
		}
		
		protected function construct():void {
			_windowManager = new WindowApplicationManager(this, "com.developmentarc.debugloggerpanel");
			debugMessages = new Array();
			filteredMessageList = new ArrayCollection();
			_currentConnectedApps = new HashTable();
			model = DataModel.instance;
			defineFilters();
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = "J:NN:SS";
		}
		
		protected function defineFilters():void
		{
			// define filters
			messageFilterTypes = new ArrayCollection();
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_all'), value: DebugMessage.INFO});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_debug'), value: DebugMessage.DEBUG});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_warn'), value: DebugMessage.WARN});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_error'), value: DebugMessage.ERROR});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_fatal'), value: DebugMessage.FATAL});
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			model.addConsuleText(resourceManager.getString('strings', 'console_connection_waiting'));
			connection = new LocalConnectionManager(this, DebugLogger.DEBUG_LOGGER_SUBSCRIBER);
			
			// register events
			connection.addEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleConnectionEvent);
			connection.addEventListener(LocalConnectionEvent.SENT_MESSAGE_ERROR, handleConnectionEvent);
			connection.addEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleConnectionEvent);
			
			var msg:DebugMessage = new DebugMessage("creation", DebugMessage.HANDSHAKE);
			connection.sendMessage(DebugLogger.DEBUG_LOGGER_BROADCASTER, "messageHandshake", msg);
			
		}
		
		private var _lastCount:uint = 0;
		
		public function debugMessageSent(msg:DebugMessage):void
		{
			if(!_connected)
			{
				_connected = true;
				model.addConsuleText(resourceManager.getString('strings', 'console_connection_made'));
			}
			
			// add item to the list
			if(debugMessages.length >= maxMessages) debugMessages.shift();
			debugMessages.push(msg);
			
			// add to filter if required
			var level:Number = filter_list.selectedItem.value;
			if(msg.type >= level)
			{
				if(cache_message_toggle && cache_message_toggle.selected)
				{
					if(filteredMessageList.length >= maxMessages) filteredMessageList.removeItemAt(0);
					filteredMessageList.addItem(msg);
					message_text.text += generateMessageString(msg);
				} else if(msg.type != DebugMessage.SYSTEM_MESSAGE) {
					if(filteredMessageList.length >= maxMessages) filteredMessageList.removeItemAt(0);
					filteredMessageList.addItem(msg);
					message_text.text += generateMessageString(msg);
				}
				
			}
		}
		
		public function connectToClient(msg:DebugMessage):void
		{
			switch(msg.type)
			{
				case DebugMessage.HANDSHAKE:
					// look at the id, and see if we have established a connection yet.
					// if we have this is a bad thing.
					if(_currentConnectedApps.containsKey(msg.id))
					{
						// we have already established a connection
						model.addConsuleText(resourceManager.getString('errors', 'console_reconnection'), DataModel.MESSAGE_ERROR);
					} else {
						// we have a new app, setup the tabs
						newAppConnected(msg.id);
						
						// establish a unqiue connection
						var conn:ConnectionDO = new ConnectionDO();
						conn.id = DebugLogger.PANEL_PREFIX + msg.id;
						conn.name = msg.id;
						conn.connection = new LocalConnectionManager(this, conn.id);
						
						// add to the table
						_currentConnectedApps.addItem(msg.id, conn);
						
						// set up the connection
						conn.connection.addEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleConnectionEvent);
						conn.connection.addEventListener(LocalConnectionEvent.SENT_MESSAGE_ERROR, handleConnectionEvent);
						conn.connection.addEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleConnectionEvent);
						
						var outgoing:DebugMessage = new DebugMessage(conn.id, DebugMessage.HANDSHAKE);
						connection.sendMessage(DebugLogger.DEBUG_LOGGER_BROADCASTER, "establishPrivateConnection", outgoing);
					}
				break;
			}
		}
		
		private var _previousSearchLength:int;
		
		public function searchText():void {
			if(search_text.length >= 3) {
				filterMessages();
			}
			
			if(_previousSearchLength >= 3 && search_text.length < 3) {
				filterMessages();
			}
			
			_previousSearchLength = search_text.length;
		}
		
		public function filterMessages():void
		{
			 var messages:ArrayCollection = buildFilterArray();
			 var searchString:String = search_text.text.toLowerCase();
			 var list:Array;
			 if(searchString.length >= 3) {
				 // filter out messages
				 var newList:ArrayCollection = new ArrayCollection();
				 list = messages.toArray();
				 for each(var item:DebugMessage in list) {
					 var msg:String = item.message.toLocaleLowerCase();
					 
					 if(msg.indexOf(searchString) != -1) {
						 // push this message
						 newList.addItem(item);
					 }
				 }
				 
				 messages = newList;
			 }
			 
			 filteredMessageList = messages;
			 
			 // print messages to text area
			 message_text.text = "";
			 list = filteredMessageList.toArray();
			 var len:int = list.length;
			 for(var i:uint = 0; i < len; i++) {
				 message_text.text += generateMessageString(DebugMessage(list[i]));
			 }
		}
		
		private var _showingText:Boolean = false;
		
		public function toggleUIDisplay():void {
			if(_showingText) {
				// show list
				message_list.visible = true;
				message_text.visible = false;
				message_list.includeInLayout = true;
				message_text.includeInLayout = false;
				toggle_text_button.label = resourceManager.getString('strings', 'ui_show_text');
				_showingText = false;
			} else {
				// show text
				message_list.visible = false;
				message_text.visible = true;
				message_list.includeInLayout = false;
				message_text.includeInLayout = true;
				_showingText = true;
				toggle_text_button.label = resourceManager.getString('strings', 'ui_show_list');
			}
		}
		
		protected function generateMessageString(message:DebugMessage):String {
			var out:String = dateFormatter.format(message.time) + "." + message.time.milliseconds + "\t\t" + message.message + "\t\t";
			if(message.className) out += message.className + "\t\t";
			if(message.methodName) out += message.methodName;
			out += "\r";
			return out;
		}
		
		protected function buildFilterArray():ArrayCollection {
			var level:Number = filter_list.selectedItem.value;
			var len:int = debugMessages.length;
			var filterArrary:ArrayCollection = new ArrayCollection();
			for(var i:uint; i < len; i++)
			{
				var msg:DebugMessage = DebugMessage(debugMessages[i]);
				if(msg.type >= level)
				{
					if(cache_message_toggle && cache_message_toggle.selected)
					{
						filterArrary.addItem(msg);	
					} else if(msg.type != DebugMessage.SYSTEM_MESSAGE) {
						filterArrary.addItem(msg);
					}
					
				}
			}
			return filterArrary;
		}
		
		protected function handleConnectionEvent(event:LocalConnectionEvent):void
		{
			switch(event.type)
			{
				case LocalConnectionEvent.CONNECTION_ERROR:
					model.addConsuleText(resourceManager.getString('errors', 'console_connection'), DataModel.MESSAGE_ERROR);
				break;
				
				case LocalConnectionEvent.SENT_MESSAGE_ERROR:
					var msg:String = resourceManager.getString('errors', 'console_sent_connection') + event.errorMessage;
					model.addConsuleText(msg, DataModel.MESSAGE_ERROR);
				break;
				
				case LocalConnectionEvent.STATUS_MESSAGE:
					if(event.status == "error")
					{
						if(_connected)
						{
							model.addConsuleText(resourceManager.getString('errors', 'console_unknow'), DataModel.MESSAGE_ERROR);
						}
					}
				break;
			}
		}
		
		protected function newAppConnected(id:String):void
		{
			// for now clear the queue
			filteredMessageList.removeAll();
			debugMessages = new Array();
			
			// remove all existing connections
			var connList:Array = _currentConnectedApps.getAllItems();
			for each(var conn:ConnectionDO in connList)
			{
				conn.connection.removeEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleConnectionEvent);
				conn.connection.removeEventListener(LocalConnectionEvent.SENT_MESSAGE_ERROR, handleConnectionEvent);
				conn.connection.removeEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleConnectionEvent);
				conn.connection.disconnect();
				model.addConsuleText(resourceManager.getString('strings', 'console_connection_end'), DataModel.MESSAGE_ERROR);
				_connected = false;
			}
			
			_currentConnectedApps.removeAll();
			
		}
	}
}