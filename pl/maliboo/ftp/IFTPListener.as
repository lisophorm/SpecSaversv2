package pl.maliboo.ftp
{
	import pl.maliboo.ftp.events.FTPEvent;
	
	public interface IFTPListener extends IFTPListenerBase
	{
		function changeDir(evt:FTPEvent):void;
		function connected(evt:FTPEvent):void;
		function connectionLost(evt:FTPEvent):void;
		function createDir(evt:FTPEvent):void;
		function deleteDir(evt:FTPEvent):void;
		function deleteFile(evt:FTPEvent):void;
		function disconnected(evt:FTPEvent):void;
		function download(evt:FTPEvent):void;
		function listing(evt:FTPEvent):void;
		function progress(evt:FTPEvent):void;
		function renameFile(evt:FTPEvent):void;
		function upload(evt:FTPEvent):void;
		function dispose():void;
	}
}