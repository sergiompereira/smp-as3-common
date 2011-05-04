package com.smp.common.file
{
	import flash.errors.IllegalOperationError;
	import flash.errors.MemoryError;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.FileFilter;
	import flash.net.navigateToURL;
	import flash.events.DataEvent;
	
	import com.smp.common.events.CustomEvent;


	public class UserFileHandlerList extends EventDispatcher {

		public static const IMAGE :String = "*.gif;*.jpg;*.jpeg;*.png;*.JPG;*.JPEG;*.PNG;*.GIF";
		public static const TEXT :String = "*.txt;*.rtf;*.doc";
		public static const VIDEO :String = "*.mov;*.wmv;*.mpg;*.mp4;*.avi";
		//public static const SOUND:uint = 3;
		public static const IMAGE_AND_VIDEO:String = "*.gif;*.jpg;*.jpeg;*.png;*.JPG;*.JPEG;*.PNG;*.GIF;*.mov;*.wmv;*.mpg;*.mp4;*.avi";

		//private
		private var _fileRefList:FileReferenceList;
		private var _filesContainer:Array;
		private var _fileFilter:FileFilter;
		private var _request:URLRequest;
		private var _parametros:URLVariables;
		private var _byteData:ByteArray;
		private var _serverRawData:*;
		private var _urlData:URLVariables;
		private var _verbose:Boolean = false;
		
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _loadPercent:int;
		
		private var _onCompleteCallback:Function = null;
		private var _onDataReadyCallback:Function = null;
		private var _onSelectCallback:Function = null;
		private var _onCancelCallback:Function = null;
		private var _index:int;



		public function UserFileHandlerList(verbose:Boolean = true) 
		{
			_verbose = verbose;
			_fileRefList = new FileReferenceList();
			_filesContainer = new Array();
			initEventHandlers();
			
			
		}
		
		
		protected function initEventHandlers() 
		{
			_fileRefList.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_fileRefList.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent, false, 0, true);
			_fileRefList.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			
		
			_fileRefList.addEventListener(Event.OPEN, openHandler);
            _fileRefList.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _fileRefList.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);

			
		}
		
		/**
		 * only Player 10+
		 * Set the FileFilter. Options Are: IMAGE, VIDEO, VIDEO_AND_IMAGE
		 * 
		 * 
		 * @param	tipo
		 */
		public function setFilter(tipo:String){
			if(tipo == IMAGE){
				_fileFilter = new FileFilter("Imagens",IMAGE, IMAGE);
			}else if(tipo == TEXT){
				_fileFilter = new FileFilter("Ficheiros de texto",TEXT,TEXT);
			}else if(tipo == VIDEO){
				_fileFilter = new FileFilter("Vídeo",VIDEO,VIDEO);
			}else if (tipo == IMAGE_AND_VIDEO) {
				_fileFilter = new FileFilter("Imagens e Vídeo",IMAGE_AND_VIDEO,IMAGE_AND_VIDEO);
			}
		}
		
		
		public function browse(selectCallback:Function = null, cancelCallback:Function = null) 
		{
			
			if (selectCallback != null) {
				_onSelectCallback = selectCallback;
				_fileRefList.addEventListener(Event.SELECT, onSelectHandler, false, 0, true);
			}
			if (cancelCallback != null) {
				_onCancelCallback = cancelCallback;
				_fileRefList.addEventListener(Event.CANCEL, onCancelHandler, false, 0, true);
			}
			_fileRefList.browse([_fileFilter]);
			
		}
		
		protected function onSelectHandler(evt:Event):void 
		{
			for (var i = 0; i < _fileRefList.fileList.length; i++ )
			{
				_filesContainer.push(_fileRefList.fileList[i]);
			}
			_onSelectCallback();
			_onSelectCallback = null;
			_fileRefList.removeEventListener(Event.SELECT, onSelectHandler);
			_fileRefList.removeEventListener(Event.CANCEL, onCancelHandler);
		}
		
		protected function onCancelHandler(evt:Event):void 
		{
			_onCancelCallback();
			_onCancelCallback = null;
			_fileRefList.removeEventListener(Event.CANCEL, onCancelHandler);
			_fileRefList.removeEventListener(Event.SELECT, onSelectHandler);
		}
		
		
		public function getName(index:int):String{
			return _fileRefList.fileList[index].name;
		}
		
		public function getSize():uint {
			return _fileRefList.fileList[0].size;
		}
		
		public function getFileListSize():int {
			var size:int = 0;
			if (_fileRefList.fileList.length > 1)
			{
				size = _fileRefList.fileList[0].size + _fileRefList.fileList[1].size;
			}else if (_fileRefList.fileList.length == 1)
			{
				size = _fileRefList.fileList[0].size;
			}else {
				size = 0;
			}
			return size;
		}
		
		public function getFilesLength():int {
			if (_fileRefList.fileList == null)
			{
				return 0;
			}
			return _fileRefList.fileList.length;
		}
		
		public function getType(index:int):String {
			
			var aImages:Array = IMAGE.split(";");
			for (var i:uint = 0; i < aImages.length; i++) {
				if ((aImages[i] as String).substr(1).toLowerCase() == _fileRefList.fileList[index].type.toLowerCase()) {
					return IMAGE;
				}
			}
			
			var aVideos:Array = VIDEO.split(";");
			
			for (var j:uint = 0; j < aVideos.length; j++) {
				//Output.trace((aVideos[j] as String) +" // "+ _fileRef.type);
				if ((aVideos[j] as String).substr(1).toLowerCase() == _fileRefList.fileList[index].type.toLowerCase()) {
					return VIDEO;
				}
			}
			return "";
		}
		/**
		 * only Player 10+
		 * Access the getter byteData to get the user file in ByteArray format
		 * 
		 * @param	callback
		 * @param	verbose
		 * @return
		 */
		public function load(index:int,callback:Function = null):Boolean 
		{
			_onCompleteCallback = callback;
		
			try {
				_fileRefList.fileList[index].load();
				return true;
			} catch (err:MemoryError) {
				if (_verbose) {
					onMemoryError(err.message);
				}
				return false;
			}catch (err:IllegalOperationError) {
				if (_verbose) {
					onIllegalOperationError(err.message);
				}
				return false;
			}
			
			return false;
		}
		
		/**
		 * 
		 * @param	path		: url of the server side script. In PHP use $_FILES collection as with a normal html form with multipart form data
		 * @param	params		: extra variables
		 * @param	nocache
		 * @param	callback	: called when a http code 200 was returned from de server after a successful upload
		 * @param	uploadDataFieldName	: custom name for the field that contains the file
		 * @return
		 */
		public function upload( index:int, path:String, params:Object = null, nocache:Boolean = true, completeCallback:Function = null, dataReadyCallback:Function = null, uploadDataFieldName:String = "Filedata"):Boolean {
			//trace("função upload, index: "+index+", path: "+path+", params: "+params.userid+", "+params.type+", "+params.txttitle+", "+params.txtcontent+", "+params.blogid)
			_onCompleteCallback = completeCallback;
			_onDataReadyCallback = dataReadyCallback;
						
			if (nocache) {
				var numero:Number = Math.round(999999*Math.random());
				_request = new URLRequest(path+"?nocache="+numero);
			}else{
				_request = new URLRequest(path);
			}
			
			_index = index;
			
			if (this.getFilesLength() != 0 )
			{
				_fileRefList.fileList[_index].addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onDataUploaded);
			}
			
			var debugstr:String = "";
			if (params) {
				_parametros = new URLVariables();
				for (var chave in params) {
					//trace(parametros[chave]);
				
					_parametros[chave] = params[chave];
					debugstr += " \n "+ chave.toString() + " : " +_parametros[chave].toString();
				}
				_request.data = _parametros;
				
				//trace(debugstr);

			}
			
			_request.method = URLRequestMethod.POST;
			
			try {
				if (this.getFilesLength() != 0 )
				{
					_fileRefList.fileList[index].upload(_request, uploadDataFieldName);
				}
				else
				{
					var urlLoader:URLLoader = new URLLoader();
					urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
					urlLoader.addEventListener(Event.COMPLETE, onlyTextDataUploaded, false, 0, true);
					urlLoader.load(_request);
				}
				
				if (_verbose) {
					
				}
				return true;
			} catch (err:Error) {
				if (_verbose) {
					onGenericError(err.message);
				}
				return false;
			}catch (err:IllegalOperationError) {
				if (_verbose) {
					onIllegalOperationError(err.message);
				}
				return false;
			}catch (err:SecurityError) {
				if (_verbose) {
					onSecurityError(err.message);
				}
				return false;
			}
			
			return false;
		}
		
		
		protected function onProgress(evt:ProgressEvent):void {
			
			_loadPercent = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
			
			dispatchEvent(evt);
			
		}
		
		public function get loadPercent():int {
			return _loadPercent;
		}
		
		/**
		 * Called when upload returned an http code of 200
		 * @param	evt
		 */
		protected function onComplete(evt:Event):void 
		{
			
			_byteData = _fileRefList.fileList[0].data
			dispatchEvent(evt);
			if (_onCompleteCallback != null) {
				_onCompleteCallback();
			}
			
			if (_verbose) {
				//trace("Server available");
				
			}
			
		}
		
		/**
		 * Called when a server response was received after a successful upload
		 * @param	evt
		 */
		protected function onDataUploaded(evt:DataEvent){
			_serverRawData = evt.data;
			dispatchEvent(evt);
			
			if (_onDataReadyCallback != null) {
				_onDataReadyCallback();
			}
			
			if (_verbose) {
				trace("Server responded: "+evt.data);
			}
			
		}
		
		protected function onlyTextDataUploaded(evt:Event){
			_serverRawData = evt.target.data;
			dispatchEvent(evt);
			
			if (_onDataReadyCallback != null) {
				_onDataReadyCallback();
			}
			
			if (_verbose) {
				trace("Server responded: "+evt.target.data);
			}
			
		}
		
		public function get byteData():ByteArray {
			return _byteData;
		}
		
		public function get serverRawData():* {
			return _serverRawData;
		}
		
		
		public function get serverUrlData():URLVariables {
			_urlData = new URLVariables(_serverRawData);
			return _urlData;
		}
		
		
		
		public function download(index:int, url:String, fileName:String  = null, selectCallback:Function = null, cancelCallback:Function = null, completeCallback:Function = null):Boolean 
		{
			if (selectCallback != null) {
				_onSelectCallback = selectCallback;
				_fileRefList.addEventListener(Event.SELECT, onSelectHandler, false, 0, true);
			}
			if (cancelCallback != null) {
				_onCancelCallback = cancelCallback;
				_fileRefList.addEventListener(Event.CANCEL, onCancelHandler, false, 0, true);
			}
			
			_onCompleteCallback = completeCallback;
			
			
			var request:URLRequest = new URLRequest(url);
			
			try{
				_fileRefList.fileList[index].download(request, fileName);
				return true;
			}catch (err:Error) {
				if (_verbose) {
					onGenericError(err.message);
				}
				return false;
			}catch (err:IllegalOperationError) {
				if (_verbose) {
					onIllegalOperationError(err.message);
				}
				return false;
			}catch (err:SecurityError) {
				if (_verbose) {
					onSecurityError(err.message);
				}
				return false;
			}catch (err:MemoryError) {
				if (_verbose) {
					onMemoryError(err.message);
				}
				return false;
			}
			
			return false;
		}
		
		
		public function save(index:int, data:*, fileName:String  = null, selectCallback:Function = null, cancelCallback:Function = null, completeCallback:Function = null):Boolean 
		{
			if (selectCallback != null) {
				_onSelectCallback = selectCallback;
				_fileRefList.addEventListener(Event.SELECT, onSelectHandler, false, 0, true);
			}
			if (cancelCallback != null) {
				_onCancelCallback = cancelCallback;
				_fileRefList.addEventListener(Event.CANCEL, onCancelHandler, false, 0, true);
			}
			
			_onCompleteCallback = completeCallback;
			
					
			try{
				_fileRefList.fileList[index].save(data, fileName);
				return true;
			}catch (err:Error) {
				if (_verbose) {
					onGenericError(err.message);
				}
				return false;
			}catch (err:IllegalOperationError) {
				if (_verbose) {
					onIllegalOperationError(err.message);
				}
				return false;
			}catch (err:MemoryError) {
				if (_verbose) {
					onMemoryError(err.message);
				}
				return false;
			}
			
			return false;
		}
		
		protected function onHTTPStatusEvent(evt:HTTPStatusEvent):void {
			if (_verbose) {
				trace("HTTP status code: "+evt.status);
			}

		}
		

		protected function openHandler(event:Event):void {
			if (_verbose) {
				trace("openHandler: " + event);
			}
        }
        
        protected function ioErrorHandler(event:IOErrorEvent):void {
			if (_verbose) {
				trace("ioErrorHandler: " + event);
			}
        }

       
        protected function securityErrorHandler(event:SecurityErrorEvent):void {
			if (_verbose) {
				trace("securityErrorHandler: " + event);
			}
        }
		
		protected function onIllegalOperationError(msg:String) { printError("UserFileHandler->onIllegalOperationError: "+msg) }
		protected function onSecurityError(msg:String) {printError("UserFileHandler->onSecurityError: "+msg) }
		protected function onMemoryError(msg:String) {printError("UserFileHandler->onMemoryError: "+msg) }
		protected function onGenericError(msg:String) { printError("UserFileHandler->onGenericError: " + msg) }
		
		protected function printError(msg:String):void {
			//trace(msg);
		}
			
	}
}

