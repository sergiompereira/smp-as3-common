package com.smp.common.display.loaders
{

	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class RingPreloader extends Sprite {

		private var _timer:Timer = new Timer (10);
		
		public function RingPreloader(holder:DisplayObjectContainer, raio:Number = 10, esp:Number = 3, cor:Number = 0x000000, transp:Number = 0.5) {
			
			alpha = transp;
			with (graphics) {
				
				lineStyle();
				beginFill(cor);
				/*moveTo(0,-raio);
				
				curveTo(raio-raio/3,-raio,raio,0);
				curveTo(raio-raio/3,raio,0,raio);
				curveTo(-raio,raio,-raio,0);
				lineTo(-raio+esp,0);
				curveTo(-raio+esp,raio-esp,0,raio-esp);
				curveTo(raio-esp,raio-esp,raio-esp,0);
				curveTo(raio-esp,-raio+esp,0,-raio+esp);*/
				
				//lógica : encontrar vector points a cada PI/4 (e não a cada PI/2)
				var vectorP=raio*(Math.SQRT2-1);
				//var vectorP = Math.sin(Math.PI/8)*Math.cos(Math.PI/8)*raio;
				//a outra componente (x ou y alternado) é igual ao raio
    			
				var destP=raio*Math.SQRT2/2;
				//var destP = raio*Math.cos(Math.PI/4);
				//destPx = destPy;
				
				
				var vectorPInt=(raio-esp)*(Math.SQRT2-1);
				var destPInt=(raio-esp)*Math.SQRT2/2;
				
				
				moveTo(destP ,-destP);
				curveTo(raio ,-vectorP , raio ,0);
				curveTo(raio,vectorP,destP,destP);
				curveTo(vectorP,raio,0,raio);
				curveTo(-vectorP,raio,-destP,destP);
				curveTo(-raio,vectorP,-raio,0);
				curveTo(-raio,-vectorP,-destP,-destP);
				curveTo(-vectorP,-raio,0,-raio);
				lineTo(0,-raio+esp);
				curveTo(-vectorPInt,-(raio-esp),-destPInt,-destPInt);
				curveTo(-(raio-esp),-vectorPInt,-(raio-esp),0);
				curveTo(-(raio-esp), vectorPInt,-destPInt,destPInt);
				curveTo(-vectorPInt, raio-esp ,0 ,raio-esp);
				curveTo( vectorPInt, raio-esp , destPInt ,destPInt);
				curveTo(raio-esp ,vectorPInt , raio-esp ,0);
				curveTo(raio-esp ,-vectorPInt , destPInt ,-destPInt);
   
				
				endFill();

			}
			
			_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			_timer.start();
			
			/*
			x = raio*2;
			y = raio*2;
			*/
			
			holder.addChild(this);
		}
		
		private function onTimer(evt:TimerEvent):void{
			rotation+=8;
		}
	}
}