package com.smp.common.math{

	import com.smp.common.math.GeometryVector;
	
	
	public class MathUtils {
		
		public static function scale(valor:Number, inMin:Number , inMax:Number , outMin:Number , outMax:Number):Number {
			
			return (valor - inMin) / (inMax - inMin) * (outMax - outMin) + outMin;
			
		}
	}	
}