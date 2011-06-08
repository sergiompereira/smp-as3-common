package com.smp.common.utils{

	import flash.display.DisplayObject;

	public class Utils {

		private static var lastTime:Number = 0;
		
		public static function getSwfPath(root:DisplayObject):String
		{
			var lastDir:Number = root.loaderInfo.url.lastIndexOf("/");
			var urlpath:String = root.loaderInfo.url.substring(0, lastDir + 1);
			return urlpath;
		}
		
		/**
		 * Call this on an EnterFrame loop to read the fraction of second that takes each frame
		 * @return spf	:Number
		 */
		public static function getSPF():Number {

			var spf:Number = Math.floor( 1000/(getTimer()- Utils.lastTime) );
			Utils.lastTime = getTimer();
			
			return spf;
		}
	}
}