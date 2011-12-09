package com.smp.common.utils
{
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class TimerUtils extends EventDispatcher 
	{
		
		public static function delay(delaytime:Number, action:Function, args:*=null):Timer {
			
			var _timer:Timer = new Timer(delaytime);
			_timer.addEventListener(TimerEvent.TIMER, onTimeComplete);
			_timer.start();
			
			function onTimeComplete(evt:TimerEvent) {
				_timer.removeEventListener(TimerEvent.TIMER, onTimeComplete);
				_timer.stop();
				
				action(args);
			}
			
			return _timer;
		}
		
		/**
		 * 
		 * @param	queu : an array of arrays in the form:
		 * [ [delay:Number, function:Function, args:*=null],...]
		 * The functions will be called by the order of items in the array and delayed in between by the respective delay
		 */
		public static function queu(queu:Array):Timer {
			
			var i:uint;
			var _timer:Timer = new Timer(queu[0][0]);
			var counter = 0;
			
			for (i = 0; i < length; i++){
				
				
				
			}
			
			_timer.addEventListener(TimerEvent.TIMER, onTimeComplete);
			_timer.start();
			
			function onTimeComplete(evt:TimerEvent) {
			
				//execute function
				if(queu[counter].length>2){
					queu[counter][1](queu[counter][2]);
				}else {
					queu[counter][1]();
				}
				
				counter++;
				
				if (counter == queu.length) {
					_timer.removeEventListener(TimerEvent.TIMER, onTimeComplete);
					_timer.stop();
				}else {
					_timer.delay = queu[counter][0]
				}
			}
			
			return _timer;
		}
		
		/**
		 * 
		 * @param	action
		 * @param	repeatCount	
		 * @param	timeSpan 
		 * @return
		 */
		public static function repeat(action:Function, repeatCount:uint, repeatInterval:Number,  args:*=null):Timer {
			
			var counter:uint = 0;
			var _timer:Timer 
			if (repeatInterval > 0) {
				_timer = new Timer(repeatInterval);
				_timer.addEventListener(TimerEvent.TIMER, onTimeComplete);
				_timer.start();
			}else {
				for(counter = 0; counter < repeatCount; counter++){
					action(counter, args);
				}
			}
			
			
			function onTimeComplete(evt:TimerEvent) {
				
				counter++;
				if (counter == repeatCount) {
					_timer.removeEventListener(TimerEvent.TIMER, onTimeComplete);
					_timer.stop();
				}
				
				action(counter, args);
			}
			
			if (_timer) {
				return _timer;
			}
			
			return null;
			
		}
		
		/**
		 * 
		 * @param	miliseconds
		 * @return 	array 0:minutes, 1:seconds, 2:centesims of second
		 */
		public static function getClockTime(miliseconds:Number, leftzero:Boolean=true):Array {
			
			var centseconds:Number;
			var seconds:Number;
			var minutes:Number;
			
			minutes  = Math.floor(miliseconds / (60*1000));
			seconds = Math.floor((miliseconds % (60*1000))/1000);
			centseconds = miliseconds % 1000;
			
			var sSeconds:String = seconds.toString();
			var sMinutes:String = minutes.toString();
			var sCentseconds:String = centseconds.toString().substr(0,2);
			
			if(leftzero){
				if (sSeconds.length == 1) {
					sSeconds = "0" + sSeconds;
				}
				if (sMinutes.length == 1) {
					sMinutes = "0" + sMinutes;
				}
				if (sCentseconds.length == 1) {
					sCentseconds = "0" + sCentseconds;
				}
			}
			
			return new Array(sMinutes,sSeconds,sCentseconds);
		}
	}
	
}