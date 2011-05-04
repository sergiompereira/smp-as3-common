package com.smp.common.text{

	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	

	public class TextUtils 
	{
		
		public function TextUtils() {
		}
		
		public static function createTextField(text:String = "", txtFormat:TextFormat = null, x:Number=0, y:Number=0, width:Number=0, height:Number = 0, name:String = ""):TextField 
		{

			var textField:TextField = new TextField();
			textField.x = x;
			textField.y = y;
			if(width >0){
				textField.width = width;
				textField.wordWrap = true;
			}
			if (height>0) {
				textField.height = height;
			}
			
			textField.mouseEnabled = false;
			//textField.embedFonts = true;
			if (txtFormat != null) {
				if(txtFormat.align){
					textField.autoSize = txtFormat.align;
				}else {
					textField.autoSize = TextFieldAutoSize.LEFT;
				}
				textField.defaultTextFormat = txtFormat;
			}else {
				textField.autoSize = TextFieldAutoSize.LEFT;
			}
			textField.text = text;
			textField.name = name;
						
			return textField;
		}

	}
}