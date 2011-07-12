package com.smp.common.utils{

	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class JSUtils {
		
		public static function openBrowserPopUp(url:String, windowname:String, width:Number, height:Number):void {
			
			var _width:String = width.toString();
			var _height:String = height.toString();
			
			var jsstring = "javascript:window.open('"+url+"', '"+windowname+"', 'width="+_width+", height="+_height+"'); void(0);";
			var req:URLRequest = new URLRequest(jsstring);
			navigateToURL(req, "_self");

		}
		
		
		public static function trace(obj:Object):void {
			
			var traceMsg:String = StringUtils.serializeObject(obj);
			
			try{
				navigateToURL(new URLRequest("javascript:alert(" + traceMsg +"); void(0);"), "_self");
			}catch (err:Error) {
				navigateToURL(new URLRequest("javascript:alert('" + err.message +"'); void(0);"), "_self");
			}
		}

		
	}
}