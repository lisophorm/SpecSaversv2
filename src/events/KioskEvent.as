package events
{
	import flash.events.Event;
	
	public class KioskEvent extends Event
	{
		public static var TERMS_NOTIFY:String = "KIOSKEVENT_TERMS_NOTIFY";
		public static var PROGRESS:String = 	"KIOSKEVENT_PROGRESS";
		
		public var exitFunction:Function = null;
		public function KioskEvent(type:String="", exitFunction:Function=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.exitFunction = exitFunction;
			super(type, bubbles, cancelable);
		}
	}
}