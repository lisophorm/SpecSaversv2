package pl.maliboo.ftp
{
	public class FTPResponse
	{	
		
		public var code:int;
		public var message:String;
		public var isMultiline:Boolean;
		
		/**
		 * Class representing FTP server response
		 */ 
		public function FTPResponse (code:int, message:String="", isMultiline:Boolean=false)
		{
			this.code = code;
			this.message = message;
			this.isMultiline = isMultiline;
		}
		
		/**
		 * Parses FTPResponse from raw FTP response
		 */ 
		public static function parseResponse (rawResponse:String):FTPResponse
		{
			var code:int = parseInt(rawResponse.substr(0,3));
			var message:String = trim(rawResponse.substr(4));
			var isMultiline:Boolean = rawResponse.charAt(4) == "-";
			return new FTPResponse(code, message, isMultiline);
		}
		
		private static function trim (str:String):String
		{
			return str.replace(/[\r\n]+$/gm, "");
		}
	}
}