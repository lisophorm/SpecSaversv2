package pl.maliboo.ftp.invokers
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	import pl.maliboo.ftp.Commands;
	import pl.maliboo.ftp.core.FTPClient;
	import pl.maliboo.ftp.FTPCommand;
	import pl.maliboo.ftp.FTPFile;
	import pl.maliboo.ftp.core.FTPInvoker;
	import pl.maliboo.ftp.Responses;
	import pl.maliboo.ftp.events.FTPEvent;
	import pl.maliboo.ftp.utils.PassiveSocketInfo;
	import pl.maliboo.ftp.errors.InvokeError;

	public class ListInv extends FTPInvoker
	{
		
		private var passiveSocket:Socket;
		private var listing:String;
		private var directory:String;
		
		public function ListInv(client:FTPClient, directory:String)
		{
			super(client);
			this.directory = directory;
			listing = "";
		}
		
		override protected function startSequence ():void
		{
			sendCommand(new FTPCommand(Commands.PASV));
		}
		
		override protected function responseHandler(evt:FTPEvent):void
		{
			switch (evt.response.code)
			{
				case Responses.ENTERING_PASV:
					passiveSocket =	PassiveSocketInfo.createPassiveSocket(evt.response.message,
																		handlePassiveConnect,
																		handleListing);
					break;
				case Responses.COMMAND_OK:
					sendCommand(new FTPCommand(Commands.LIST, directory));
					break;
				case Responses.DATA_CONN_CLOSE:
					var listEvt:FTPEvent = new FTPEvent(FTPEvent.LISTING);
					listEvt.listing = FTPFile.parseFormListing(listing, client.workingDirectory);
					release(listEvt);
					break;
				case Responses.FILE_STATUS_OK:
					break;
				default:
					releaseWithError(new InvokeError(evt.response.message));
			}
		}
		
		override protected function cleanUp ():void
		{
		}
		
		private function handlePassiveConnect (evt:Event):void
		{
			sendCommand(new FTPCommand(Commands.LIST, directory));
		}
		
		private function handleListing (evt:ProgressEvent):void
		{
			listing += passiveSocket.readUTFBytes(passiveSocket.bytesAvailable);
		}
	}
}