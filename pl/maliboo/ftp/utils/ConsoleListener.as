package pl.maliboo.ftp.utils
{
	import pl.maliboo.ftp.FTPListener;
	import pl.maliboo.ftp.core.FTPClient;
	import mx.controls.TextArea;
	import pl.maliboo.ftp.events.FTPEvent;
	import mx.controls.TextInput;

	public class ConsoleListener extends FTPListener
	{
		private var textArea:TextArea;
		private var input:TextInput;
		public function ConsoleListener(client:FTPClient, output:TextArea, input:TextInput=null)
		{
			super(client);
			textArea = output;
			this.input = input;
		}
		
		private function append (text:String):void
		{
			textArea.text += text + "\n";
		}
		
		override public function commandSent (evt:FTPEvent):void
		{
			append("\t"+evt.command.toExecuteString().replace(/PASS .+/gi, "PASS *****"));
		}
		
		override public function responseReceived(evt:FTPEvent):void
		{
			append(evt.response.code + " " +evt.response.message);
		}		
	}
}