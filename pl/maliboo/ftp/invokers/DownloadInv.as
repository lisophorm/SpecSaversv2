package pl.maliboo.ftp.invokers
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import pl.maliboo.ftp.Commands;
	import pl.maliboo.ftp.FTPCommand;
	import pl.maliboo.ftp.Responses;
	import pl.maliboo.ftp.core.FTPClient;
	import pl.maliboo.ftp.core.FTPInvoker;
	import pl.maliboo.ftp.errors.InvokeError;
	import pl.maliboo.ftp.events.FTPEvent;
	import pl.maliboo.ftp.utils.PassiveSocketInfo;

	public class DownloadInv extends FTPInvoker
	{
		
		private var remoteFile:String;
		private var localFile:String;
		
		private var targetFile:FileStream;
		private var fileMode:String;
		private var passiveSocket:Socket;
		
		private var bytes:int=0;
		private var bytesTotal:int=0;
		
		public function DownloadInv(client:FTPClient, remoteFile:String, 
										localFile:String, fileMode:String=FileMode.WRITE)
		{
			super(client);
			this.remoteFile = remoteFile;
			this.localFile = localFile;			
			targetFile = new FileStream();
			this.fileMode = fileMode;
		}
		
		override protected function startSequence ():void
		{
			targetFile.open(new File(localFile), fileMode);
			sendCommand(new FTPCommand(Commands.BINARY));
		}
		
		override protected function responseHandler(evt:FTPEvent):void
		{
			switch (evt.response.code)
			{
				case Responses.COMMAND_OK:
					sendCommand(new FTPCommand(Commands.PASV));
					break;
				case Responses.ENTERING_PASV:
					passiveSocket = PassiveSocketInfo.createPassiveSocket(evt.response.message,
																			handleConnect,
																			handleData);
					break;
				case Responses.DATA_CONN_CLOSE:
					targetFile.close();
					var downloadEvent:FTPEvent = new FTPEvent(FTPEvent.DOWNLOAD);
					downloadEvent.bytesTotal = bytesTotal;
					downloadEvent.file = localFile;
					release(downloadEvent);
					break;
				case Responses.FILE_STATUS_OK:
					bytesTotal = parseTotalBytes(evt.response.message);
					break
				case Responses.NOT_FOUND:
					throw new Error("File not found!");
				default:
					releaseWithError(new InvokeError(evt.response.message));
			}	
		}
		
		private function handleConnect (evt:Event):void
		{
			sendCommand(new FTPCommand(Commands.RETR, remoteFile));
		}
		
		private function handleData (evt:ProgressEvent):void
		{
			bytes += passiveSocket.bytesAvailable;

			var bytesArr:ByteArray = new ByteArray();
			passiveSocket.readBytes(bytesArr, 0, passiveSocket.bytesAvailable);
			targetFile.writeBytes(bytesArr, 0, bytesArr.bytesAvailable);
			
			var progressEvent:FTPEvent = new FTPEvent(FTPEvent.PROGRESS);
			progressEvent.bytesTotal = bytesTotal;
			progressEvent.bytes = bytes;
			progressEvent.file = localFile;
			client.dispatchEvent(progressEvent);
		}
		
		private function parseTotalBytes (response:String):int
		{
			return parseInt(response.match(/\d+/)[0]);
		}
		
		override protected function cleanUp ():void
		{
		}
		
	}
}