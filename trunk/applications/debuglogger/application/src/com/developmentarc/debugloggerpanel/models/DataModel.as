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
package com.developmentarc.debugloggerpanel.models
{
	import flash.events.EventDispatcher;
	
	import mx.resources.ResourceManager;

	public class DataModel extends EventDispatcher
	{
		/* STATIC CONSTANTS */
		static public const MESSAGE_INFO:String = "MESSAGE_INFO";
		static public const MESSAGE_ERROR:String = "MESSAGE_ERROR";
		
		/* STATIC PROPERTIES */
		static protected var inst:DataModel;
		
		/* STATIC METHODS */
		/**
		 * The instance method returns the current Singleton instance
		 * of the DataModel.  When binding to data always access the
		 * data through the provided DataModel instance from this getter.
		 * 
		 * @return The current Singletin DataModel instance.
		 * 
		 */
		static public function get instance():DataModel
		{
			if(!inst) inst = new DataModel(SingletonLock);
			return inst;
		}
		
		/**
		 * Stores the lock that enables children classes to extend
		 * the base DataModel Singleton structure.
		 *  
		 * @return Singleton lock for construction.
		 * 
		 */
		static protected function get lock():Class
		{
			return SingletonLock;
		}
		
		/* PUBLIC PROPERTIES */
		/**
		  * Store the consule user information text.
		  */	
		[Bindable] public var consuleText:String = "";
		
		/* CLASS METHODS */
		/**
		 * Constructor - DO NOT CALL.
		 * @private 
		 * @param lock
		 * 
		 */		
		public function DataModel(lock:Class)
		{
			super(this);
			
			// determine if the lock was provided correctly
			if(!(lock == SingletonLock)) throw new Error(ResourceManager.getInstance().getString('errors', 'invalid_singleton'));
		}
		
		public function addConsuleText(message:String, type:String = DataModel.MESSAGE_INFO):void
		{
			switch(type)
			{
				case MESSAGE_ERROR:
					consuleText += "<font color='#990000'>"+message+"</font><br/>"
				break;
				
				default:
					consuleText += "<font color='#009900'>"+message+"</font><br/>"
			}
		}
		
	}
}

class SingletonLock
{
	public function SingletonLock()
	{
		
	}
}