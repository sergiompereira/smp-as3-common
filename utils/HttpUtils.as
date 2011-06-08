package com.smp.common.utils{

	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class HttpUtils {
		
		public static const CONTENT_TYPE_FORM_URL_ENCODED:String = "application/x-www-form-urlencoded";
		public static const CONTENT_TYPE_MULTIPART_FORM_DATA:String = "multipart/form-data";
		
		
		/**
		 * 
		 * @param	url
		 * @param	data
		 * @param	contenttype	:use HttpUtils static constants
		 * @param	window
		 */
		public static function postUrl(url:String, data:Object, contenttype:String = "application/x-www-form-urlencoded", window:String = "_blank"):void {

			var req:URLRequest = new URLRequest();
			var _contenttype:URLRequestHeader = new URLRequestHeader("Content-Type", contenttype);
			req.requestHeaders.push(_contenttype);
			req.url = url;
			req.method = URLRequestMethod.POST;
			if (data) {
				var _data:URLVariables = new URLVariables();
				for (var chave in (data)) {
					//trace(parametros[chave]);
					_data[chave] = data[chave];
				}
				req.data = _data;
					
			}
			
			navigateToURL(req, window);
		}
		
		public static function getUrl(url:String, data:Object, window:String = "_blank"):void 
		{
			var req:URLRequest = new URLRequest();
			req.url = url;
			req.method = URLRequestMethod.GET;
			if (data) {
				var _data:URLVariables = new URLVariables();
				for (var chave in (data)) {
					//trace(parametros[chave]);
					_data[chave] = data[chave];
				}
				req.data = _data;
					
			}
			navigateToURL(req, window);
		}
		
	}
}