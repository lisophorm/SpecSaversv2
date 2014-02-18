package pl.maliboo.ftp.invokers
{
	import pl.maliboo.ftp.Commands;
	import pl.maliboo.ftp.core.FTPClient;
	import pl.maliboo.ftp.FTPCommand;
	import pl.maliboo.ftp.core.FTPInvoker;
	import pl.maliboo.ftp.Responses;
	import pl.maliboo.ftp.events.FTPEvent;
	import pl.maliboo.ftp.errors.InvokeError;

	public class ChangeDirInv extends FTPInvoker
	{
		private var dir:String;
		public function ChangeDirInv (client:FTPClient, newDir:String)
		{
			super(client);
			dir = newDir;
		}
		
		override protected function startSequence ():void
		{
			sendCommand(new FTPCommand(Commands.CD, dir));
		}
		
		override protected function responseHandler(evt:FTPEvent):void
		{
			switch (evt.response.code)
			{
				case Responses.FILE_ACTION_OK:
					sendCommand(new FTPCommand(Commands.PWD));
					break;
				case Responses.PATHNAME_CREATED:
					var cdEvent:FTPEvent = new FTPEvent(FTPEvent.CHANGE_DIR);
					cdEvent.directory = parseCurrentDir(evt.response.message);
					release(cdEvent);
					break;
				default:
					releaseWithError(new InvokeError(evt.response.message));
			}
		}
		
		private function parseCurrentDir (currentDirResponse:String):String
		{
			var match:Array = currentDirResponse.match(/".+"/g);
			if (match==null)
				throw new Error("Error parsing current dir!");
			return match[0].replace(/"/g,"");
		}
		
		override protected function cleanUp ():void
		{
		}
	}
}