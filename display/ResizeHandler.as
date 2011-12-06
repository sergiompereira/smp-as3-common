package com.smp.common.display
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.smp.common.math.MathUtils;
	
	
	public class ResizeHandler  
	{
		
		private var _target:DisplayObject;
		
		private var _initMousePos:Point;
		
		private var _initSize:Number;
		private var _initDistance:Number;
		private var _reference:Number;
		
		private var _timer:Timer = new Timer(30);
		
		
		public function ResizeHandler() {
		}
		
		public function handleResize(obj:DisplayObject):void {
			_target = obj;
			_initMousePos = new Point(_target.parent.mouseX, _target.parent.mouseY);
			
			_initSize = _target.scaleX;
			_reference = obj.height / 2;
			
			_initDistance = MathUtils.getDistance(0, 0, _initMousePos.x, _initMousePos.y);
			
			
			_timer.addEventListener(TimerEvent.TIMER, onUpdate);
			_timer.start();
		}
		
		public function stop():void 
		{
			_timer.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdate);
			_timer.reset();
		}
		
		private function onUpdate(evt:TimerEvent) {
			
			var outputSize:Number = _initSize + getSize();
			if(outputSize>0.3){
				_target.scaleX = _target.scaleY = outputSize;
			}
					
				
		}
		
		private function getSize():Number {
			
			return (_initMousePos.y - _target.parent.mouseY)/ _reference;

		}
		
		
	}
	
}