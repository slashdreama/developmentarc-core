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
package com.developmentarc.core.datastructures.mapping
{
	/**
	 * A Data Structure used to provide more details/information about
	 * the data being pushed to a client.  This enables finer business logic
	 * such as the ability to define exactly what data is being updated/changed
	 * so that any subscriber can make the proper calculations to display or handle
	 * the data set.
	 *  
	 * @author James Polanco
	 * 
	 */
	public class MapDataWrapper
	{
		/**
		 * The Type assigned to the data push. 
		 */
		public var type:String;
		/**
		 * The data being pushed. 
		 */
		public var data:*;
		/**
		 * option object used to mark up the data. 
		 */
		public var parameters:Object;
		
		/**
		 * Constructor. 
		 * @param type The type of data.
		 * @param data The data.
		 * @param parameters The parameters for the data.
		 * 
		 */
		public function MapDataWrapper(type:String, data:*, parameters:Object)
		{
			this.type = type;
			this.data = data;
			this.parameters = parameters;
		}

	}
}