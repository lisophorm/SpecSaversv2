package pl.maliboo.ftp.invokers
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import pl.maliboo.ftp.Commands;
	import pl.maliboo.ftp.core.FTPClient;
	import pl.maliboo.ftp.FTPCommand;
	import pl.maliboo.ftp.core.FTPInvoker;
	import pl.maliboo.ftp.Responses;
	import pl.maliboo.ftp.errors.InvokeError;
	import pl.maliboo.ftp.events.FTPEvent;
	import pl.maliboo.ftp.utils.PassiveSocketInfo;

	public class UploadInv extends FTPInvoker
	{
		private var localFile:String;
		private var remoteFile:String;
		
		private var sourceFile:FileStream;
		private var fileMode:String;
		private var passiveSocket:Socket;
		
		private var bytesTotal:int=0;
		private var bufferSize:uint = 4096;
		
		private var interval:uint;
		
		private var startTime:int;
		
		public function UploadInv(client:FTPClient, localFile:String, remoteFile:String)
		{
			super(client);
			this.localFile = localFile;
			this.remoteFile = remoteFile;
			sourceFile = new FileStream();
		}
		
		override protected function startSequence ():void
		{
			sourceFile.open(new File(localFile), FileMode.READ);
			trace("File has: "+sourceFile.bytesAvailable+" bytes");
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
																			handleData,
																			handleIOErr,
																			handleClose);
					break;
				case Responses.DATA_CONN_CLOSE:
					sourceFile.close();
					trace(getTimer()+" ACK/"+(getTimer()-startTime))
					//passiveSocket.close();
					var downloadEvent:FTPEvent = new FTPEvent(FTPEvent.UPLOAD);
					downloadEvent.bytesTotal = bytesTotal;
					downloadEvent.file = remoteFile;
					downloadEvent.time = getTimer() - startTime;
					release(downloadEvent);
					break;
				case Responses.FILE_STATUS_OK:
					startSendingData();
					break
				case Responses.NOT_FOUND:
					throw new Error("File not found!");
				default:
					sourceFile.close(); //TODO: wspolny cleanup?!
					passiveSocket.close();
					releaseWithError(new InvokeError(evt.response.message));
			}	
		}
		
		override protected function cleanUp ():void
		{
		}
		
		private function handleConnect (evt:Event):void
		{
			sendCommand(new FTPCommand(Commands.STOR, remoteFile));
		}
		
		private function handleIOErr(evt:IOErrorEvent):void
		{
			trace("err")
		}
		
		private function handleClose(evt:Event):void
		{
			trace(getTimer()+" Real socket close")
		}
		
		private function handleData (evt:ProgressEvent):void
		{
			trace("Upload SocketData")
		}
		
		private function handleProgress (evt:ProgressEvent):void
		{
			trace("Progress");
		}
		
		private function startSendingData():void
		{
			trace(getTimer()+" Start sending data! ("+passiveSocket.connected+")");
			startTime = getTimer();
			interval = setInterval(sendData, 300);
			//sendBlockData();
		}
		/*
		private function sendBlockData ():void
		{
			var ba:ByteArray = new ByteArray();
			sourceFile.readBytes(ba, bytes, Math.min(bufferSize, sourceFile.bytesAvailable - bytes));
			bytes += bufferSize;
			bufferSize = Math.min(bufferSize, sourceFile.bytesAvailable - bytes);
			
			passiveSocket.writeBytes(ba, 0, ba.bytesAvailable);
			passiveSocket.flush();
			
		}
		*/
		private function sendData():void
		{
			
			if (sourceFile.bytesAvailable <= 0)
			{
				clearInterval(interval);
				passiveSocket.close();
				trace(getTimer()+" SocketClose :"+passiveSocket.connected)
				return;
			}
			
			var ba:ByteArray = new ByteArray();
			sourceFile.readBytes(ba, 0, bufferSize);
			trace(getTimer()+" Bytes to read: "+ba.bytesAvailable+"/"+sourceFile.bytesAvailable)
			passiveSocket.writeBytes(ba, 0, ba.bytesAvailable);
			passiveSocket.flush();
			if (sourceFile.bytesAvailable < bufferSize)
				bufferSize = sourceFile.bytesAvailable;
		}
	}
}