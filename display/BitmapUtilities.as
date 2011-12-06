package com.smp.common.display{
	


	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;

	import com.smp.common.bitmap.BitmapResampler;
	
	import com.adobe.images.JPGEncoder; 
	import com.adobe.images.PNGEncoder; 
	

	public class BitmapUtilities{
		
		public static const JPG:String = "jpg";
		public static const PNG:String = "png";
	
		
		public function BitmapUtilities() {
			
		}
		
		/**
		 * 
		 * @param	_bitmap
		 * @param	_scale	value between 0 and 1.
		 * @return
		 */
		public static function scale(_bitmap:Bitmap, _scale:Number):Bitmap
		{
			
			
			var width:Number = _bitmap.bitmapData.width*_scale;
			var height:Number = _bitmap.bitmapData.height*_scale;

			var dest:BitmapData = new BitmapData(width, height, true);

			var sampler:BitmapResampler = new BitmapResampler();
			sampler.resample(_bitmap.bitmapData, dest, true, _scale);

			_bitmap.bitmapData = null;
			_bitmap = new Bitmap(dest);
			
			return _bitmap;
			
		}
		
		public static function resize(_bitmap:Bitmap, width:Number = 0, height:Number = 0):Bitmap 
		{	
			if(width > 0){
				height = width*(_bitmap.bitmapData.height/_bitmap.bitmapData.width);
			}else if(height >0){
				width = height*(_bitmap.bitmapData.width/_bitmap.bitmapData.height);
			}
			
			var _scale:Number = Math.round(width/_bitmap.bitmapData.width * 100) / 100;
			
			var dest:BitmapData = new BitmapData(width, height, true);

			var sampler:BitmapResampler = new BitmapResampler();
			sampler.resample(_bitmap.bitmapData, dest, true, _scale);

			_bitmap.bitmapData = null;
			_bitmap = new Bitmap(dest);
			
			return _bitmap;
		}
		
		/**
		 * 
		 * @param	bitmap
		 * @param	format		whether PNG or JPG
		 * @param	quality		from 0 to 100, if JPG format defined
		 * @return
		 */
		public static function encodeToByteArray(bitmap:Bitmap, format:String, quality:Number = 85):ByteArray {
			
			var bmpData:BitmapData = bitmap.bitmapData;
			
			switch(format) {
				case JPG:
					var jpgEncoder:JPGEncoder = new JPGEncoder(quality);
					var jpgStream:ByteArray = jpgEncoder.encode(bmpData);
					return jpgStream;
				break;
				
				case PNG:
					var pngStream:ByteArray = PNGEncoder.encode(bmpData);
					return pngStream;
				break;
			}
			
			return null;
			
		}
		
		
		public static function objectToBitmap(object:DisplayObject, smooth:Boolean = false, region:Rectangle = null):Bitmap 
		{
			var bmpData:BitmapData;
			var matrix:Matrix = object.transform.matrix;
			if (region == null) {
				
				bmpData = new BitmapData (object.width, object.height, true, 0x00FFFFFF);
			}else {
				matrix.tx = -region.x;
				region.x = 0;
				matrix.ty = -region.y;
				region.y = 0;
				bmpData = new BitmapData (region.width, region.height, true, 0x00FFFFFF);
			}
			
			bmpData.draw(object, matrix, object.transform.colorTransform, null, region);
			
			var bmp:Bitmap = new Bitmap(bmpData, "auto", smooth);
			return bmp;
		}
		
		
		
		/**
		 * Returns a BitmapData with the transparent pixels filled with the specified color
		 * @param	bmpData
		 * @param	mapColor
		 * @param	alphaThreshold	: the minium alpha value that is considered opaque
		 * @return
		 */
		public static function getTransparencyMap(bmpData:BitmapData, alphaThreshold:uint = 0x01, mapColor:uint=0xFF00FF00):BitmapData{

			var hit_bmd:BitmapData=new BitmapData(bmpData.width, bmpData.height, true, 0x00ffffff);
			
			for(var i:uint = 1; i < bmpData.height; i++){
				
				for (var j:uint = 1; j < bmpData.width; j++){
					if(!bmpData.hitTest(new Point(), alphaThreshold, new Point(j, i))){
						hit_bmd.setPixel32(j, i, mapColor);
					}
				}

			}

			return hit_bmd;

		}
		
		
		/**
		 * Returns a BitmapData with the inner transparent pixels filled with the specified color (useful for frames...)
		 * @param	bmpData
		 * @param	alphaThreshold
		 * @param	mapColor
		 * @return
		 */
		public static function getInnerTransparencyMap(bmpData:BitmapData,  alphaThreshold:uint = 0x01, mapColor:uint=0xFF00FF00):BitmapData{
			
			
			var opaqueColor:uint = mapColor;
			var transparentColor:uint = 0x00ffffff;
			
			var hit_bmd:BitmapData=new BitmapData(bmpData.width, bmpData.height, true, opaqueColor);
			
			var innerArea:Boolean = false;
			
			function processPixelColor(x:Number, y:Number):void 
			{
				if (!bmpData.hitTest(new Point(), alphaThreshold, new Point(x, y))) 
				{
					if(hit_bmd.getPixel32(x, y) != transparentColor){
						if (!innerArea) {
							hit_bmd.setPixel32(x, y, transparentColor);
						}
					}
				}else {
					if (!innerArea) {
						innerArea = true;
					}
					hit_bmd.setPixel32(x, y, transparentColor);
				}
			}
			
			var midwidth:Number = Math.floor(bmpData.width / 2);
			for(var i:uint = 0; i < bmpData.height; i++){
				
				for (var j:uint = 0; j <= midwidth; j++){
					processPixelColor(j, i);
				}
				innerArea = false;

			}
			
			innerArea = false;
			for(i = 0; i < bmpData.height; i++){
				
				for (j = bmpData.width; j > midwidth; j--){
					processPixelColor(j, i);
				}
				innerArea = false;

			}
			
			innerArea = false;
			var midheight:Number = Math.floor(bmpData.height / 2);
			for(i = 0; i < bmpData.width; i++){
				
				for (j = 0; j <= midheight; j++){
					processPixelColor(i, j);
				}
				innerArea = false;

			}
			
			innerArea = false;
			var midheight:Number = Math.floor(bmpData.height / 2);
			for(i = 0; i < bmpData.width; i++){
				
				for (j = bmpData.height; j > midheight; j--){
					processPixelColor(i, j);
				}
				innerArea = false;

			}

			return hit_bmd;

		}

	}

}