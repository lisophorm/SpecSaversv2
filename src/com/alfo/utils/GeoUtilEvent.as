package com.alfo.utils
{
	import flash.events.Event;
	
	public class GeoUtilEvent extends Event
	{
		public static const LOCATION_UPDATED:String="locationupdated";
		public static const GPS_ENABLED:String="gpsenabled";
		public static const GPS_DISABLED:String="gpsdisabled";
		
		public var latitude:Number;
		public var longitude:Number;
		public var accuracy:Number;
		public var address:String;
		public var status:String;
		
		public function GeoUtilEvent(type:String, lat:Number,lon:Number,accuracy:Number,address:String,status:String="OK")
		{
			super(type, bubbles, cancelable);
			this.latitude=lat;
			this.longitude=lon;
			this.accuracy=accuracy;
			this.address=address;
			this.status=status;
			
		}
	}
}