package com.smp.common.display.loaders{

	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public class DisplayObjectLoader extends Sprite {

		protected var _loader:Loader = new Loader();
		protected var _context:LoaderContext;
		protected var _onCompleteCallback:Function = null;
		
		
		private var _loaderInfo:LoaderInfo;
		private var _verbose:Boolean = false;
		private var _recursive:Boolean = false;

		private var _loadProgress:String = "";
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _loadPercent:int;
		private var _loaded:Boolean;
		
		
		
		

		public function DisplayObjectLoader(url:String = "", verbose:Boolean = false, recursive:Boolean = false, checkPolicy:Boolean = false,callback:Function = null) {

			addChild(_loader);
			
			_loaded = true;

			_verbose = verbose;
			_recursive = recursive;
			createEventHandlers();


			_context = new LoaderContext();
			//for external domain downloads
			if(checkPolicy){
				_context.checkPolicyFile = true;
				//_context.securityDomain = SecurityDomain.currentDomain;
			}

			_onCompleteCallback = callback;
			
			if (url != "") {
				_loaded = false;
				try {
					_loader.load(new URLRequest(url),_context);
				} catch (err:Error) {
					trace(err.message);
				}
			}
		}
		
		protected function createEventHandlers():void {
			_loaderInfo = _loader.contentLoaderInfo;
			_loaderInfo.addEventListener(Event.OPEN, onOpen);
			_loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
			_loaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loaderInfo.addEventListener(Event.INIT, onInit);
			_loaderInfo.addEventListener(Event.UNLOAD, onUnloadContent);
		}
		
		/**
		 * 
		 * @param	url			: the file to load
		 * @param	callback	: expect this object as argument
		 */
		public function load(url:String, callback:Function = null):void {
			
			_onCompleteCallback = callback;
			
			if (_loaded == true) {
				_loadPercent = 0;
				if (this.contains(_loader)) removeChild(_loader);
				unLoad();
				_loaded = false;
				
				try {
					_loader.load(new URLRequest(url), _context);
				} catch (err:Error) {
					if (_verbose) {
						trace(err.message);
					}
				}
			}
		}
		public function unLoad():void {	
			try{
				_loader.unload();
			}
			catch (err:Error) {
				if (_verbose) {
					trace("LoadDisplayObject -> unLoad: "+err.message);
				}
			}
		}
		private function onOpen(evt:Event):void {
			if (_verbose) {
				trace("Loading started");
			}
			dispatchEvent(evt);
		}
		private function onProgress(evt:ProgressEvent):void {
			_loadPercent = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			_loadProgress = (loadPercent + " : " + _bytesLoaded + " -> " + _bytesTotal);
			
			dispatchEvent(evt);
			

		}
		public function get progressString():String {
			return _loadProgress;
		}
		public function get loadPercent():int {
			return _loadPercent;
		}
		public function get Loaded():Boolean {
			return _loaded;
		}
		public function get progressBytesArray():Array {
			return [_bytesLoaded,_bytesTotal];
		}
		
		public function get content():*
		{
			if(_loaderInfo.contentType == "application/x-shockwave-flash"){
				return _loader.content; 
			}else if (_loaderInfo.contentType == "image/jpeg" || _loaderInfo.contentType == "image/gif" || _loaderInfo.contentType == "image/png") {
				return Bitmap(_loader.content);
			}
			
			return false;
		}
		
		public function get contentLoaderInfo():LoaderInfo {
				return _loaderInfo;
		}
		
		protected function onComplete(evt:Event):void {
			
			_loaded = true;
			_loadPercent = 100;
			
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
			
			if (!_recursive) {
				removeHandlers();
			}

			addDisplayObject();
		}
		
		protected function addDisplayObject() {
			
			addChild(_loader);
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (_onCompleteCallback != null) {
				_onCompleteCallback(this);
			}
			
			
		}
		
		
		protected function onHTTPStatusEvent(evt:HTTPStatusEvent):void {
			if (_verbose) {
				trace("HTTP status code: " + evt.status);
			}
			dispatchEvent(evt);

		}
		protected function onIOError(evt:IOErrorEvent):void {
			if (_verbose) {
				trace("Erro de loading: " + evt.text);
			}
			dispatchEvent(evt);
		}
		protected function onInit(evt:Event):void {
			
			if (_verbose) {
				trace("Ficheiro de tipo: "+evt.target.contentType);
			}
			if (!_recursive) {
				_loaderInfo.removeEventListener(Event.INIT, onInit);
			}
			dispatchEvent(evt);
		}
		
		/**
		 * Dispatched by a LoaderInfo object whenever a loaded object is removed by using the unload() method of the Loader object, or when a second load is performed by the same Loader object and the original content is removed prior to the load beginning.
		 * @param	evt
		 */
		protected function onUnloadContent(evt:Event):void {
			if (!_recursive) {
				_loaderInfo.removeEventListener(Event.UNLOAD, onUnloadContent);
				
			}
			dispatchEvent(evt);

		}
		
		protected function removeHandlers():void {
		
			_loaderInfo.removeEventListener(Event.OPEN, onOpen);
			_loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
			_loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
		}

	}
}