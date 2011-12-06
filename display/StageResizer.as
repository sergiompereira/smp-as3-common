package com.smp.common.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	
	
	public class StageResizer 
	{
		private var _initStageWidth:Number;
		private var _initStageHeight:Number;
		private var _stage:Stage;
		
		private var _resizerColl:Array = new Array();
		
		
		public function StageResizer(stage:Stage) {
		
			
			_stage = stage;
			_initStageWidth = _stage.stageWidth;
			_initStageHeight = _stage.stageHeight;
			
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			
			_stage.addEventListener(Event.RESIZE, stageResizeHandler);
		}
		
		public function addObject(target:DisplayObject, vratio:Boolean = false, hratio:Boolean = false, top:Boolean = false, right:Boolean = false, bottom:Boolean = false, left:Boolean = false ):void {
			
			var data:Object = { };
			data.target = target;
			
			if(bottom) {
				data.bottom = _initStageHeight-target.y;
			}else if(top){
				data.top = target.y;
			}else {
				data.vratio = target.y;
			}
			
			if (right) {
				data.right = _initStageWidth-target.x;
			}else if(left){
				data.left = target.x;
			}else {
				data.hratio = target.x;
			}
			data.x = target.x;
			data.y = target.y;
			
			_resizerColl.push(data);
		}
		
		private function stageResizeHandler(evt:Event):void {
			var i:uint;
			for (i = 0; i < _resizerColl.length; i++) {
				if(_resizerColl[i].top != null){
					_resizerColl[i].target.y = -(_stage.stageHeight - _initStageHeight) / 2 + _resizerColl[i].top;
				}else if(_resizerColl[i].bottom != null){
					_resizerColl[i].target.y = _initStageHeight + (_stage.stageHeight - _initStageHeight) / 2 - _resizerColl[i].bottom ;
					
				}else if(_resizerColl[i].vmiddle != null){
					_resizerColl[i].target.y = (_stage.stageHeight - _initStageHeight)/_initStageHeight * _resizerColl[i].vmiddle;
				}
				if(_resizerColl[i].left != null){
					_resizerColl[i].target.x = -(_stage.stageWidth - _initStageWidth) / 2 + _resizerColl[i].left ;
				}else if(_resizerColl[i].right != null){
					_resizerColl[i].target.x = _initStageWidth + (_stage.stageWidth - _initStageWidth) / 2 - _resizerColl[i].right ;
					
				}else if(_resizerColl[i].hmiddle != null){
					_resizerColl[i].target.x = (_stage.stageWidth - _initStageWidth) / _initStageWidth * _resizerColl[i].hmiddle;
				}
				
			}
			
		
			
		}
	}
	
}