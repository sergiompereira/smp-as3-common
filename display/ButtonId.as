package com.smp.common.display{
	
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	public class ButtonId extends SimpleButton {
		
		private var _id:Number;
		
		public function set id(Id:Number):void{
			_id = Id;
		}
		
		public function get id():Number{
			return _id;
		}
	}
}