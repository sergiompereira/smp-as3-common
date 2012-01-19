package com.smp.common.display.loaders{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.utils.ByteArray;
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;
	
	import com.smp.common.bitmap.BitmapResampler;
	import com.smp.common.display.DisplayObjectUtilities;
	import com.smp.common.utils.StringUtils;


	public class BitmapLoader extends DisplayObjectLoader {

		public static const PARSE_ERROR:String = "PARSE_ERROR";

		private var _smooth:Boolean;
		private var _image:Bitmap;
		private var _bitmapdata:BitmapData;
		
		protected var _fileType:String;
		protected var _scale:Number;
		protected var _fadein:Number;
		protected var _center:Boolean;
		
		protected var _tween:GTween;
		
		public function BitmapLoader(smooth:Boolean = false, verbose:Boolean = false, recursive:Boolean = false, scale:Number = 1, fadein:Number = 0, checkPolicy:Boolean = false, center:Boolean = false) {
			_smooth = smooth;
			_scale = scale;
			_fadein = fadein;
			_center = center;
			
			super("", verbose, recursive, checkPolicy);

		}
		
		/**
		 * 
		 * @param	url			: the file to load
		 * @param	callback	: expect this object as argument
		 */
		override public function load(url:String, callback:Function = null):void {
			if (_image != null && this.contains(_image)) {
				removeChild(_image);
			}
			_fileType = StringUtils.extractExtension(url);
			super.load(url, callback);
		}
		
		
		public function loadBytes(data:ByteArray, callback:Function = null):void {
			
			_onCompleteCallback = callback;
			
			_loader.loadBytes(data, _context);
		}
		
		public function set centered(value:Boolean):void {
			_center = value;
		}
		
		override protected function addDisplayObject()
		{
			
			DisplayObjectUtilities.deleteAllChildren(this);
			
			try{
				_image = Bitmap(_loader.content);
			}catch (err:*) {
				trace("LoadBitmap->addDisplayObject: "+err.message);
				dispatchEvent(new Event(BitmapLoader.PARSE_ERROR));
				return;
			}
			
			//removes loader reference to content, as it will be moved to this (prevents error)
			//see content getter override bellow...
			super.unLoad();
			
			//para futuras necessidades...
			_bitmapdata = _image.bitmapData;

			if (_smooth) {
				_image.smoothing = true;
			}
			
			addChild(_image);
			
			
			if (_scale < 1) {
				this.alpha = 0;
				this.scaleImage(_scale);
			}
			
			if (_center) {
				this.centerImage();
			}
			
			if (_fadein > 0) {
				if (_tween == null) _tween = new GTween(this);
				this.alpha = 0;
				_tween.setValue("alpha", 1);
				_tween.duration = _fadein;
				_tween.ease = Sine.easeIn;
				//_tween.setTween(this, "alpha", TweenSafe.REG_EASEIN, 0, 1, _fadein);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (_onCompleteCallback != null) {
				_onCompleteCallback(this);
			}
			
		}
	
		//also see bitmap getter bellow...
		override public function get content():*
		{
			return _image;
		}
		
		override protected function onIOError(evt:IOErrorEvent):void {
			dispatchEvent(evt);
		}
		
		public function get bitmapData():BitmapData{
			return _bitmapdata;
		}
		
		public function get bitmap():Bitmap {
			//avoid reparenting...
			return new Bitmap(_bitmapdata, "auto", _smooth);
		}
		
		public function get bitmapDataWidth():Number{
			return _bitmapdata.width;
		}
		public function get bitmapDataHeight():Number{
			return _bitmapdata.height;
			
		}
		
		public function scaleImage(scale:Number) 
		{
			if (scale < 1)
			{
				var bitmapDataWidth:Number = _bitmapdata.width*scale;
				var bitmapDataHeight:Number = _bitmapdata.height*scale;
							
				var dest:BitmapData;
				/*if (_fileType == "png") {
					dest = new BitmapData(bitmapDataWidth, bitmapDataHeight, true, 0x00FFFFFF);
				}else {
					dest = new BitmapData(bitmapDataWidth, bitmapDataHeight, false);
				}*/
				
				dest = new BitmapData(bitmapDataWidth, bitmapDataHeight, false);

				var sampler:BitmapResampler = new BitmapResampler();
				sampler.resample(_bitmapdata, dest, true, scale);

				var imageresampled:Bitmap = new Bitmap(dest);
				DisplayObjectUtilities.deleteAllChildren(this);
				
				_image = imageresampled;
				_bitmapdata = _image.bitmapData;
				addChild(_image);
				
				/*if (_fadein>0) {
					_tween.setTween(this, "alpha", TweenSafe.REG_EASEIN, 0, 1, _fadein);
				}else {
					//this.alpha = 1;
				}*/
			}
			
		}
		
		public function constrainImageWidth(width:Number):void {
			
			var scale = width / _bitmapdata.width;			
			this.scaleImage(scale);
		}
		
		public function constrainImageHeight(height:Number):void {
			
			var scale = height / _bitmapdata.height;			
			this.scaleImage(scale);
		}
		
		public function centerImage():void {
			if (_image != null) {
				_image.x = -this.bitmapDataWidth * 0.5;
				_image.y = -this.bitmapDataHeight * 0.5;
			}
		}
		
		public function removeImage() {
			DisplayObjectUtilities.deleteAllChildren(this);
		}
	}
}