package com.smp.common.utils{

	import com.smp.common.math.NumberUtils;
	
	public class XMLListUtils{
		
		
		public static function randomize(list:XMLList):XMLList {
			var randomized:XMLList = list.copy();
			var el:XML;
			var rn:Number;
			var _length = list.length();
			
			for (var it = 0; it < _length; it++) {
				el = randomized[it];
				randomized[it] = randomized[rn = NumberUtils.random(0, _length-1)];
				randomized[rn] = el;
			}
			return randomized;
		}
		
		public static function toXML(list:XMLList, rootnode:String = "<root>"):XML{
			
			var xmlstring:String = list.toXMLString(); 
			var endnode = "</" + rootnode.substring(1, rootnode.length);
			
			xmlstring= rootnode + xmlstring + endnode; 
			var xml:XML=new XML(xmlstring); 
			return xml;
		}
		
		public static function removeAll(list:XMLList):void{
			for(var i:int = list.length()-1; i>=0; i--){
				delete list[i];
			}
		}
		
		public static function appendToXML(xml:XML, list:XMLList):XML{
			
			for(var j in list){
				xml.appendChild(list[j].toXMLString());
			}
			return xml;
		}
		
		public static function toArray(list:XMLList):Array{
			
			var temp:Array = new Array();
			for (var j:uint = 0; j<list.length(); j++){
				temp.push(list[j].toString());
			}
			
			return temp;
		}
	}

}