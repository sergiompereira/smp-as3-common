package com.smp.common.display.loaders
{
	
	public class RectangleOptions 
	{
		public static  const RIGHT:uint= 3;
		public static  const CENTRE:uint= 2;
		public static  const LEFT:uint = 1;
		
		public var align:uint = 2;

		public var backgroundColor:uint = 0xffffff;
		public var foregroundColor:uint = 0x000000;
		public var backgroundAlpha:Number = 1;
		public var foregroundAlpha:Number = 1;
		public var foregroundShadow:Boolean = false;
		public var backgroundShadow:Boolean = true;
		
		protected var _border:Object = null;
		protected var _position:Object = null;
		protected var _holderDimension:Object = null;
		
		
		public function RectangleOptions() {
			
		}
		
		public function setBorder(thickness:Number, color:Number, alpha:Number = 1):void {
			_border = { thickness:thickness, color:color, alpha:alpha };
		}
		
		public function setHolderDimension(width:Number, height:Number):void {
			_holderDimension = {width:width, height:height};
		}
		
		public function setPosition(x:Number, y:Number):void {
			_position = { x:x, y:y };
		}
		
		public function get border():Object {
			return _border;
		}
		
		public function get holderDimension():Object {
			return _holderDimension;
		}
		
		public function get position():Object {
			return _position;
		}
	}
	
}