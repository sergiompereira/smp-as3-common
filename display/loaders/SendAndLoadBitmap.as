package com.smp.common.display.loaders {
	
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import com.smp.common.display.loaders.LoadBitmap;
	
	
	
	public class SendAndLoadBitmap extends EventDispatcher {

		public static const RESPONSE_VARIABLES:String = "variables";
		public static const RESPONSE_BINARY:String = "binary";

		//protected
		protected var _loader:URLLoader = new URLLoader();
		protected var _request:URLRequest;
		protected var _imageLoader:LoadBitmap;
		protected var _image:Bitmap;
		
		protected var _loaderData:*;
		protected var _responseFormat:String;
		protected var _getUrl:Boolean = false;
		protected var _callback:Function = null;
		protected var _verbose:Boolean = false;
		
		//private
		private var _loadProgress:String = "";
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _loadPercent:int;


		public function SendAndLoadBitmap() {
			//no default constructor
		}
		
		
		/**
		 * Assynchronous call.
		 * Look for the static method launch() for a synchronous call
		 * 
		 * Sends a ByteArray to a server-side script.
		 * If responseFormat is set to 'variables', a url encoded data is expected, and if getUrl is set to true, an url variable is looked for and is requested, expecting an image file as response. Afterwards, this can be accessed through the getter 'image'.
		 * If resopnseFormat is set to 'binary', it is used as bitmap data source and available through the getter 'image'.
		 * If planing to use a FileReference to download the image, use 'variables' as the response format to use the FileReference's download() method.
		 * Or otherwise, use 'binary' and use the FileReference's method save() and pass to it the getter 'rawLoadedData' as argument.
		 * 
		 * 
		 * 
		 * @param	url				address of the server side script to which send the byte data. For PHP use this:
									
									$rawpostdata =  file_get_contents("php://input"); 
									$file = getNewFileName();
									if (!$fp = fopen(realpath("./uploads")."/".$file, 'wb')) {
										echo("code=-1&message=Error:Server error");
										return 0;
									}
									// Use if data was compressed with the ZLIB algorithm (used by the save() method of the ActionScript ByteArray class)
									//$rawpostdata = gzuncompress($rawpostdata->data);
									fwrite($fp, $rawpostdata);
									fclose($fp);
									echo("code=1&message=Upload Successfull");
									

		 * @param	bitmapStream 	the byte data to be sent. Use BitmapUtilities (srg.display.utils) to convert an object or a bitmap to ByteArray (JPG or PNG encoded)
		 * @param	params			any configurations for the service
		 * @param	headers			any headers ("octet-steam" content-type is added by default)
		 * @param	responseFormat	the expected response format of the service, whether it is URL encoded variables (for instance, the url of the uploaded image) or a binary stream (for instance, the same image processed by the server). Use the available static constants. Defaults to "binary". 
		 * @param	getUrl			whether to get or not the image on the server, in case a "url" variable is found on the response (ignored if "binary" format defined). Defaults to false.
		 * @param	nocache
		 * @param	verbose
		 */

		public function send(url:String, bitmapStream:ByteArray, params:Object = null, headers:Array = null, responseFormat:String = "binary", getUrl:Boolean = false, callback:Function = null, nocache:Boolean = true, verbose:Boolean = true):void {
			
			_verbose = verbose;
			_responseFormat = responseFormat;
			_loader.dataFormat = _responseFormat;
			// "variables" ou "binary" ou "text"
			_getUrl = getUrl;
			_callback = callback;
			
			loaderHandlers();
			
			
			var _url:String = url;
			if (params) {	
				for (var chave in params) {
					//trace(params[chave]);
					if (_url.indexOf("?") >0) {
						_url = _url + "&"+chave+"=" + params[chave];
					}else{
						_url = _url + "?"+chave+"=" + params[chave];
					}
				}
			}
			
			if (nocache) {
				var numero:Number = Math.round(999999 * Math.random());
				if (_url.indexOf("?") >0) {
					_url = _url + "&nocache=" + numero;
				}else{
					_url = _url + "?nocache=" + numero;
				}
			}
			
			_request = new URLRequest(_url);
			_request.data = bitmapStream;
			_request.method = URLRequestMethod.POST;

			if(headers != null && headers.length>0){
				for (var i:uint = 0; i < headers.length; i++){
					_request.requestHeaders.push(headers[i]);
				}
			}
			var octetHeader:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			_request.requestHeaders.push(octetHeader);
			
			
			try {
				_loader.load(_request);
			} catch (err:Error) {
				if (_verbose) {
					trace(err.message);
				}
			}
		}
		
		protected function loaderHandlers():void 
		{
			_loader.addEventListener(Event.OPEN, onOpen, false,0);
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
		}
		
		private function onOpen(evt:Event):void {
			if (_verbose) {
				trace("Loading started");
			}
		}
		private function onProgress(evt:ProgressEvent):void 
		{
			dispatchEvent(evt);

			_loadPercent = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			_loadProgress = (loadPercent + " : " + _bytesLoaded + " -> " + _bytesTotal);
			
		}
		public function get progressString():String {
			return _loadProgress;
		}
		public function get loadPercent():int {
			return _loadPercent;
		}
		public function get progressBytesArray():Array {
			return [_bytesLoaded,_bytesTotal];
		}
		protected function onComplete(evt:Event):void 
		{
			removeHandlers();
			_loaderData = evt.target.data;
			_imageLoader = new LoadBitmap(false, _verbose);
			
			if (_responseFormat == RESPONSE_VARIABLES) {
				if(_getUrl){
					if (_loaderData.url != null) {
						_imageLoader.Load(_loaderData.url, onImageReady);
					}else {
						if (_verbose) {
							throw new ArgumentError("SendAndLoadBitmap : No url parameter was return from the server, although getUrl was set to true.");
						}
						dispatchEvent(new Event(Event.COMPLETE));
						if (_callback != null) {
							_callback();
						}
					}
				}else {
					dispatchEvent(new Event(Event.COMPLETE));
					if (_callback != null) {
							_callback();
						}
				}
			}else {
				_imageLoader.loadBytes(_loaderData, onImageReady);
			}
		}
		
		protected function onImageReady() 
		{
			_image = _imageLoader.bitmap;
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (_callback != null) {
				_callback();
			}
		}
		
		public function get loadedData():* 
		{
			if(_responseFormat == RESPONSE_VARIABLES){
				return _loaderData;
			}else {
				return this.image;
			}
			return null;
		}
		
		public function get rawLoadedData():* {
			return _loaderData;
		}
		
		public function get image():Bitmap 
		{
			if(_image != null){
				return _image;
			}else {
				if (_verbose) {
					throw new ArgumentError("SendAndLoadBitmap : No image has been loaded.");
				}
				return null;
			}
			
			return null;
		}
		
		protected function removeHandlers():void
		{
			_loader.removeEventListener(Event.OPEN, onOpen);
			_loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);

		}
		
		
		protected function onHTTPStatusEvent(evt:HTTPStatusEvent):void {
			if (_verbose) {
				trace("HTTP status code: "+evt.status);
			}
		}
		private function onSecurityError(evt:SecurityErrorEvent):void {
			if (_verbose) {
				trace("Erro de seguranca: "+evt.text);
			}
		}
		protected function onIOError(evt:IOErrorEvent):void {
			if (_verbose) {
				trace("Erro de loading: "+evt.text);
			}
		}
		
		/**
		 * Synchronous call.
		 * It will launch a new browser window and if 'Content-Type: image/jpeg' is set on the response, a system window will pop-up to download/'save as' the file.
		 * Meanwhile, between the request and the response, the server-side script might process the image. If no server-side processing is required, use FileReference and its method save() (only CS4+)
		 * Be aware of download blockers.
		 * 
		 * @param	url
		 * @param	bitmapStream
		 * @param	params
		 * @param	headers
		 * @param	nocache
		 * @param	verbose
		 */
		public static function launch(url:String, bitmapStream:ByteArray, params:Object=null, headers:Array = null, nocache:Boolean = true, verbose:Boolean = false):void {
			

			var _url:String = url;
			if (params) {	
				for (var chave in params) {
					//trace(params[chave]);
					if (_url.indexOf("?") >0) {
						_url = _url + "&"+chave+"=" + params[chave];
					}else{
						_url = _url + "?"+chave+"=" + params[chave];
					}
				}
			}
			
			if (nocache) {
				var numero:Number = Math.round(999999 * Math.random());
				if (_url.indexOf("?") >0) {
					_url = _url + "&nocache=" + numero;
				}else{
					_url = _url + "?nocache=" + numero;
				}
			}
			
			var request = new URLRequest(_url);
			request.data = bitmapStream;
			request.method = URLRequestMethod.POST;

			if(headers != null && headers.length>0){
				for (var i:uint = 0; i < headers.length; i++){
					request.requestHeaders.push(headers[i]);
				}
			}
			
			var octetHeader:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			request.requestHeaders.push(octetHeader);
			
			
			try {
				navigateToURL(request, "_blank");
			}catch (err:Error) {
				if(verbose){
					trace(err.message);
				}
			}
		}
	}
}