package events
{
	import flash.events.Event;
	
	public class KioskError extends Event
	{
		public static var ERROR:String = "KIOSKERROR_Error";
		public static var MODAL:String = "KIOSKERROR_Modal";

		public var message:String="";
		public var title:String="";
		public var exitFunction:Function = null;
		public var retryFunction:Function = null;
		public function KioskError(type:String="",message:String="", title:String="", exitFunction:Function=null, retryFunction:Function=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.exitFunction = exitFunction;
			this.retryFunction = retryFunction;
			this.message = message;
			this.title = title;
			super(type, bubbles, cancelable);
		}
	}
}