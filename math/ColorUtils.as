package com.smp.common.math
{

	
	public class  ColorUtils
	{
		
		/**
		 * Expected 0 to 255...
		 * @param	r
		 * @param	g
		 * @param	b
		 */
		public static function decimalToHexadecimal(r:Number = 0, g:Number = 0, b:Number = 0):Number {	
			
			var _aIndex = new Array();
			_aIndex = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];	
			
			var _aColors = new Array();
			
			var i:uint=0;
			var j:uint=0;
			var l:uint=0;
			while(j<=15){
				if(l<=15){
					_aColors[i] = _aIndex[j]+_aIndex[l];
					i++;
					l++;
				}else{
					j++;
					l=0;	
				}
			}
			
			return Number("0x"+_aColors[r] +_aColors[g] +_aColors[b]);
			
		}
		
		/**
		 * @author			: http://www.pixelwit.com/blog/2008/05/color-fading-array/
		 * 
		 * @param	data	: should be a collection of colors separated by the number of steps, eg. [0xFF0000,   1,   0x000000,   3,   0xFFFFFF]
		 * @return
		 */
		public static function getGradient (data:Array):Array{
			//
			// Note the length of our array.
			var len = data.length-1;
			//
			// Create an array to store all colors.
			var newArry = [];
			//
			// For every pair of colors.
			for(var i=0; i<len; i+=2){
				//
				// Note the color pair.
				var hex = data[i];
				var hex2 = data[i+2];
				//
				// Add the first color to the array.
				newArry.push(hex);
				//
				// Break the first color into RGB components.
				var r = hex >> 16;
				var g = hex >> 8 & 0xFF;
				var b = hex & 0xFF;
				//
				// Determine RGB differences between the first and second colors.
				var rd = (hex2 >> 16)-r;
				var gd = (hex2 >> 8 & 0xFF)-g;
				var bd = (hex2 & 0xFF)-b;
				//
				// Retrieve number of new colors between first and second color.
				var steps = data[i+1]+1;
				//
				// For each new color.
				for (var j=1; j<steps; j++){
					//
					// Determine where the color lies between the 2 end colors.
					var ratio = j/steps;
					//
					// Determine RGB values, combine into 1 hex color and add it to the array.
					newArry.push((r+rd*ratio)<<16 | (g+gd*ratio)<<8 | (b+bd*ratio));
				}
			}
			//
			// Add the last color to the end of the array.
			newArry.push(data[len]);
			//
			// Return the new array of colors.
			return newArry;
		}
		
	}
	
}