package com.developmentarc.libtests.elements
{
	import com.developmentarc.framework.utils.BrowserLocationUtil;

	/**
	 * Class is used to modify the test url inside of BrowserLocationUtil so we can test various
	 * url use cases
	 */
	public class TestBrowserLocationUtil extends BrowserLocationUtil
	{
		
		public function TestBrowserLocationUtil()
		{
			super();
		}
		
		public static function set url(url:String):void {
			_testURL = url;
		}
		
		
	}
}