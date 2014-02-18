package events
{
	import flash.events.Event;
	
	public class ApplicationEvent extends Event
	{
		public static var SAVE_TYPE:String = "SAVE_TYPE";

		public var value:Object=null;
		public function ApplicationEvent(type:String="",value:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.value = value;
			super(type, bubbles, cancelable);
		}
	}
}