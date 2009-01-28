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
package com.developmentarc.libtests.tests
{
	import com.developmentarc.framework.utils.AdjustableDate;
	
	import flexunit.framework.TestCase;

	public class AdjustableDateTests extends TestCase
	{
		public function AdjustableDateTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * This test verifies that the day offset works in both postitive
		 * and negative values as expected. 
		 * 
		 */
		public function testOffsetDays():void
		{
			var baseDate:Date = new Date(2008, 8, 5);
			var adjustDate:AdjustableDate = new AdjustableDate(2008, 8, 5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the date back to the first of the month
			adjustDate.offsetDays(-4);
			assertTrue("The date was not adjusted back four days.", adjustDate.date == 1);
			
			// adjust the date to the 5th
			adjustDate.offsetDays(4);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the date to August 31st
			adjustDate.offsetDays(-5);
			assertTrue("The date was not set to the 31st.", adjustDate.date == 31);
			
			// verify zero does not affect the date
			adjustDate.offsetDays(0);
			assertTrue("The date was changed when it should not have been.", adjustDate.date == 31);
		}
		
		/**
		 * Tests the Months offset functionality, verifying that it spans months
		 * and years correctly. 
		 * 
		 */
		public function testOffsetMonths():void
		{
			var baseDate:Date = new Date(2008, 8, 5);
			var adjustDate:AdjustableDate = new AdjustableDate(2008, 8, 5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the month back to august 8th
			adjustDate.offsetMonths(-1);
			assertTrue("The date was not adjusted back one month.", adjustDate.month == 7);
			assertTrue("The date's day was changed incorrectly.", adjustDate.date == 5);
			
			// adjust the month back to february 8th
			adjustDate.offsetMonths(-6);
			assertTrue("The date was not adjusted back six months.", adjustDate.month == 1);
			assertTrue("The date's day was changed incorrectly for 6 months.", adjustDate.date == 5);
			
			// adjust the month back to start
			adjustDate.offsetMonths(7);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the month across previous year
			adjustDate.offsetMonths(-10);
			assertTrue("The date was not adjusted back 10 months.", adjustDate.month == 10);
			assertTrue("The date's day was changed incorrectly for 10 months.", adjustDate.date == 5);
			assertTrue("The date's year was changed incorrectly for 10 months.", adjustDate.fullYear == 2007);
			
			adjustDate.offsetMonths(10);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the month across the next year
			adjustDate.offsetMonths(12);
			assertTrue("The date was not adjusted back 10 months.", adjustDate.month == 8);
			assertTrue("The date's day was changed incorrectly for 10 months.", adjustDate.date == 5);
			assertTrue("The date's year was changed incorrectly for 10 months.", adjustDate.fullYear == 2009);
			
			adjustDate.offsetMonths(-12);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// update the dates to a 31st.  verify that it updates the month correctly
			baseDate = new Date(2008, 0, 31);
			adjustDate = new AdjustableDate(2008, 0, 31);
			
			// adjust the month to to february 31st, make sure it becomes the 29th
			adjustDate.offsetMonths(1);
			assertTrue("The date was not adjusted forward 1 month.", adjustDate.month == 1);
			assertTrue("The date was not adjusted to fit the leap year.", adjustDate.date == 29);
			
			// update the dates to a 31st.  verify that it updates the month correctly
			baseDate = new Date(2008, 2, 31);
			adjustDate = new AdjustableDate(2008, 2, 31);
			
			// adjust the month to to April 31st, make sure it becomes the 30th
			adjustDate.offsetMonths(1);
			assertTrue("The date was not adjusted back forward one month.", adjustDate.month == 3);
			assertTrue("The date was not changed to the 30th.", adjustDate.date == 30);
		}
		
		
		/**
		 * Verify that adjusting the year modifies the date year properly. 
		 * 
		 */
		public function testAdjustYears():void
		{
			var baseDate:Date = new Date(2008, 8, 5);
			var adjustDate:AdjustableDate = new AdjustableDate(2008, 8, 5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the date by 5 years backwards
			adjustDate.offsetYears(-5);
			assertTrue("The date was not adjusted back 5 years.", adjustDate.month == 8);
			assertTrue("The date's day was changed incorrectly for 5 years.", adjustDate.date == 5);
			assertTrue("The date's year was changed incorrectly for 5 years.", adjustDate.fullYear == 2003);
			
			adjustDate.offsetYears(5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
		}
		
		/**
		 * Verifies that the different construction options for the AdjustableDate
		 * meet the same options as the date class that it is wrapping. 
		 * 
		 */
		public function testConstructorArguments():void {
			// create a date with no arguments
			var now:Date = new Date();
			var adjustDate:AdjustableDate = new AdjustableDate();
			
			// we can't compare milliseconds, but check the rest
			assertTrue("The year did not match.", adjustDate.dateInstance.fullYear == now.fullYear);
			assertTrue("The month did not match.", adjustDate.dateInstance.month == now.month);
			assertTrue("The date did not match.", adjustDate.dateInstance.date == now.date);
			assertTrue("The hours did not match.", adjustDate.dateInstance.hours == now.hours);
			assertTrue("The minute did not match.", adjustDate.dateInstance.minutes == now.minutes);
			assertTrue("The seconds did not match.", adjustDate.dateInstance.seconds == now.seconds);
			
			// create using a date object
			adjustDate = new AdjustableDate(now.time);
			
			// verify the dates are the same
			assertTrue("Dates are not the same from date object creation.", now.time == adjustDate.dateInstance.time);
			
			// create using a month and year
			now = new Date(2008, 1);
			adjustDate = new AdjustableDate(2008, 1);
			
			// verify the dates are the same
			assertTrue("Dates are not the same from using a month to create.", now.time == adjustDate.dateInstance.time);
		}
		
		/**
		 * This test is responible for testing all the proxy methods
		 * that have been set on the AdjustableDate to reflect the internal
		 * instance. 
		 * 
		 */
		public function testProxyMethods():void {
			var inst:AdjustableDate;
			
			// test date set/get
			inst = new AdjustableDate();
			assertTrue("The internal date is different then the proxy value for date.", inst.date == inst.dateInstance.date);
			inst.date = 1;
			assertTrue("The internal date was not update through the date proxy method.", inst.dateInstance.date == 1);
			
			// test the dateUTC set/get
			inst = new AdjustableDate();
			assertTrue("The internal dateUTC is different then the proxy value for dateUTC.", inst.dateUTC == inst.dateInstance.dateUTC);
			inst.dateUTC = 1;
			assertTrue("The internal dateUTC was not update through the dateUTC proxy method.", inst.dateInstance.dateUTC == 1);
			
			// test the day and dayUTC get
			inst = new AdjustableDate();
			assertTrue("The internal day is different then the proxy value for day.", inst.day == inst.dateInstance.day);
			assertTrue("The internal dayUTC is different then the proxy value for dayUTC.", inst.dayUTC == inst.dateInstance.dayUTC);
			
			// test fullYear set/get
			inst = new AdjustableDate();
			assertTrue("The internal fullYear is different then the proxy value for fullYear.", inst.fullYear == inst.dateInstance.fullYear);
			inst.fullYear = 2000;
			assertTrue("The internal fullYear was not update through the fullYear proxy method.", inst.dateInstance.fullYear == 2000);
			
			// test fullYearUTC set/get
			inst = new AdjustableDate();
			assertTrue("The internal fullYearUTC is different then the proxy value for fullYearUTC.", inst.fullYearUTC == inst.dateInstance.fullYearUTC);
			inst.fullYearUTC = 2000;
			assertTrue("The internal fullYearUTC was not update through the fullYearUTC proxy method.", inst.dateInstance.fullYearUTC == 2000);
			
			// test hours set/get
			inst = new AdjustableDate();
			assertTrue("The internal hours is different then the proxy value for hours.", inst.hours == inst.dateInstance.hours);
			inst.hours = 1;
			assertTrue("The internal hours was not update through the hours proxy method.", inst.dateInstance.hours == 1);
			
			// test hoursUTC set/get
			inst = new AdjustableDate();
			assertTrue("The internal hoursUTC is different then the proxy value for hoursUTC.", inst.hoursUTC == inst.dateInstance.hoursUTC);
			inst.hoursUTC = 1;
			assertTrue("The internal hoursUTC was not update through the hoursUTC proxy method.", inst.dateInstance.hoursUTC == 1);
			
			// test milliseconds set/get
			inst = new AdjustableDate();
			assertTrue("The internal milliseconds is different then the proxy value for milliseconds.", inst.milliseconds == inst.dateInstance.milliseconds);
			inst.milliseconds = 100;
			assertTrue("The internal milliseconds was not update through the milliseconds proxy method.", inst.dateInstance.milliseconds == 100);
			
			// test millisecondsUTC set/get
			inst = new AdjustableDate();
			assertTrue("The internal millisecondsUTC is different then the proxy value for millisecondsUTC.", inst.millisecondsUTC == inst.dateInstance.millisecondsUTC);
			inst.millisecondsUTC = 100;
			assertTrue("The internal millisecondsUTC was not update through the millisecondsUTC proxy method.", inst.dateInstance.millisecondsUTC == 100);
			
			// test minutes set/get
			inst = new AdjustableDate();
			assertTrue("The internal minutes is different then the proxy value for minutes.", inst.minutes == inst.dateInstance.minutes);
			inst.minutes = 5;
			assertTrue("The internal minutes was not update through the minutes proxy method.", inst.dateInstance.minutes == 5);
			
			// test minutesUTC set/get
			inst = new AdjustableDate();
			assertTrue("The internal minutesUTC is different then the proxy value for minutesUTC.", inst.minutesUTC == inst.dateInstance.minutesUTC);
			inst.minutesUTC = 5;
			assertTrue("The internal minutesUTC was not update through the minutesUTC proxy method.", inst.dateInstance.minutesUTC == 5);
			
			// test month set/get
			inst = new AdjustableDate();
			assertTrue("The internal month is different then the proxy value for month.", inst.month == inst.dateInstance.month);
			inst.month = 5;
			assertTrue("The internal month was not update through the month proxy method.", inst.dateInstance.month == 5);
			
			// test monthUTC set/get
			inst = new AdjustableDate();
			assertTrue("The internal monthUTC is different then the proxy value for minutesUTC.", inst.monthUTC == inst.dateInstance.monthUTC);
			inst.monthUTC = 5;
			assertTrue("The internal monthUTC was not update through the minutesUTC proxy method.", inst.dateInstance.monthUTC == 5);
			
			// test seconds set/get
			inst = new AdjustableDate();
			assertTrue("The internal seconds is different then the proxy value for seconds.", inst.seconds == inst.dateInstance.seconds);
			inst.seconds = 5;
			assertTrue("The internal seconds was not update through the month seconds method.", inst.dateInstance.seconds == 5);
			
			// test secondsUTC set/get
			inst = new AdjustableDate();
			assertTrue("The internal secondsUTC is different then the proxy value for secondsUTC.", inst.secondsUTC == inst.dateInstance.secondsUTC);
			inst.secondsUTC = 5;
			assertTrue("The internal secondsUTC was not update through the secondsUTC proxy method.", inst.dateInstance.secondsUTC == 5);
			
			// test time
			inst = new AdjustableDate();
			var now:Date = new Date(2008, 1, 1);
			assertTrue("The internal time is different then the proxy value for time.", inst.time == inst.dateInstance.time);
			inst.time = now.time;
			assertTrue("The internal time was not update through the time proxy method.", inst.dateInstance.time == now.time);
			
			// test timezoneOffset 
			inst = new AdjustableDate();
			assertTrue("The internal timezoneOffset is different then the proxy value for timezoneOffset.", inst.timezoneOffset == inst.dateInstance.timezoneOffset);
			
			// test string methods
			inst = new AdjustableDate();
			assertTrue("The internal toDateString() is different then the proxy value for toDateString().", inst.toDateString() == inst.dateInstance.toDateString());
			assertTrue("The internal toLocaleString() is different then the proxy value for toLocaleString().", inst.toLocaleString() == inst.dateInstance.toLocaleString());
			assertTrue("The internal toLocaleDateString() is different then the proxy value for toLocaleDateString().", inst.toLocaleDateString() == inst.dateInstance.toLocaleDateString());
			assertTrue("The internal toLocaleTimeString() is different then the proxy value for toLocaleTimeString().", inst.toLocaleTimeString() == inst.dateInstance.toLocaleTimeString());
			assertTrue("The internal toString() is different then the proxy value for toString().", inst.toString() == inst.dateInstance.toString());
			assertTrue("The internal toTimeString() is different then the proxy value for toTimeString().", inst.toTimeString() == inst.dateInstance.toTimeString());
			assertTrue("The internal toUTCString() is different then the proxy value for toUTCString().", inst.toUTCString() == inst.dateInstance.toUTCString());
		}
	}
}