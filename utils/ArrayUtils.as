package com.smp.common.utils
{
	
	/**
	 * @see also ascb.util.ArrayUtilities
	 * @author Sergio Pereira
	 */
	
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
	}
	
}