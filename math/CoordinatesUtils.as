package com.smp.common.math{
	
	import flash.geom.Point;
	
	
	public class CoordinatesUtils{
		
		public function CoordinatesUtils(){
			
		}
		
		public static function getDirectionAngle(startPoint:Point, endPoint:Point):Number 
		{
			var directionAngle:Number = Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
			return directionAngle*180/Math.PI;
		}
		
		public static function getDirectionRadians(startPoint:Point, endPoint:Point):Number 
		{
			var directionAngle:Number = Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
			return directionAngle;
		}
		
		/**
		 * 
		 * @param	startPoint
		 * @param	endPoint
		 * @return 	returns values from 0 to 8, defining octants between 0 and Math.PI*2 (360º)
		 */
		public static function getDirectionFactor(startPoint:Point, endPoint:Point):Number 
		{
			
			var directionAngle:Number = Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
			return directionAngle*(4 / Math.PI);
		}
	}
}