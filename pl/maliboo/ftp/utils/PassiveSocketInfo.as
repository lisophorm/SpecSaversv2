package pl.maliboo.ftp.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	public final class PassiveSocketInfo
	{
		public var host:String;
		public var port:int;
		public function PassiveSocketInfo (host:String, port:int)
		{
			this.host = host;
			this.port = port
		}
		//TODO:Zabezpieczyc przed bledami...
		public static function parseFromResponse (pasvResponse:String):PassiveSocketInfo
		{
			var match:Array = pasvResponse.match(/(\d{1,3},){5}\d{1,3}/);
			if (match == null)
				throw new Error("Error parsing passive port! (Response: "+pasvResponse+")");
			var data:Array = match[0].split(",");
			var host:String = data.slice(0,4).join(".");
			var port:int = parseInt(data[4])*256+parseInt(data[5]);
			return new PassiveSocketInfo(host, port);
		}
		
		public static function createPassiveSocket 
											(pasvRessponse:String, 
											connectHandler:Function = null,
											dataHandler:Function 	= null,
											ioErrorHandler:Function = null,
											closeHandler:Function 	= null):Socket
		{
			var info:PassiveSocketInfo = parseFromResponse(pasvRessponse);
			var socket:Socket = new Socket();
			if (connectHandler != null)
				socket.addEventListener(Event.CONNECT, connectHandler);
			if (dataHandler != null)
				socket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
			if (ioErrorHandler != null)
				socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			if (closeHandler != null)
				socket.addEventListener(Event.CLOSE, closeHandler);
			socket.connect(info.host, info.port);
			return socket;						
		}
	}
}