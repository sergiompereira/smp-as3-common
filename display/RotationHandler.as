package com.smp.common.display
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.smp.common.math.MathUtils;
	
	
	public class RotationHandler  
	{

		
		private var _target:DisplayObject;
		
		private var _initMousePos:Point;
		
		private var _initAngle:Number;
		private var _initRotation:Number;
		
		private var _timer:Timer = new Timer(30);
		
		
		public function RotationHandler() {
			
		}
		
		public function handleRotation(obj:DisplayObject):void 
		{
			_target = obj;
			_initMousePos = new Point(_target.parent.mouseX, _target.parent.mouseY);
			_initRotation = _target.rotation;
			
			_initAngle = MathUtils.getVector(0, 0, _initMousePos.x, _initMousePos.y).angle;
			
			_timer.addEventListener(TimerEvent.TIMER, onUpdate);
			_timer.start();
		}
		
		public function stop():void 
		{
			_timer.removeEventListener(MouseEvent.MOUSE_MOVE, onUpdate);
			_timer.reset();
		}
		
		
		private function onUpdate(evt:TimerEvent) {
			
			_target.rotation = _initRotation + MathUtils.radianToDegree(_initAngle - getAngle());
				
		}
		
		private function getAngle():Number {
			
			return MathUtils.getVector(0, 0, _target.parent.mouseX, _target.parent.mouseY).angle;
		}
		
		
	}
	
}