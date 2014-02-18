package pl.maliboo.ftp.invokers
{
	import pl.maliboo.ftp.core.FTPClient;
	import pl.maliboo.ftp.core.FTPInvoker;
	import pl.maliboo.ftp.events.FTPEvent;
	import pl.maliboo.ftp.Commands;
	import pl.maliboo.ftp.Responses;
	import pl.maliboo.ftp.errors.InvokeError;

	public class WelcomeInv extends FTPInvoker
	{
		public function WelcomeInv(client:FTPClient)
		{
			super(client);
		}
		
		override protected function startSequence ():void
		{
		}
		
		override protected function responseHandler(evt:FTPEvent):void
		{
			switch (evt.response.code)
			{
				case Responses.SERVICE_READY:
					var logEvent:FTPEvent = new FTPEvent(FTPEvent.CONNECTED);
					logEvent.hostname = client.hostname;
					release(logEvent);
					break;
				default:
					releaseWithError(new InvokeError(evt.response.message));
			}
		}
		
		override protected function cleanUp ():void
		{
		}
		
	}
}