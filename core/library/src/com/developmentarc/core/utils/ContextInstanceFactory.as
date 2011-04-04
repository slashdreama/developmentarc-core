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
package com.developmentarc.core.utils
{
	import com.developmentarc.core.datastructures.utils.HashTable;

	/**
	 * Class is a utility to allow for developers to create a single instance of a Class based on
	 * a string based context. Users can pass in a key word that multiple classes can use when the need
	 * is to share a single instance but is not a singleton.
	 *  
	 * @author Aaron Pedersen
	 * 
	 */	
	public class ContextInstanceFactory
	{
		/**
		 * @private
		 * The static instance of the class. 
		 */
		static protected var __instance:ContextInstanceFactory;
		
		protected var __contextTable:HashTable;
		
		/**
		 * Method returns an instance of the specified type that is with in the 
		 * provided context.
		 *  
		 * @param type A class reference
		 * @param context A string used as an unique key.
		 * 
		 * @return Instance of the specified type. 
		 * 
		 */		
		public static function getContextInstance(type:Class, context:String):* {
			var instanceFactory:InstanceFactory = InstanceFactory(instance.__contextTable.getItem(context));
			
			if(!instanceFactory) {
				instanceFactory = new InstanceFactory();
				
				instance.__contextTable.addItem(context, instanceFactory);
			}
				
			return instanceFactory.getInstance(type);
	
		}
		
		/**
		 * Method removes the current instance of the specified type within the provided context.
		 *  
		 * @param type A class reference
		 * @param context A string used as a unique key
		 * 
		 */		
		public static function clearContextInstance(type:Class, context:String):void {
			var instanceFactory:InstanceFactory = InstanceFactory(instance.__contextTable.getItem(context));
			
			if(instanceFactory) {
				instanceFactory.clearInstance(type);	
			}
		}
		
		/**
		 * Method clears all instances in the specified context.
		 *  
		 * @param context A string used as an unique key.
		 * 
		 */		
		public static function clearAllInstancesInContext(context:String):void {
			var instanceFactory:InstanceFactory = InstanceFactory(instance.__contextTable.getItem(context));
			
			if(instanceFactory) {
				instanceFactory.clearAllInstances();	
			}
		}
		
		/**
		 * Method clears all instnaces across all contexts. 
		 * 
		 */		
		public static function clearAllInstance():void {
			var instanceFactories:Array = instance.__contextTable.getAllItems();
			
			
			for each (var instanceFactory:InstanceFactory in instanceFactories) {
				instanceFactory.clearAllInstances();	
			}
		}
		
		
		/**
		 * Returns the current instance of the SingletonFactory.
		 * 
		 * @return Current instance of the factory.
		 * 
		 */
		static protected function get instance():ContextInstanceFactory
		{
			if(!__instance) __instance = new ContextInstanceFactory(SingletonLock);
			return __instance;
		}
		
		/**
		 * Enables extended Classes to access the lock.
		 *  
		 * @return The lock Class.
		 * 
		 */
		static protected function get lock():Class
		{
			return ContextInstanceFactory;
		}
		
		/**
		 * Constructor -- DO NOT CALL.
		 * @private 
		 * @param lock
		 * 
		 */
		public function ContextInstanceFactory(lock:Class)
		{
			super();
			
			// only extendend classes can call the instance directly
			if(!lock is SingletonLock) throw new Error("Invalid use of ContextInstanceFactory constructor, do not call directly.", 9001);
			
			__contextTable = new HashTable();
		}
		
	}
}

class SingletonLock
{
	public function SingletonLock() {}
}