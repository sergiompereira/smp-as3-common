package com.smp.common.display{

	import flash.display.Bitmap;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.geom.ColorTransform;
	import flash.filters.ColorMatrixFilter;
		

	/**
	 * @see ascb.util.DisplayObjectUtilities
	 * @author Sergio Pereira
	 */

	public class DisplayObjectUtilities {


		public function DisplayObjectUtilities() {
			
		}
		
		
		/**
		 * Remove all of the children in a container
		 * @param	container
		 */ 
		public static function removeAllChildren( container:DisplayObjectContainer ):void {
			  
			// Because the numChildren value changes after every time we remove
			// a child, save the original value so we can count correctly
			var count:int = container.numChildren;
			
			// Loop over the children in the container and remove them
			for ( var i:int = 0; i < count; i++ ) {
				container.removeChildAt( 0 );
			}
		}
		
		/**
		 * Removes de specified object
		 * @param	container
		 * @param	obj
		 */
		public static function removeObj(container:DisplayObjectContainer, obj:DisplayObject):void {
			
			if(obj!=null && container.contains(obj)){
				container.removeChild(obj);
			}
			
		}
		
		/**
		 * Delete all of the children in a container
		 * @param	container
		 */
		public static function deleteAllChildren( container:DisplayObjectContainer ):void {
			  
			// Because the numChildren value changes after every time we remove
			// a child, save the original value so we can count correctly
			var count:int = container.numChildren;
			
			// Loop over the children in the container and remove them
			for ( var i:int = 0; i < count; i++ ) {
				delete container.getChildAt(0);
				container.removeChildAt(0);
			}
		}
		
		/**
		 *
		 * @param	obj
		 * @param	container
		 * @param	area
		 * @param	centerPoint
		 */
		public static function centerObject(obj:DisplayObject, container:DisplayObjectContainer = null, area:Array = null, centerPoint:Boolean = true):void{
			var factor:int = 2;
			if(centerPoint == false){
				factor = 1;
			}
			
			if(area == null){
				obj.x = container.width/2 - obj.width/factor;
				obj.y = container.height/2 - obj.height/factor;
			}else{
				obj.x = area[0]/2 - obj.width/factor;
				obj.y = area[1]/2 - obj.height/factor;
			}
		}
		
		
		/**
		 * 
		 * @param	obj		: any subclass of DisplayObject which has the public property 'filters'
		 * @param	brightness	: a value between 0 and 1. 0.1 returns no change. A reasonable span: 0.02-0.18
		 * @param	contrast	: a value between 0 and 1. 0.1 is aprox. the value that returns no change. A reasonable span: 0.02-0.42, so the neutral value is aprox. at 13% of the entire range.
		 */
		public static function setBrightnessContrast(obj:DisplayObject, brightness:Number, contrast:Number):void {
						
			//value between 0-1
			var a = contrast * 11;
			var b = 63.5 - (contrast * 698.5);
			var _brightness:Number = brightness*10*a;
			
			
			obj.filters = [
							new ColorMatrixFilter(
													[
														_brightness,0,0,0,b,
														0,_brightness,0,0,b,
														0,0,_brightness,0,b,
														0,0,0,1,0
													]
												)
							];
		}
		
		
		public static function createReflection(obj:DisplayObjectContainer, alpha:Number = 1, ratio:Number = 255, distance:Number = 15, interval:Number = 0):void {
			
				var bmpData:BitmapData;
				var updateInt:Number;
			
				bmpData = new BitmapData(obj.width, obj.height);
				bmpData.draw(obj);
				var bitmap:Bitmap = new Bitmap(bmpData, "auto", true);
				bitmap.scaleY = -1;
				bitmap.y = 2*obj.height + distance;
				
				
				var mask = new Shape();
				with (mask.graphics) {
					var matrix:Matrix = new Matrix();
					matrix.createGradientBox(obj.width, obj.height, Math.PI/2,0,0);
					beginGradientFill(GradientType.LINEAR, new Array(0x000000, 0x000000), new Array(alpha,0), new Array(0,ratio), matrix);
					drawRect(0,0, obj.width, obj.height);
					endFill();
				}
				
				//position the gradient mask
				mask.y = obj.height + distance;
				
				//cache the bitmap holding movieclips as bitmaps
				bitmap.cacheAsBitmap = true;
				mask.cacheAsBitmap = true;
				bitmap.mask = mask;
				
				obj.addChildAt(bitmap, 0);
				obj.addChildAt(mask,1);
				
				if (interval>0)
				{
					var updater:Timer = new Timer(interval);
					updater.addEventListener(TimerEvent.TIMER, update);
					updater.start();
				}
				
				
				function update(evt:TimerEvent):void {
					bmpData.draw(obj);
					bitmap.bitmapData = bmpData;
				}
		
		}
		
		public static function crossColorFade(obj:DisplayObject, initcolor:uint, endcolor:uint, coeff:Number = 1):void {
			
			var colorTrsf:ColorTransform = new ColorTransform();
			colorTrsf.color = endcolor;
			//trace(colorTrsf.redOffset + " " + colorTrsf.greenOffset + " " + colorTrsf.blueOffset);
	
			var goalRed = colorTrsf.redOffset;
			var goalGreen = colorTrsf.greenOffset;
			var goalBlue = colorTrsf.blueOffset;
			
			
			colorTrsf.color = initcolor;
			//trace(colorTrsf.redOffset + " " + colorTrsf.greenOffset + " " + colorTrsf.blueOffset);
			
			var timer:Timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			
			
			
			function onTimer(evt:TimerEvent) {
				//trace(Math.abs(colorTrsf.redOffset-goalRed)+" "+ Math.abs(colorTrsf.greenOffset-goalGreen)+" "+  Math.abs(colorTrsf.blueOffset-goalBlue))
				
				if(Math.abs(colorTrsf.redOffset-goalRed)>10 || Math.abs(colorTrsf.greenOffset-goalGreen)>10 || Math.abs(colorTrsf.blueOffset-goalBlue)>10){
				
					colorTrsf.redOffset += getNewValue(colorTrsf.redOffset, goalRed);
					colorTrsf.greenOffset += getNewValue(colorTrsf.greenOffset, goalGreen);
					colorTrsf.blueOffset += getNewValue(colorTrsf.blueOffset, goalBlue);
					
					obj.transform.colorTransform = colorTrsf;
				
				}else {
					timer.removeEventListener(TimerEvent.TIMER, onTimer);
					timer.stop();
				}
				
				
			}
			
			function getNewValue(orig:int, dest:int):int {
				
				return (dest - orig) / coeff;
				
			}
			
			
		}
		
		/**
		 * Draws a line along the path traced by a DisplayObject
		 */
		public static function drawObjectPath(obj:DisplayObject, lineWidth:Number = 1, lineColor:Number = 0x990000):void{
		
			try{
				var parent:DisplayObjectContainer = obj.parent;
				var shape:Shape = new Shape();
				shape.graphics.lineStyle(lineWidth, lineColor);
				shape.graphics.moveTo(obj.x, obj.y);
				parent.addChildAt(shape, 0);
				parent.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}catch (err:*) {
				throw new IllegalOperationError("DisplayObjectUtilities::drawObjectPath -> Add the object to the display list.");
			}
			
			function onEnterFrame(evt:Event):void {
				shape.graphics.lineTo(obj.x,obj.y);
			}
			
		}
		
		
	}
}