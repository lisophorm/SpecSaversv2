package com.alfo
{
	import flash.display.Sprite;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	

	
	public class CleverUrlMonitor extends Sprite
	{
		public var idleTime:Number=30000;
		
		public var checkStatus:Timer;
		
		public var available:Boolean=true;
		
		private var checkingService:HTTPService;
		
		private var currentURL:String;
		private var isRunning:Boolean=false;
		
		public function CleverUrlMonitor(theUrl:String)
		{
			super();
			checkStatus=new Timer(idleTime);
			checkStatus.addEventListener(TimerEvent.TIMER,checkNetwork);
			checkingService=new HTTPService();
			checkingService.requestTimeout=10;
			checkingService.addEventListener(ResultEvent.RESULT,ok);
			checkingService.addEventListener(FaultEvent.FAULT,ko);
			currentURL=theUrl;
		}
		private function ok(e:ResultEvent) {
			available=true;
			var stato:StatusEvent=new StatusEvent(StatusEvent.STATUS);
			dispatchEvent(stato);
		
		}
		private function ko(e:FaultEvent) {
			available=false;
			var stato:StatusEvent=new StatusEvent(StatusEvent.STATUS);
			dispatchEvent(stato);
		}
		private function checkNetwork(e:TimerEvent=null) {
			checkingService.url=currentURL+"?gino="+Math.random().toString();
			checkingService.send();
		}
		public function start() {
			checkStatus=new Timer(idleTime);
			checkStatus.addEventListener(TimerEvent.TIMER,checkNetwork);
			checkStatus.start();
		}
		public function stop() {
			checkStatus.stop();
		}
		public function checkIt() {
			checkNetwork();
		}
	}
}