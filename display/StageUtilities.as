package com.smp.common.display{

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;


	public class StageUtilities {


		public function StageUtilities() {
			
		}
		
		/**
		 * 
		 * @param	stage
		 * @param	callback : function to be called on stage update. If it to be called only after a certain number of iteractions, set everyFrame to false.
		 * @param	repeatCount : the number of iteractions for the update to be listened.
		 * @param	everyFrame : wether to call the function on each update. If false, the callback is called only after all the iteractions defined by repeatCount. Default set to true.
		 */
		
		public static function onUpdate(stage:Stage, callback:Function, repeatCount:Number = 1, everyFrame:Boolean = true):void {
			
			var counter:uint = 0;
			stage.addEventListener(Event.ENTER_FRAME, onNewFrame);
			
			function onNewFrame(evt:Event) 
            {  
                counter++;
                if (counter == repeatCount) {
                    callback();
                    stage.removeEventListener(Event.ENTER_FRAME, onNewFrame);
                }else if(everyFrame){
                    callback();
                }
            } 

		}
		
	}
}