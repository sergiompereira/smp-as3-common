package com.smp.common.display{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class MovieClipId extends MovieClip {
		
		protected var _id:Number = -1;
		protected var _description:String = "";
		protected var _collection:Array = new Array();
		protected var _data:Object = new Object();
		
		public function MovieClipId() {
			super();
		}
		
		public function set id(Id:Number):void{
			_id = Id;
		}
		
		public function get id():Number{
			return _id;
		}
		
		public function set description(value:String):void {
			_description = value;
		}
		
		public function get description():String {
			return _description;
		}
		
		public function set collection(value:Array):void {
			_collection = value;
		}
		
		public function get collection():Array {
			return _collection;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function get data():Object {
			return _data;
		}
	}
}