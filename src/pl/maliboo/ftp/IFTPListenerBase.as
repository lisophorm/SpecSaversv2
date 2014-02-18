package pl.maliboo.ftp
{
	import pl.maliboo.ftp.events.FTPEvent;
	
	/**
	 * Base interface for listening FTPClient events
	 */ 
	public interface IFTPListenerBase
	{
		function commandSent(evt:FTPEvent):void;
		function responseReceived(evt:FTPEvent):void;
	}
}