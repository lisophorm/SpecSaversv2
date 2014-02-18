package pl.maliboo.ftp.events
{
	import flash.events.Event;
	
	import pl.maliboo.ftp.FTPCommand;
	import pl.maliboo.ftp.FTPResponse;
	import pl.maliboo.ftp.errors.FTPError;

	public class FTPEvent extends Event
	{
		//public static const :String = "";
		public static const CONNECTED:String 	= "connected";
		public static const DISCONNECTED:String = "disconnected";
		public static const LOGGED:String 		= "logged"
		public static const COMMAND:String 		= "command";
		public static const CHANGE_DIR:String 	= "changeDir";
		public static const CREATE_DIR:String 	= "createDir";
		public static const DELETE_DIR:String 	= "deleteDir";
		public static const DELETE_FILE:String 	= "deleteFile";
		public static const DOWNLOAD:String 	= "download";
		public static const LISTING:String 		= "listing";
		public static const PROGRESS:String 	= "progress";
		public static const RENAME_FILE:String 	= "renameFile";
		public static const RESPONSE:String 	= "response";
		public static const UPLOAD:String 		= "upload";
		public static const INVOKE_ERROR:String = "invokeError";
		
		
		public var error:FTPError;
		public var hostname:String;
		public var command:FTPCommand;
		public var response:FTPResponse;
		public var path:String;
		public var directory:String;
		public var file:String;
		public var bytes:int;
		public var bytesTotal:int;
		public var date:Date;
		public var listing:Array; /*of FTPFile*/
		public var time:int;
		
		public function FTPEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var evt:FTPEvent = new FTPEvent(type, bubbles, cancelable);
			evt.hostname = hostname;
			evt.command = command;
			evt.response = response;
			evt.path = path;
			evt.directory = directory;
			evt.file = file;
			evt.bytes = bytes;
			evt.bytesTotal = bytesTotal;
			evt.date = date;
			evt.listing = listing;
			evt.error = error;
			evt.time = time;
			return evt as Event;
		}
	}
}