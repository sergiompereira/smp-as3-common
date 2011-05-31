package com.smp.common.math{

	import com.smp.common.math.GeometryVector;
	
	
	public class MathUtils {
		
		public static function scale(valor:Number, inMin:Number , inMax:Number , outMin:Number , outMax:Number):Number {
			
			return (valor - inMin) / (inMax - inMin) * (outMax - outMin) + outMin;
			
		}
		
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
			
			var magnitude:Number =  MathUtils.getDistance(x1, y1, x2, y2);
			
			var angle:Number = Math.atan2(y2-y1, x2-x1);
			
			if (angle < 0) {
				angle = -angle;
			}else if (angle >= 0) {
				angle = Math.PI * 2 - angle;
			}
			
			return new GeometryVector(angle, magnitude);
			
			
		}
		
		/**
		 * If input size is minor than bounding size, it returns the input size, no change.
		 * @param	inputSize		: Array with values Width and Height respectively on indexes 0 and 1
		 * @param	boundingSize	: Array with values Width and Height respectively on indexes 0 and 1
		 * @return	Array 			: with values Width and Height respectively on indexes 0 and 1
		 */
		public static function constrainSize2D(inputSize:Array, boundingSize:Array):Array {
			
			var propref:Number = boundingSize[0] / boundingSize[1];
			var prop:Number = inputSize[0] / inputSize[1];
			var outputSize:Array = new Array();
			
			if (inputSize[0] > boundingSize[0] || inputSize[1] > boundingSize[1]) {
				if (propref > 1) {
					//se horizontal
					if (prop >= propref) {
						//horizontal e mais largo na  proporção
						outputSize = [boundingSize[0], inputSize[0]/prop];
					}else {
						//((prop < propref && prop > 1) || prop <= 1)
						//horizontal mas mais estreito na proporção ou vertical ou quadrado
						outputSize = [inputSize[1]*prop, boundingSize[1]];
					}
				}else{
					//se vertical ou quadrado
					if (prop <= propref) {
						//vertical e mais alto na  proporção
						outputSize = [inputSize[1]*prop, boundingSize[1]];
					}else{
						//((prop > propref && prop < 1) || prop >= 1)
						//vertical mas mais baixo na proporção ou horizontal ou quadrado
						outputSize = [boundingSize[0], inputSize[0]/prop];
					}
				}
			}else {
				outputSize = inputSize;
			}
			
			return outputSize;
		}
	}	
}