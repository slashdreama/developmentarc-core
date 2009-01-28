package com.developmentarc.libtests.tests
{
	import com.developmentarc.framework.utils.BrowserLocationUtil;
	import com.developmentarc.libtests.elements.TestBrowserLocationUtil;
	
	import flexunit.framework.TestCase;

	public class BrowserLocationUtilTest extends TestCase
	{
		
		public function BrowserLocationUtilTest(methodName:String=null)
		{
			super(methodName);
		}
		public function testBrowserProtocalHTTP():void {
			// Test local file system
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com/Users/aaronpedersen/Documents/eclipse_workspaces/firstEchelon/Sandbox_URL_Parameters/bin-debug/UrlUtilityExample.html'
			
			assertTrue("Protocal should be http", BrowserLocationUtil.protocal == 'http');
		}
		
		public function testBrowserProtocalHTTPS():void {
			// Test local file system
			TestBrowserLocationUtil.url = 'https://www.developmentarc.com/path/too/application/index.html?param1=value1&param';

			assertTrue("Protocal should be https", BrowserLocationUtil.protocal == 'https');
		} 
		
		public function testBrowserProtocalLocalFileSystem():void {
			// Test local file system
			TestBrowserLocationUtil.url = 'file://www.developmentarc.com/path/too/application/index.html?param1=value1&param';

			assertTrue("Protocal should be file", BrowserLocationUtil.protocal == 'file');
		} 
				
		public function testBrowserServerNameLocalFileSystem():void {
			TestBrowserLocationUtil.url = 'file://localhost/Users/devarc/Documents/eclipse_workspaces/devarc/Sandbox_URL_Parameters/bin-debug/UrlUtilityExample.html';
			
			assertTrue("Server Name should be localhost", BrowserLocationUtil.serverName == 'localhost');
		}
		
		 public function testBrowserServerNameLocahost():void {
			TestBrowserLocationUtil.url = 'http://localhost';
			
			assertTrue("Server Name should be localhost", BrowserLocationUtil.serverName == 'localhost');
		}
		
		public function testBrowserServerNameWWW():void {
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com';
			
			assertTrue("Server Name should be www.developmentarc.com", BrowserLocationUtil.serverName == 'www.developmentarc.com');
		}
		
		public function testBrowserServerNameSubDomain():void {
			TestBrowserLocationUtil.url = 'http://www.subdomain.developmentarc.com';
			
			assertTrue("Server Name should be www.subdomain.developmentarc.com", BrowserLocationUtil.serverName == 'www.subdomain.developmentarc.com');
		}
		
		public function testNoPort():void {
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com';
			
			assertTrue("Port should be 0", BrowserLocationUtil.port == 0);
		}
		
		public function testPort80():void {
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com:80/path/is/here?param1=value1#fragment';
			
			assertTrue("Port should be 80", BrowserLocationUtil.port == 80);
		}

		public function testBadPort():void {
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com:AAA';

			assertTrue("Port should be 0", BrowserLocationUtil.port == 0);
		}
		
		public function testPathWithoutFile():void {
			var testPath:String = '/path/with/out/file/';
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com' + testPath;
			
			assertTrue("Path should be '" + testPath + "'", BrowserLocationUtil.path == testPath);
		}
		public function testPathAsRoot():void {
			var testPath:String = '/';
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com' + testPath;			

			assertTrue("Path should be '" + testPath + "'", BrowserLocationUtil.path == '/');
		}
		public function testPathWithFile():void {
			var testPath:String = '/path/with/file.html';
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com' + testPath;		

			assertTrue("Path should be '" + testPath + "'", BrowserLocationUtil.path == testPath);
		}
		
		public function testPathWithAction():void {
			var testPath:String = '/path/with/action.do';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com' + testPath;	

			assertTrue("Path should be '" + testPath + "'", BrowserLocationUtil.path == testPath);
		} 
		public function testPathWithFullUrl():void {
			var testPath:String = '/path/with/full/url.html';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com' + testPath + '?param1=value1&parm2=value2#book_marking_is_easy';	

			assertTrue("Path should be '" + testPath + "'", BrowserLocationUtil.path == testPath);
		}
		
		
		public function testWithoutQuery():void {
			var testQuery:String = '';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com' + testQuery;	

			assertTrue("Query should be '" + testQuery + "'", BrowserLocationUtil.query == testQuery);			
		}
		public function testBasicWithQuery():void {
			var testQuery:String = 'param1=value1&param2=value2';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com?' + testQuery;	
			
			assertTrue("Query should be '" + testQuery + "'", BrowserLocationUtil.query == testQuery);			
		}
		public function testFullURLWithQuery():void {
			var testQuery:String = 'param1=value1&param2=value2';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com:8080/paths/are/great.jsp?' + testQuery + '#fragments_are_cool';	

			var query:String = BrowserLocationUtil.query;
			assertTrue("Query should be '" + testQuery + "'", BrowserLocationUtil.query == testQuery);			
		}
		
		public function testWithoutParameters():void {
			var testQuery:String = '';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com?' + testQuery;
			
			var parameters:Object = BrowserLocationUtil.parameters;
			
			var hasProperties:Boolean;
			for(var prop:String in parameters) {
				hasProperties = true;
			}	
			
			assertFalse("URL should have no parameters", hasProperties);
		}
		
		public function testWithOneParameter():void {
			var testQuery:String = 'param1=value1';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com?' + testQuery;
			
			var parameters:Object = BrowserLocationUtil.parameters;
			
			assertTrue("Url has property 'param1' with value of 'value1'", parameters.param1 == 'value1');
		}
		
		public function testWithTwoParameters():void {
			var testQuery:String = 'param1=value1&param2=value2';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com?' + testQuery;
			
			var parameters:Object = BrowserLocationUtil.parameters;

			assertTrue("Url has property 'param1' with value of 'value1'", parameters.param1 == 'value1');
			assertTrue("Url has property 'param2' with value of 'value2'", parameters.param2 == 'value2');			
		}
		
		public function testWithDuplicateParameters():void {
			var testQuery:String = 'param1=firstValue&param2=value2&param1=secondValue';			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com?' + testQuery;
			
			var parameters:Object = BrowserLocationUtil.parameters;

			assertTrue("Url has property 'param1' with value of 'secondValue'", parameters.param1 == 'secondValue');
			assertTrue("Url has property 'param2' with value of 'value2'", parameters.param2 == 'value2');
		}
		
		public function testWithTwoPrametersFullURL():void {
			var testQuery:String = 'param1=value1&param2=value2';		
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com:8080/paths/are/great.jsp?' + testQuery + '#fragments_are_cool';
			
			var parameters:Object = BrowserLocationUtil.parameters;
		
			assertTrue("Url has property 'param1' with value of 'value1'", parameters.param1 == 'value1');
			assertTrue("Url has property 'param2' with value of 'value2'", parameters.param2 == 'value2');
		}
		
		public function testWithoutFragment():void {
			var testFragment:String = '';
			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com#' + testFragment;
			
			assertTrue("Url has no fragment", BrowserLocationUtil.fragment == "");
		}
		
		public function testWithSimpleFragment():void {
			var testFragment:String = 'fragment';
			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com#' + testFragment;
			
			assertTrue("Url fragment is'" + testFragment + "'", BrowserLocationUtil.fragment == testFragment);
		}
		
		public function testWithComplexFragment():void {
			var testFragment:String = 'fragment_fragment with space';
			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com#' + testFragment;
			
			assertTrue("Url fragment is'" + testFragment + "'", BrowserLocationUtil.fragment == testFragment);
		}
		
		public function testFragmentWithFullURL():void {
			var testFragment:String = 'fragment_fragment';
			
			TestBrowserLocationUtil.url = 'http://www.developmentarc.com:8080/paths/are/great.jsp?param1=value1&param2=value2#'+ testFragment;
			
			assertTrue("Url fragment is'" + testFragment + "'", BrowserLocationUtil.fragment == testFragment);
		
		}
		
	}
}