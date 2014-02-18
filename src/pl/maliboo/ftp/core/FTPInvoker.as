package pl.maliboo.ftp.core
{
	import flash.events.Event;
	
	import pl.maliboo.ftp.errors.FTPError;
	import pl.maliboo.ftp.events.FTPEvent;
	import pl.maliboo.ftp.FTPCommand;
	
	/**
	 * Base class for all server actions (command sequences)
	 */ 
	public class FTPInvoker
	{
		protected var client:FTPClient;
		
		public function FTPInvoker (client:FTPClient)
		{
			this.client = client;
			client.addEventListener(FTPEvent.RESPONSE, responseHandler);
		}
		
		/**
		 * Sends command to server
		 */ 
		protected function sendCommand(command:FTPCommand):Boolean
		{
			return client.sendPartCommand(command);
		}
		
		/**
		 * Response event handler
		 */ 
		protected function responseHandler(evt:FTPEvent):void
		{
			throw new Error("FTPInvoker virtual method");
		}
		
		/**
		 * Starts command sequence executing
		 */ 
		final internal function execute ():void
		{
			startSequence();
		}
		
		/**
		 * Pseudo virtual method to override. Starts command sequense for subclasses
		 */ 
		protected function startSequence():void
		{
			throw new Error("FTPInvoker virtual method");
		}
		
		/**
		 * Make final clean up
		 * 
		 */ 
		protected function cleanUp ():void
		{
			//TODO: File::open()
			/*
			Czy final cleanup jest vogle potrzebny?! 
			Jesli tak to tylko dla otwartych plikow: 
			SPRAWDZIC!
			*/
			throw new Error("FTPInvoker virtual method");
		}
		
		/**
		 * Releases current process from executing sequence
		 */ 
		final protected function release(evt:Event):void
		{
			finalize();
			client.finalizeCurrentProcess(evt);
		}
		
		/**
		 * Releases current process from executing sequence with error
		 */ 
		protected function releaseWithError(err:FTPError):void
		{
			var evt:FTPEvent = new FTPEvent(FTPEvent.INVOKE_ERROR);
			evt.error = err;
			release(evt);
		}
		
		/**
		 * Finalizes command sequence. Releases invoker from client listening
		 * 
		 */ 
		internal function finalize():void
		{
			cleanUp();
			client.removeEventListener(FTPEvent.RESPONSE, responseHandler);
		}
		
	}
}