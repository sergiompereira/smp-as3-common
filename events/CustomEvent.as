package com.smp.common.events
{
	import flash.events.Event;
	
	
	public class  CustomEvent extends Event
	{

		public static const UPDATE:String = "update";
		public static const READY:String = "ready";
		
		protected var _data:Object;
		
		
		public function CustomEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this._data = data;
		}
		
		public function set data(value:Object):void {
			this._data = value;
		}
		
		public function get data():Object {
			return _data;
		}
	}
	
}