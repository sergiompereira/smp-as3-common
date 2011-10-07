package com.smp.common.utils
{
	
	/**
	 * @see also ascb.util.ArrayUtilities
	 * @author Sergio Pereira
	 */
	import com.smp.common.math.NumberUtils;
	
	public class  ArrayUtils
	{
		public static function countDuplicate(myarray:Array){
				var obj={}, i=myarray.length, arr=[], t, arr2=[];
				while(i--){
					t = myarray[i];
					if(obj[t]){
						obj[t][0] ++;
					}else{
						obj[t] = [1,t];
					}
				}
				for(i in obj){
					if(obj[i][0] > 1) arr.push(obj[i]);
				}
				return arr.length;
				
		}
		
		public static function randomize(list:Array):Array {
			var randomized:Array = ArrayUtils.clone(list);
			var el:*;
			var rn:Number;
			var _length = list.length;
			var it;
			for (it = 0; it < _length; it++) {
				el = randomized[it];
				randomized[it] = randomized[rn = NumberUtils.random(0, _length-1)];
				randomized[rn] = el;
			}
			return randomized;
		}
		
		public function clone(list:Array):Array {
			var i:uint;
			var clone:Array;
			for (i = 0; i < list.length; i++) {
				clone[i] = list[i];
			}
			
			return clone;
		}
	}
	
}