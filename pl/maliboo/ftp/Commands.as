package pl.maliboo.ftp
{
	/**
	 * Pseudo "enum" class. Provides base commands.
	 * 
	 * @see pl.maliboo.ftp.FTPCommand
	 */
	public final class Commands
	{
		public static const STOR:String		= "STOR";
		public static const BINARY:String	= "TYPE I";
		public static const ASCII:String	= "TYPE A";
		public static const USER:String		= "USER";
		public static const PASS:String		= "PASS";
		public static const QUIT:String		= "QUIT";
		public static const CWD:String		= "CWD";
		public static const PWD:String		= "PWD";
		public static const LIST:String		= "LIST";
		public static const PASV:String		= "PASV";
		public static const RETR:String		= "RETR";
		public static const CD:String		= "CWD";
	}
}