package pl.maliboo.ftp.errors
{
	public class FTPError extends Error
	{
		public function FTPError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}