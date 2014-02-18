package pl.maliboo.ftp
{
	import pl.maliboo.ftp.events.FTPEvent;
	import pl.maliboo.ftp.core.FTPClient;
	/**
	 * Pseudo abstract class for listening FTPClient.
	 * 
	 */ 
	public class FTPListener implements IFTPListener
	{
		private var client:FTPClient;
		 
		public function FTPListener (client:FTPClient)
		{
			this.client = client;
			client.addEventListener(FTPEvent.CHANGE_DIR, changeDir);
			client.addEventListener(FTPEvent.COMMAND, commandSent);
			client.addEventListener(FTPEvent.CONNECTED, connected);
			client.addEventListener(FTPEvent.LOGGED, logged);
			client.addEventListener(FTPEvent.CREATE_DIR, createDir);
			client.addEventListener(FTPEvent.DELETE_DIR, deleteDir);
			client.addEventListener(FTPEvent.DELETE_FILE, deleteFile);
			client.addEventListener(FTPEvent.DISCONNECTED, disconnected);
			client.addEventListener(FTPEvent.DOWNLOAD, download);
			client.addEventListener(FTPEvent.LISTING, listing);
			client.addEventListener(FTPEvent.PROGRESS, progress);
			client.addEventListener(FTPEvent.RENAME_FILE, renameFile);
			client.addEventListener(FTPEvent.RESPONSE, responseReceived);
			client.addEventListener(FTPEvent.UPLOAD, upload);
		}
		
		/**
		 * Releases listener from ftp client.
		 */ 
		public function dispose ():void
		{			
			client.removeEventListener(FTPEvent.CHANGE_DIR, changeDir);
			client.removeEventListener(FTPEvent.COMMAND, commandSent);
			client.removeEventListener(FTPEvent.CONNECTED, connected);
			client.removeEventListener(FTPEvent.LOGGED, logged);
			client.removeEventListener(FTPEvent.CREATE_DIR, createDir);
			client.removeEventListener(FTPEvent.DELETE_DIR, deleteDir);
			client.removeEventListener(FTPEvent.DELETE_FILE, deleteFile);
			client.removeEventListener(FTPEvent.DISCONNECTED, disconnected);
			client.removeEventListener(FTPEvent.DOWNLOAD, download);
			client.removeEventListener(FTPEvent.LISTING, listing);
			client.removeEventListener(FTPEvent.PROGRESS, progress);
			client.removeEventListener(FTPEvent.RENAME_FILE, renameFile);
			client.removeEventListener(FTPEvent.RESPONSE, responseReceived);
			client.removeEventListener(FTPEvent.UPLOAD, upload);	
		}
		
		public function progress(evt:FTPEvent):void
		{
		}
		
		public function download(evt:FTPEvent):void
		{
		}
		
		public function responseReceived(evt:FTPEvent):void
		{
		}
		
		public function connectionLost(evt:FTPEvent):void
		{
		}
		
		public function connected(evt:FTPEvent):void
		{
		}
		
		public function logged(evt:FTPEvent):void
		{
		}
		
		public function changeDir(evt:FTPEvent):void
		{
		}
		
		public function deleteDir(evt:FTPEvent):void
		{
		}
		
		public function deleteFile(evt:FTPEvent):void
		{
		}
		
		public function renameFile(evt:FTPEvent):void
		{
		}
		
		public function listing(evt:FTPEvent):void
		{
		}
		
		public function disconnected(evt:FTPEvent):void
		{
		}
		
		public function createDir(evt:FTPEvent):void
		{
		}
		
		public function upload(evt:FTPEvent):void
		{
		}
		
		public function commandSent(evt:FTPEvent):void
		{
		}
		
	}
}