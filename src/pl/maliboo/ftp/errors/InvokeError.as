package pl.maliboo.ftp.errors
{
	public class InvokeError extends FTPError
	{
		public static const MESSAGE:String = "Invoke error";
		public function InvokeError(message:String="unknown", id:int=0)
		{
			super(MESSAGE+"("+message+")", id);
		}
		
	}
}