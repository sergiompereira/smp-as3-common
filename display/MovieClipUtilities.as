package com.smp.common.display{

	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;


	public class MovieClipUtilities {


		public function MovieClipUtilities() {
			
		}
		
		/*
		 * MovieClipUtilities.setDraggable(obj, false, 0, 0, 0, scrolldist);
		 * obj.addEventListener("Drag", onDrag);
		*/
		public static function setDraggable(mc:MovieClip, lockCenter:Boolean = false, left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0, onDownFcn:Function = null, onUpFcn:Function = null, onDragFcn:Function = null)
		{
			
			if (mc.stage == null) {
				throw new IllegalOperationError("MovieClipUtilities -> setDraggable: Add object, or its parent, to the display list.");
			}
			
			var _mc:MovieClip = mc;
			var _lockCenter:Boolean = lockCenter;
			var _bounds:Rectangle;
			var _onDownFcn:Function = onDownFcn;
			var _onUpFcn:Function = onUpFcn;
			var _onDragFcn:Function = onDragFcn;
		

			_lockCenter=lockCenter;

			if(left != 0 || top != 0 || right != 0 || bottom != 0){
				var largura:Number=right - left;
				var altura:Number=bottom - top;
				var posx:Number=left;
				var posy:Number=top;

				_bounds=new Rectangle(posx,posy,largura,altura);
			}
			
			_mc.buttonMode = true;

			_mc.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			//_mc.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			


			function onDown(evt:MouseEvent):void {
				
				StartDrag();
				if(_onDownFcn != null){
					_onDownFcn(_mc);
				}
				
				
				_mc.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
				_mc.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
				

			}
			
			function onMove(evt:MouseEvent):void {
				
				if(_onDragFcn != null){
					onDragFcn(_mc);
				}
				
				_mc.dispatchEvent(new Event("Drag"));

			}
			
			
			function onUp(evt:MouseEvent):void 
			{
				_mc.dispatchEvent(new Event("Drop"));
				
				_mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				_mc.stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				
				StopDrag();
				if(_onUpFcn != null){
					_onUpFcn(_mc);
				}
			}
			
			function StartDrag():void 
			{
				_mc.startDrag(_lockCenter,_bounds);
			}
			
			function StopDrag():void 
			{
				_mc.stopDrag();
			}
		}
		
	}
}