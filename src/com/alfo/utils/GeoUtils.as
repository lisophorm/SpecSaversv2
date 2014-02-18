package com.alfo.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.GeolocationEvent;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.sensors.Geolocation;
	import flash.utils.Timer;

	public class GeoUtils extends EventDispatcher
	{
		private static const PI_OVER_180 : Number = Math.PI / 180.0;
		public static var CHANGE_THRESHOLD:Number=1000;
		
		private var prefsFile:File;
		[Bindable] public var prefsXML:XML; // The XML data
		public var stream:FileStream; // The FileStream object used to read and write prefsFile data.
		
		private var loader:URLLoader = new URLLoader();
		private var request:URLRequest = new URLRequest();
		
		private var geo:Geolocation;
		
		var pollTimer:Timer;
		private var _latitude:Number=0;
		private var _longitude:Number=0;
		private var _accuracy:Number;
		
		private var _requestedUpdateInterval:Number=10000;
		
		public static function isGPSSupported():Boolean {
			return Geolocation.isSupported;
		}
		
		public function setUpdateInterval(interval:Number):void {
			_requestedUpdateInterval=interval;
			geo.setRequestedUpdateInterval(interval);
		}
		public function getUpdateInterval():Number {
			return _requestedUpdateInterval;
		}
		
		public function GeoUtils()
		{
			trace("initialize geoutil");

		}
		public function init():void {
			loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onLoaderError);
			trace("init geoutil");
			stream = new FileStream();
			prefsFile=File.applicationStorageDirectory;
			prefsFile = prefsFile.resolvePath("assets/xml/geopreferences.xml"); 
			if (prefsFile.exists) {
				trace("LOCATION preferences exist");
				stream.open(prefsFile, FileMode.READ);
				processXMLData();
			} else {
				trace("LOCATION preferences CREATED");
				createXMLData();
				writeXMLData();
			}
			geo = new Geolocation();
			pollTimer = new Timer(10000);
			pollTimer.addEventListener(TimerEvent.TIMER,checkForGPS);
			pollTimer.start();
		}
		
		public function formatted_address():String {
			return prefsXML.formatted_address;
		}
		private function onLoaderError(e:IOErrorEvent) {
			
		}
		private function onLoaderComplete(e:Event):void 
		{
			var loader:URLLoader = URLLoader(e.target);
			var XMLdata:XML = new XML(loader.data);			
			trace("XML status:"+XMLdata.status);
			trace("XML length:"+XMLdata.result.length());
			if(XMLdata.status=="OK") {
				for (var i=0;i<XMLdata.result.length();i++) {
					if(XMLdata.result[i].type.length()==null) {
						trace("TYPE IS SINGLE");
					} else {
						trace("TYPE IS ARRAY:"+XMLdata.result[i].type.length());
					}
					trace("length of type:"+XMLdata.result[i].type.length())
					if(XMLdata.result[i].type=="street_address") {
						trace("trovato il postcode!"+XMLdata.result[i].formatted_address);
						prefsXML.formatted_address=XMLdata.result[i].formatted_address;
						break;
					}
					if(XMLdata.result[i].type=="postal_code") {
						trace("trovato il postcode!"+XMLdata.result[i].formatted_address);
						prefsXML.formatted_address=XMLdata.result[i].formatted_address;
						break;
					}
					if(XMLdata.result[i].type=="political") {
						trace("trovato il political!"+XMLdata.result[i].formatted_address);
						prefsXML.formatted_address=XMLdata.result[i].formatted_address;
						break;
					}
					if(XMLdata.result[i].type[1]=="political") {
						trace("trovato il political su uno!"+XMLdata.result[i].formatted_address);
						prefsXML.formatted_address=XMLdata.result[i].formatted_address;
						break;
					}
				}
				prefsXML.latitude=_latitude.toString();
				prefsXML.longitude=_longitude.toString();
				prefsXML.accuracy=_accuracy.toString();
				writeXMLData();
				dispatchLocation();
				if(geo!=null) {
					geo.removeEventListener(GeolocationEvent.UPDATE, geolocationUpdateHandler);
					pollTimer.stop();
					geo=null;
				}
				
			} else {
				trace("error polling location from Google:"+XMLdata.status);
			}
		
		}
		
		public function checkForGPS(e:TimerEvent=null) {
			trace("checkforGPS");
			if(! geo.muted){
				
				//Register to receive location updates.
				if(!geo.hasEventListener(GeolocationEvent.UPDATE)) {
					trace("add GPS listener");
					geo.setRequestedUpdateInterval(_requestedUpdateInterval);
					geo.addEventListener(GeolocationEvent.UPDATE, geolocationUpdateHandler);

				}
			} else {
				if(geo.hasEventListener(GeolocationEvent.UPDATE)) {
					trace("remove GPS listener");
					geo.removeEventListener(GeolocationEvent.UPDATE, geolocationUpdateHandler);
				}
			}
		}

		
		private function geolocationUpdateHandler(event:GeolocationEvent):void
		{
			trace("geolocation update");
			trace(event.toString());
			var a:Number=parseFloat(prefsXML.latitude);
			var b:Number=parseFloat(prefsXML.longitude);
			
			var dinst:Number=distVincenty(event.latitude,event.longitude,parseFloat(prefsXML.latitude),parseFloat(prefsXML.longitude));
			trace("distance:"+dinst);
			if(dinst>CHANGE_THRESHOLD) {
				_latitude=event.latitude;
				_longitude=event.longitude;
				_accuracy=event.horizontalAccuracy;
				//prefsXML.formatted_address="awaiting data from Google";
				trace("distance changed polling google");
				request.url = "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&language=en&latlng="+event.latitude.toString()+","+event.longitude.toString();
				loader.load(request);
			}
			
		}
		
		private function dispatchLocation():void {
			trace("sending dispatcher");
			
			var posEvt:GeoUtilEvent=new GeoUtilEvent(GeoUtilEvent.LOCATION_UPDATED,parseFloat(prefsXML.latitude),parseFloat(prefsXML.longitude),parseFloat(prefsXML.accuracy),prefsXML.formatted_address);
			dispatchEvent(posEvt);
		}
		
		private function processXMLData():void 
		{
			trace("file size:"+stream.bytesAvailable);
			prefsXML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			trace("Preferences: serverIP: '"+prefsXML.toString()+" address:"+prefsXML.address);
		}
		
		private function createXMLData():void 
		{
			prefsXML = <preferences/>;
			prefsXML.latitude="0";
			prefsXML.longitude="0";
			prefsXML.formatted_address="";
			prefsXML.accuracy="";
		}
		
		private function writeXMLData():void 
		{
			trace("saving xml:");
			var outputString:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			outputString += prefsXML.toXMLString();
			outputString = outputString.replace(/\n/g, File.lineEnding);
			trace("*********"+outputString+"***********");
			try
			{
				var f:File = new File( prefsFile.nativePath );
				stream = new FileStream();
				stream.open(f, FileMode.WRITE);
				stream.writeUTFBytes(outputString);
				stream.close();
			} catch (error:Error)
			{
				trace("error saving xml:"+error.message);
			} 
			
		}
		private function distVincenty(
			lat1 : Number,
			lon1 : Number,
			lat2 : Number,
			lon2 : Number
		) : Number {
			var a : Number = 6378137, b : Number = 6356752.3142,  f : Number = 1/298.257223563;  // WGS-84 ellipsiod
			var L : Number = (lon2-lon1) * PI_OVER_180;
			var U1 : Number = Math.atan((1-f) * Math.tan(lat1 * PI_OVER_180));
			var U2 : Number = Math.atan((1-f) * Math.tan(lat2 * PI_OVER_180));
			var sinU1 : Number = Math.sin(U1), cosU1 : Number = Math.cos(U1);
			var sinU2 : Number = Math.sin(U2), cosU2 : Number = Math.cos(U2);
			
			var lambda : Number = L, lambdaP : Number = 2*Math.PI;
			var iterLimit : int = 20;
			while (Math.abs(lambda-lambdaP) > 1e-12 && --iterLimit>0) {
				var sinLambda : Number = Math.sin(lambda), cosLambda : Number = Math.cos(lambda);
				var sinSigma : Number = Math.sqrt((cosU2*sinLambda) * (cosU2*sinLambda) + 
					(cosU1*sinU2-sinU1*cosU2*cosLambda) * (cosU1*sinU2-sinU1*cosU2*cosLambda));
				if (sinSigma==0) return 0;  // co-incident points
				var cosSigma : Number = sinU1*sinU2 + cosU1*cosU2*cosLambda;
				var sigma : Number = Math.atan2(sinSigma, cosSigma);
				var sinAlpha : Number = cosU1 * cosU2 * sinLambda / sinSigma;
				var cosSqAlpha : Number = 1 - sinAlpha*sinAlpha;
				var cos2SigmaM : Number = cosSigma - 2*sinU1*sinU2/cosSqAlpha;
				if (isNaN(cos2SigmaM)) cos2SigmaM = 0;  // equatorial line: cosSqAlpha=0 (¤6)
				var C : Number = f/16*cosSqAlpha*(4+f*(4-3*cosSqAlpha));
				lambdaP = lambda;
				lambda = L + (1-C) * f * sinAlpha *
					(sigma + C*sinSigma*(cos2SigmaM+C*cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)));
			}
			if (iterLimit==0) return NaN  // formula failed to converge
			
			var uSq : Number = cosSqAlpha * (a*a - b*b) / (b*b);
			var A : Number = 1 + uSq/16384*(4096+uSq*(-768+uSq*(320-175*uSq)));
			var B : Number = uSq/1024 * (256+uSq*(-128+uSq*(74-47*uSq)));
			var deltaSigma : Number = B*sinSigma*(cos2SigmaM+B/4*(cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)-
				B/6*cos2SigmaM*(-3+4*sinSigma*sinSigma)*(-3+4*cos2SigmaM*cos2SigmaM)));
			var s : Number = b*A*(sigma-deltaSigma);
			return s;
		}
	}
}