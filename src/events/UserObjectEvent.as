package events
{
	import flash.events.Event;
	
	public class UserObjectEvent extends Event
	{
		public static var OFFLINE:String = "offline";
		public static var ONLINE:String = "online";
		public static var STATUS_CHANGE:String = "status_change";
		public static var ERROR:String = "error";
		
		public var netStatus:Boolean=false;
		public var errorMsg:String="";

		
		public function UserObjectEvent(type:String, netStatus:Boolean=true,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.netStatus=netStatus;
			super(type, bubbles, cancelable);
		}
	}
}