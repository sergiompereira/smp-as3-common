package com.smp.common.display{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class StageLayoutHandler{
		
		/**
		 * 
		 * @author : Sérgio Pereira
		 * 
		 * 
			Usar o HTML neste formato (atenção ao header aos parâmetros width e height e scale):
			<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
			...
			<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" width="100%" height="100%" id="main" align="middle">
				<param name="allowScriptAccess" value="sameDomain" />
				<param name="scale" value="noscale"
				<param name="allowFullScreen" value="false" />
				<param name="movie" value="main.swf" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" />	
				<embed src="main.swf" quality="high" bgcolor="#ffffff" width="100%" height="100%" scale="noscale" name="main" align="middle" allowScriptAccess="sameDomain" allowFullScreen="false" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
			</object>

		 * @param	objCol
		 * @param	initStageDim : as dimensões do flash durante o authoring. As dimensões do stage mudam em runtime se no html estiver definido 100%. Em função de initStageDim, é calculada a nova posição dos objectos para as dimensões em runtime
		 * @param	useClipRegPoint
		 * @param	XminSize
		 * @param	YminSize
		 */

			private var _resizerColl:Array = new Array();
			private var _initStageDim:Array;
			private var _useClipRegion:Boolean;
			
			
			
			
			public function StageLayoutHandler() {
				
			}

			public function setStageObjects(objCol:Array, initStageDim:Array, useClipRegPoint:Boolean = true, XminSize:int = -1, YminSize:int = -1, XmaxSize:int = -1, YmaxSize:int = -1){
				
				if(XminSize >= 0 || YminSize >= 0){
					StageResizer.MinStageSize(XminSize, YminSize);
				}
				
				if(XmaxSize >= 0 || YmaxSize >= 0){
					StageResizer.MaxStageSize(XmaxSize, YmaxSize);
				}
				
				_initStageDim = initStageDim;
				_useClipRegion = useClipRegPoint;
				
				for(var i:uint = 0; i < objCol.length; i++){
					var pox:int = (objCol[i] as DisplayObject).x/initStageDim[0]*100;
					var poy:int = (objCol[i] as DisplayObject).y/initStageDim[1]*100;
					var offsetx:int = 0;
					var offsety:int = 0;
					(objCol[i] as DisplayObject).addEventListener(Event.REMOVED_FROM_STAGE, handleObjectRemove);
					(objCol[i] as DisplayObject).addEventListener(Event.ADDED_TO_STAGE, handleObjectAdd);
					
					var stres:StageResizer = new StageResizer(objCol[i], pox, poy, offsetx, offsety, useClipRegPoint);
					_resizerColl.push(stres);
				}
			}
			
			private function handleObjectRemove(evt:Event) {
				removeObject((evt.currentTarget as DisplayObject));
			}
			
			private function handleObjectAdd(evt:Event) {
				addObject((evt.currentTarget as DisplayObject));
			}
		
			
			public function removeObject(obj:DisplayObject):Boolean {
				
				for (var i:uint = 0; i < _resizerColl.length; i++) {
					if ((_resizerColl[i] as StageResizer).target == obj) {
						(_resizerColl[i] as StageResizer).kill();
						_resizerColl.splice(i, 1);
						return true;
						
					}
				}
				
				return false;
			}
			
			public function addObject(obj:DisplayObject):void 
			{
				var pox:int = obj.x/_initStageDim[0]*100;
				var poy:int = obj.y/_initStageDim[1]*100;
				
				obj.addEventListener(Event.REMOVED_FROM_STAGE, handleObjectRemove);
				obj.addEventListener(Event.ADDED_TO_STAGE, handleObjectAdd);
				
				var stres:StageResizer = new StageResizer(obj, pox, poy, 0, 0, _useClipRegion);
				_resizerColl.push(stres);
			}
		
	}
}