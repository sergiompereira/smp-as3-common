package com.smp.common.display
{
	import com.smp.common.utils.JSUtils;
	import flash.external.ExternalInterface;
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
		private var _mousePressed:Boolean = false;
		private var _offstage:Boolean = false;
	
		
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
					onDownFcn(target, evt);
				}
				
				if(onDragFcn != null){
					target.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				}
				target.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				target.stage.addEventListener(MouseEvent.MOUSE_OUT, stageOut);
				target.stage.addEventListener(MouseEvent.MOUSE_OVER, stageOver);
				target.stage.addEventListener(Event.MOUSE_LEAVE, stageLeave);
				
				_mousePressed = true;


		}
			
		private function onMove(evt:MouseEvent):void {
			
				if(onDragFcn != null){
					onDragFcn(target, evt);
				}

		}
		
		private function stageOut(event:MouseEvent):void {
			_offstage = true;
			if (event.stageX <= 0 || event.stageX >= target.stage.stageWidth || event.stageY <= 0 || event.stageY >= target.stage.stageHeight)
			{
				handleMouseUp(event);
			}
			
		}
		private function stageOver(event:MouseEvent):void {
			_offstage = false;
		}
		
		private function stageLeave(event:Event):void {
			 handleMouseUp(event);
		}
			
		private function onUp(evt:MouseEvent):void 
		{
			handleMouseUp(evt);
		}
		
			
		private function handleMouseUp(event:Event = null ):void {
			
			if((target as Sprite)!=null){
				stopDrag((target as Sprite));
			}else {
				target.stage.removeEventListener(Event.ENTER_FRAME, onStageUpdate);
			}
			
			
			if(onUpFcn != null){
				onUpFcn(target, event);
			}
			
			target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			target.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			target.stage.removeEventListener(MouseEvent.MOUSE_OUT, stageOut);
			target.stage.removeEventListener(MouseEvent.MOUSE_OVER, stageOver);
			target.stage.removeEventListener(Event.MOUSE_LEAVE, stageLeave);
			
			_mousePressed = false;
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