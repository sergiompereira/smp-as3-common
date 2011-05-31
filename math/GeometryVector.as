package com.smp.common.math
{
	

	public class GeometryVector 
	{
		private var _angle:Number = 0;
		private var _magnitude:Number = 0;
		
		public function GeometryVector(angle:Number, magnitude:Number):void {
			
			_angle = angle;
			_magnitude = magnitude;
		}
		
		public function get angle():Number {
			return _angle;
		}
		
		public function set angle(value:Number):void {
			_angle = value;
		}
		
		public function get magnitude():Number {
			return _magnitude;
		}
		
		public function set magnitude(value:Number):void {
			_magnitude = value;
		}
	}
	
}