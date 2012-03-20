package com.smp.common.display{

	import flash.display.MovieClip;
	import flash.display.InteractiveObject;
	import flash.geom.Rectangle;

	public class DragHandler {
		
		private var _collection:Array;
			

		public function DragHandler() {
			
			_collection = new Array()
		}
		
		public function setDraggable(target:InteractiveObject, lockCenter:Boolean = false, left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0, onDownFcn:Function = null, onUpFcn:Function = null, onDragFcn:Function = null ):Boolean {
		
			
			if (getObjectByTarget(target) == null) {
	
				var dragObj:DragData = new DragData();
				
				dragObj.target = target;

				dragObj.lockCenter=lockCenter;

				if(left != 0 || top != 0 || right != 0 || bottom != 0){
					var largura:Number=right - left;
					var altura:Number=bottom - top;
					var posx:Number=left;
					var posy:Number=top;

					dragObj.bounds=new Rectangle(posx,posy,largura,altura);
				}
				
				dragObj.onDownFcn = onDownFcn;
				dragObj.onUpFcn = onUpFcn;
				dragObj.onDragFcn = onDragFcn;
				
				_collection.push(dragObj);
				dragObj.id = _collection.length - 1;
				dragObj.start();
				
				return true;
			}
			
			return false;
			
		}

		
		public function resetTarget(target:InteractiveObject):void {
			
			var dragObj:DragData = getObjectByTarget(target);
			if (dragObj != null) {
				dragObj.reset();
				_collection.splice(dragObj.id, 1);
				dragObj = null;
			}
		}
		
		public function getBounds(target:InteractiveObject):Rectangle {
			var dragObj:DragData = getObjectByTarget(target);
			if (dragObj != null) {
				return dragObj.bounds;
			}
			return null;
		}
		
		public function setBounds(target:InteractiveObject, rect:Rectangle):void {
			var dragObj:DragData = getObjectByTarget(target);
			if (dragObj != null) {
				dragObj.bounds = rect;
			}
		}
		
		public function pause(target:InteractiveObject):void 
		{
			var dragObj:DragData = getObjectByTarget(target);
			if(dragObj != null){
				dragObj.pause();
			}
		}
		
		public function resume(target:InteractiveObject):void 
		{
			var dragObj:DragData = getObjectByTarget(target);
			if(dragObj != null){
				dragObj.resume();
			}
		}
		
		public function forceDrag(target:InteractiveObject):void {
			var dragObj:DragData = getObjectByTarget(target);
			if(dragObj != null){
				dragObj.forceDrag();
			}
		}
		
		public function isPaused(target:InteractiveObject):Boolean 
		{
			var dragObj:DragData = getObjectByTarget(target);
			if(dragObj != null){
				return dragObj.paused;
			}
			
			return true;
		}
		
		private function getObjectByTarget(target:InteractiveObject):DragData {
			
			var i:uint;
			
			for (i = 0; i < _collection.length; i++) {
				if ((_collection[i] as DragData).target == target) {
					return _collection[i];
					break;
				}
			}
			return null;
		}
		
	}
}