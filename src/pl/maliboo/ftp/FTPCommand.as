package pl.maliboo.ftp
{
	/**
	 * Class representing FTP command
	 */ 
	public class FTPCommand
	{
		private var command:String;
		private var args:String;
		
		
		public function FTPCommand (command:String, args:String="")
		{
			this.command = command;
			this.args = args;
		}
		
		/**
		 * Returns command as string, ready to send to server 
		 */ 
		public function toExecuteString ():String
		{
			return command + " " + args;
		}
	}
}