package com.smp.common.display
{
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.InteractiveObject;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	
	
	internal class DragData
	{
		
		internal var target:InteractiveObject;
		internal var lockCenter:Boolean;
		internal var bounds:Rectangle;
		
		internal var onDownFcn:Function;
		internal var onUpFcn:Function;
		internal var onDragFcn:Function;
		
		
		internal var id:uint;
		
		private var _mousePos:Point;
		private var _paused:Boolean;
		
	
		
		internal function start() {
			
			if(target!=null){
				target.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				_paused = false;
			}
		}
		
		internal function forceDrag():void {
			onDown();
		}
		
		private function onDown(evt:MouseEvent = null):void 
		{
				if((target as Sprite)!=null){
					startDrag((target as Sprite));
				}else {
					_mousePos = new Point(target.mouseX, target.mouseY);
					target.stage.addEventListener(Event.ENTER_FRAME, onStageUpdate);
				}
				
				if(onDownFcn != null){
					onDownFcn(target);
				}
				
				if(onDragFcn != null){
					target.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				}
				target.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			

		}
			
		private function onMove(evt:MouseEvent):void {
			
				if(onDragFcn != null){
					onDragFcn(target);
				}

		}
			
			
		private function onUp(evt:MouseEvent):void 
		{
				
				if((target as Sprite)!=null){
					stopDrag((target as Sprite));
				}else {
					target.stage.removeEventListener(Event.ENTER_FRAME, onStageUpdate);
				}
				
				
				if(onUpFcn != null){
					onUpFcn(target);
				}
				
				target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				target.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
		}
			
		private function startDrag(target:Sprite):void 
		{
			
			target.startDrag(lockCenter,bounds);
			
		}
			
		private function stopDrag(target:Sprite):void 
		{
		
			target.stopDrag();
		}
		
		private function onStageUpdate(evt:Event):void {
			
			if(lockCenter){
				target.x = target.parent.mouseX;
				target.y = target.parent.mouseY;
			}else {
				target.x = target.parent.mouseX + _mousePos.x;
				target.y = target.parent.mouseY + _mousePos.y;
				
			}
		}

		internal function pause():void {
			if(!_paused){
				_paused = true;
				removeHandlers();
			}
		}
		
		internal function resume():void 
		{
			if (_paused) {
				_paused = false;
				target.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			}
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		internal function reset():void {
			removeHandlers();
		}
		
		private function removeHandlers():void {
			target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			target.stage.removeEventListener(Event.ENTER_FRAME, onStageUpdate);
			target.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			target.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
	}
	
}