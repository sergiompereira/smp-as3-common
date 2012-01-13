package com.smp.common.utils{
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Console extends TextField{
		
		private static var _instance:Console;
		
		public function Console(inst:PrivateClass) {
				super();
				this.autoSize = TextFieldAutoSize.LEFT;
				this.defaultTextFormat = new TextFormat("Verdana", 10, 0x000000);
				this.background = true;
				this.backgroundColor = 0xdddddd;
				
		}
			
		/**
		 * Singleton
		 * Add to the top of the stage object display list.
		 * 
		 */
		public static function getInstance():Console {
			if (Console._instance == null) {
					Console._instance = new Console(new PrivateClass());
			}
			return Console._instance;
		}
		
		public function trace(value:String):void{
			this.appendText("\n"+value);
			
		}
	}
}

class PrivateClass {
	public function PrivateClass() {
		//
	}
}