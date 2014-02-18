package com.alfo
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	public class UserObject extends Sprite
	{
		
		private var _photo1:String;
		private var _photo2:String;
		private var _photo3:String;
		
		private static var _instance:UserObject=null;
		//public var urn:String;
		
		
		public static var userXML:XML;
		
		public var batchPath:String="specsavers_jpg_xml/";
		
		public var spoolerPath:String="specsavers_print/"
			
		public var tempPath:String="specsavers_temp_jpg/";
		
		
		public function UserObject()
		{
			trace("inizializza userObject");
		}
		
		public function get photo2():String
		{
			return userXML.photo2;
		}

		public function set photo2(value:String):void
		{
			userXML.photo2 = value;
		}

		public function get photo1():String
		{
			return userXML.photo1;
		}
		
		public function get hometown():String {
			return userXML.hometown;
		}
		
		public function set hometown(town:String) {
			userXML.hometown=town;
		}
		
		public function set extraterms(value:Boolean):void
		{
			if(value) {
				userXML.extraterms = "1";
			} else {
				userXML.extraterms = "0";
			}
			
		}
		
		public function get extraterms():Boolean
		{
			if(userXML.extraterms=="1") {
				return true;
			} else {
				return false;
			}
		}

		public function set photo1(value:String):void
		{
			userXML.photo1 = value;
		}

		public function get photo3():String
		{
			return userXML.photo3;
		}

		public function set photo3(value:String):void
		{
			userXML.photo3 = value;
		}

		public function get current_location():String
		{
			return userXML.current_location;
		}
		
		public function set location(value:String):void
		{
			userXML.location = value;
		}
		
		public function get location():String
		{
			return userXML.location;
		}
		
		public function set current_location(value:String):void
		{
			userXML.current_location = value;
		}
		
		
		public static function getInstance():UserObject {
			if(_instance==null) {
				trace("******* singleton first instance");
				_instance=new UserObject();
				_instance.init();
			} else {
				trace("**************old instance");
				trace(userXML.toXMLString());
				trace("first name:"+userXML.firstname);
			}
			return _instance;
		}
		
		public function init():void {
			trace("***** init userobject");
			userXML =new XML("<user/>");
			var now:Date= new Date();
			userXML.added=convertASDateToMySQLTimestamp(now);
			userXML.isConnected="1";
			userXML.isBatch="0";
			userXML.photo1="";
			userXML.photo2="";
			userXML.photo3="";
			userXML.extraterms = "1";
			trace("new userobject");
			var workDirectory:File = File.documentsDirectory.resolvePath(batchPath);
			trace("directory url:"+workDirectory.url);
			if (!workDirectory.exists) {
				trace("directory does not exists");
				//try {
				workDirectory.createDirectory();
				//} catch (e:Error) {
				trace("Failed creating working directory!");
				//}
			} else {
				trace("work dir exists");
			}
		}
		
		public function eject():void {
			trace("XML:");
			trace(userXML.toXMLString());
		}
		
		public function set urn(theURN:String):void {
			userXML.urn=theURN;
		}
		public function get urn():String {
			return userXML.urn;
		}
		public function set token(thetoken:String):void {
			userXML.token=thetoken;
		}
		public function get token():String {
			return userXML.token;
		}
		public function set firstname(thefirstname:String):void {
			userXML.firstname=thefirstname;
		}
		public function get firstname():String {
			return userXML.firstname;
		}
		public function set lastname(thelastname:String):void {
			userXML.lastname=thelastname;
		}
		public function set mobile(themobile:String):void {
			userXML.mobile=themobile;
		}
		public function set email(theemail:String):void {
			userXML.email=theemail;
		}
		public function set fb_id(thefb_id:String):void {
			userXML.fb_id=thefb_id;
		}
		public function set data_saved(thedata_saved:Boolean):void {
			userXML.data_saved=thedata_saved?"1":"0";
		}
		public function set facebook(thefacebook:Boolean):void {
			userXML.facebook=thefacebook?"1":"0";
		}
		public function set hasphoto(thehasphoto:Boolean):void {
			userXML.hasphoto=thehasphoto?"1":"0";
		}
		public function set isConnected(theconnection:Boolean):void {
			userXML.isConnected=theconnection?"1":"0";
		}
		public function get isConnected():Boolean {
			if(userXML.isConnected=="1") {
				return true;
			} else {
				return false;
			}
		}
		public function set isBatch(thebatch:Boolean):void {
			userXML.isBatch=thebatch?"1":"0";
		}
		public function get isBatch():Boolean {
			if(userXML.isBatch=="1") {
				return true;
			} else {
				return false;
			}
		}
		public function set destFileName(thedestFileName:String):void {
			userXML.destFileName=thedestFileName;
		}
		public function get destFileName():String {
			return userXML.destFileName;
		}
		
		public function saveXML():String {
			var f:File = File.documentsDirectory.resolvePath(batchPath+userXML.urn+".xml");
			trace("save xml");
			trace("file:"+userXML.urn);
			trace("path:"+f.url);
			var message:String;
			var s:FileStream = new FileStream();
			try
			{
				s.open(f,flash.filesystem.FileMode.WRITE);
				s.writeUTFBytes(userXML.toXMLString());
				message="OK";
			} catch(e:Error) {
				trace("error saving xml"+e.message);
				message= (e.message as String);
			} finally {
				s.close();
			}
			trace("saveXML result:"+message);
			return message;
		}
		
		private function convertASDateToMySQLTimestamp( d:Date ):String {
			var s:String = d.fullYear + '-';
			s += prependZero( d.month + 1 ) + '-';
			s += prependZero( d.date ) + ' ';
			
			s += prependZero( d.hours ) + ':';
			s += prependZero( d.minutes ) + ':';
			s += prependZero( d.seconds );			
			
			return s;
		}
		
		private function prependZero( n:Number ):String {
			var s:String = ( n < 10 ) ? '0' + n : n.toString();
			return s;
		}
		
	}
}