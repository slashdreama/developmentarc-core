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
package com.developmentarc.flexunit
{
	import flash.utils.describeType;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * The TestUtils class is a helper utility designed for developing FlexUnit
	 * testing suites.  The methods on the utility are static and are intendend
	 * to speed up development and similify management of tests suites.
	 *  
	 * @author James Polanco
	 * 
	 */
	public class TestUtils
	{
		/**
		 * This method provides an automated way to generate TestSuites from a
		 * TestCase Class that follows the "test" prefix naming standard. The method
		 * uses the type description of the provided Class to determine the public
		 * methods that are avaliable.  The method then searches for all methods
		 * that start with "test", all lower case, and assumes this is a valid
		 * test method for the TestCase. A new TestCase is generated the class instance
		 * passing in the found method as a test method.  This TestCase is then added
		 * to the Suite which is handed back to the caller once all the TestCases have
		 * been found and generated.
		 * 
		 * @param classReference TestCase Class to generate a TestSuite from.
		 * @return The generated TestSuite with all the "test" methods appended.
		 * 
		 */
		static public function generateFullSuite(classReference:Class):TestSuite
		{
			var suite:TestSuite = new TestSuite();
			
			// pull all the public functions that start with test
			var self:XML = describeType(classReference);
			var methods:XMLList = self.factory.method;
			for each(var method:XML in methods)
			{
				var name:String = method.@name;
				if(name.indexOf("test") == 0)
				{
					suite.addTest(new classReference(name));
				}
			}
			
			return suite;
		}
	}
}