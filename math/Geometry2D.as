package com.smp.common.math
{
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	
	public class  Geometry2D
	{
		public static const RADIAN:String = "RADIAN";
		public static const DEGREE:String = "DEGREE";
		
		public static function degreeToRadian(deg:Number):Number {
			return deg * (Math.PI / 180) % (2*Math.PI);
		}
		
		public static function radianToDegree(rad:Number):Number {
			return rad  * (180/Math.PI) % 360;
		}
		
		public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			return Math.sqrt(dx*dx+dy*dy);
		}
		
		/**
		 * 
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @return	GeometryVector, which angle is in radians, measured counterclockwise from the positive X axis, between 0 and Math.PI*2
		 */
		public static function getVector(x1:Number, y1:Number, x2:Number, y2:Number):GeometryVector {
			
			var magnitude:Number =  Geometry2D.getDistance(x1, y1, x2, y2);
			
			var angle:Number = Math.atan2(y2-y1, x2-x1);
			
			if (angle < 0) {
				angle = -angle;
			}else if (angle >= 0) {
				angle = Math.PI * 2 - angle;
			}
			
			return new GeometryVector(angle, magnitude);
			
			
		}
		
		public static function getLineAngle(startPoint:Point, endPoint:Point, outputType:String = RADIAN):Number 
		{
			var directionAngle:Number = Math.atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x);
			if (directionAngle < 0) {
				directionAngle = 2*Math.PI + directionAngle;
			}
			if (outputType == DEGREE) {
				return directionAngle*180/Math.PI;
			}
			//default to radians
			return directionAngle;	
		}
		
		public static function rotatePoint(axis:Point, point:Point, angle:Number):Point {
			var delta:Point = new Point(point.x - axis.x, point.y - axis.y);
			var rpoint:Point = new Point();
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			
			rpoint.x = delta.x * cos - delta.y * sin;
			rpoint.y = delta.x * sin + delta.y * cos;
			rpoint.x += axis.x;
			rpoint.y += axis.y;
			
			return rpoint;
		}
		
		/**
		 * If input size is minor than bounding size, it returns the input size, no change.
		 * @param	inputSize		: Rectangle 
		 * @param	boundingSize	: Rectangle 
		 * @return	Rectangle 		
		 */
		public static function reduceRectangle(inputSize:Rectangle, maxSize:Rectangle):Rectangle {
			
			var propref:Number = maxSize.width / maxSize.height;
			var prop:Number = inputSize.width / inputSize.height;
			var outputSize:Rectangle = new Rectangle();
			
			if (inputSize.width > maxSize.width || inputSize.height > maxSize.height) {
				if (propref > 1) {
					//se horizontal
					if (prop >= propref) {
						//horizontal e mais largo na  proporção
						outputSize.width = maxSize.width;
						outputSize.height = inputSize.width / prop;
					}else {
						//((prop < propref && prop > 1) || prop <= 1)
						//horizontal mas mais estreito na proporção ou vertical ou quadrado
						outputSize.width  = inputSize.height * prop;
						outputSize.height =  maxSize.height;
					}
				}else{
					//se vertical ou quadrado
					if (prop <= propref) {
						//vertical e mais alto na  proporção
						outputSize.width = inputSize.height * prop;
						outputSize.height =  maxSize.height;
					}else{
						//((prop > propref && prop < 1) || prop >= 1)
						//vertical mas mais baixo na proporção ou horizontal ou quadrado
						outputSize.width = maxSize.width;
						outputSize.height = inputSize.width / prop;
					}
				}
			}else {
				outputSize = inputSize;
			}
			
			return outputSize;
		}
	}
	
}