package com.alfo
{
	import air.net.URLMonitor;
	
	import flash.net.URLRequest;
	
	public class ExtendedUrlMonitor extends URLMonitor
	{
		public function ExtendedUrlMonitor(urlRequest:URLRequest, acceptableStatusCodes:Array=null)
		{
			super(urlRequest, acceptableStatusCodes);
		}
		public function checkIt() {
			checkStatus();
		}
	}
}