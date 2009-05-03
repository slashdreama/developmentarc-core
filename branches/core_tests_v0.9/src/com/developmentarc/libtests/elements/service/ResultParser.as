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
package com.developmentarc.libtests.elements.service
{
	import com.developmentarc.core.services.parsers.AbstractParser;

	/**
	 * Use class to mimmic a successful parsing of data from the request.
	 * Parser will return a TaskDO with the data from the incoming data.
	 */
	public class ResultParser extends AbstractParser
	{
		public function ResultParser()
		{
			super(AbstractParser.RESULT_FORMAT_E4X);
		}
		
		/**
		 * Method parses supplied data into a TaskDO.
		 */
		override public function parse(data:*):* {
			var task:TaskDO = new TaskDO();
			
			if(data) {
				task.name = data.name || "";
				task.description = data.description || "";
				task.completed = data.completed || false;
			}
			return task;
		}
		
	}
}