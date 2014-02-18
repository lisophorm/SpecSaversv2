package events
{
	import flash.events.Event;
	
	public class KioskProgressEvent extends Event
	{
		public static var NOTIFY:String = "KIOSKPROGRESSION_NOTIFY";
		public static var UPDATE:String = "KIOSKPROGRESSION_UPDATE";
		public static var UPDATE_COMPLETE:String = "KIOSKPROGRESSION_UPDATE_COMPLETE";
		public var message:String="";
		public var title:String="";
		public var exitFunction:Function = null;
		public function KioskProgressEvent(type:String="",message:String="", title:String="", exitFunction:Function=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.exitFunction = exitFunction;
			this.message = message;
			this.title = title;
			super(type, bubbles, cancelable);
		}
	}
}