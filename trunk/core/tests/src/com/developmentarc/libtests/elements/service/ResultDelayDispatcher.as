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
	import com.developmentarc.core.services.events.DispatcherEvent;
	import com.developmentarc.core.services.parsers.IParser;
	import com.developmentarc.core.services.requests.IRequest;
	
	import flash.utils.setTimeout;

	/**
	 * Class is a dispatcher class that dispatches a successful event 
	 * after a delay of 5000 milliseconds.
	 */
	public class ResultDelayDispatcher extends TestDispatcher
	{
		public function ResultDelayDispatcher()
		{
			super();
			delay = 5000
			
		}
		
		override public function cancel(request:IRequest, key:*):void {
			// Nothing to do
		}
		/**
		 * Method dispatches a DispatcherEvent.RESULT event
		 */
		override protected function fireEvent(request:IRequest):void {
			var event:DispatcherEvent = new DispatcherEvent(DispatcherEvent.RESULT);
			event.uid = getUID(request);
			dispatchEvent(event);
		}
	}
}