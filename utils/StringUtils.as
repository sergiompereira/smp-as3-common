package com.smp.common.utils
{
	
	import ascb.util.NumberUtilities;
	import flash.xml.*;
	
	/**
	 * @see ascb.util.StringUtilities
	 * @author Sergio Pereira
	 */
	
	public class  StringUtils
	{
		public static const HTML_ENTITIES:Array = [
		
				["á", "&aacute;"],
				["à", "&agrave;"],
				["â", "&acirc;"],
				["ã", "&atilde;"],
				["é", "&eacute;"],
				["è", "&egrave;"],
				["ê", "&ecirc;"],
				["ó", "&oacute;"],
				["ò", "&ograve;"],
				["ô", "&ocirc;"],
				["õ", "&otilde;"],
				["í", "&iacute;"],
				["ì", "&igrave;"],
				["î", "&icirc;"],
				["ú", "&uacute;"],
				["ù", "&grave;"],
				["û", "&ucirc;"],
				["ç", "&ccedil;"],
				["ñ", "&ntilde;"],
				["Ú", "&Uacute;"],
				["Ù", "&Ugrave;"],
				["Û", "&Ucirc;"],
				
				["\"", "&quot;"],
				["'", "&apos;"],
				["&", "&amp;"],
				["<", "&lt;"],
				[">", "&gt;"],
				[" ", "&nbsp;"],
				["¡", "&iexcl;"],
				["Û", "&curren;"],
				["¢", "&cent;"],
				["£", "&pound;"],
				["´", "&yen;"],
				["¦", "&brvbar;"],
				["¤", "&sect;"],
				["¬", "&uml;"],
				["©", "&copy;"],
				["»", "&raquo;"],
				["«", "&laquo;"],
				["Â", "&not;"],
				["Ð", "­"],
				["®", "&reg;"],
				["™", "&trade;"],
				["ø", "&macr;"],
				["¡", "&deg;"],
				["±", "&plusmn;"],
				["Ó", "&sup2;"],
				["Ò", "&sup3;"],
				["«", "&acute;"],
				["µ", "&micro;"],
				["¦", "&para;"],
				["á", "&middot;"],
				["ü", "&cedil;"],
				["Õ", "&sup1;"],
				["½", "&half;"],
				["¼", "&frac14;"],
				["¿", "&iquest;"],
				["»", "&raquo;"],
				["¹", "&frac14;"],
				["¸", "&frac12;"],
				["²", "&frac34;"],
				["À", "&iquest;"],
				["×", "&times;"],
				["Ö", "&divide;"],
				["À", "&Agrave;"],
				["Á", "&Aacute;"],
				["Â", "&Acirc;"],
				["Ã", "&Atilde;"],
				["Ä", "&Auml;"],
				["Å", "&Aring;"],
				["Æ", "&AElig;"],
				["Ç", "&Ccedil;"],
				["È", "&Egrave;"],
				["É", "&Eacute;"],
				["Ê", "&Ecirc;"],
				["Ë", "&Euml;"],
				["Ì", "&Igrave;"],
				["Í", "&Iacute;"],
				["Î", "&Icirc;"],
				["Ï", "&Iuml;"],
				["Ð", "&ETH;"],
				["Ñ", "&Ntilde;"],
				["Ò", "&Ograve;"],
				["Ó", "&Oacute;"],
				["Ô", "&Ocirc;"],
				["Õ", "&Otilde;"],
				["Ö", "&Ouml;"],
				["Ø", "&Oslash;"],
				["ô", "&Ugrave;"],
				["ò", "&Uacute;"],
				["ó", "&Ucirc;"],
				["†", "&Uuml;"],
				["Þ", "&THORN;"],
				["§", "&szlig;"],
				["ˆ", "&agrave;"],
				["‡", "&aacute;"],
				["‰", "&acirc;"],
				["‹", "&atilde;"],
				["Š", "&auml;"],
				["Œ", "&aring;"],
				["¾", "&aelig;"],
				["Ž", "&eacute;"],
				["‘", "&euml;"],
				["“", "&igrave;"],
				["’", "&iacute;"],
				["”", "&icirc;"],
				["º", "&ordm;"],
				["ª", "&ordf;"],
				["•", "&iuml;"],
				["Ý", "&eth;"],
				["–", "&ntilde;"],
				["˜", "&ograve;"],
				["—", "&oacute;"],
				["™", "&ocirc;"],
				["›", "&otilde;"],
				["š", "&ouml;"],
				["¿", "&oslash;"],
				["œ", "&uacute;"],
				["ž", "&ucirc;"],
				["Ÿ", "&uuml;"],
				["à", "&yacute;"],
				["ß", "&thorn;"],
				["Ø", "&yuml;"],
				["Œ", "&OElig;"],
				["œ", "&oelig;"],
				["Š", "&Scaron;"],
				["š", "&scaron;"],
				["Ÿ", "&Yuml;"],
				["ˆ", "&circ;"],
				["˜", "&tilde;"],
				["–", "&ndash;"],
				["—", "&mdash;"],
				["‘", "&lsquo;"],
				["’", "&rsquo;"],
				["‚", "&sbquo;"],
				["“", "&ldquo;"],
				["”", "&rdquo;"],
				["„", "&bdquo;"],
				["†", "&dagger;"],
				["‡", "&Dagger;"],
				["…", "&hellip;"],
				["‰", "&permil;"],
				["‹", "&lsaquo;"],
				["›", "&rsaquo;"],
				["€", "&euro;"]
			];
		
			
		public static function trim( original:String ):String {
			// Split the string into an array of characters.
			var characters:Array = original.split( "" );
		
			// Remove any whitespace elements from the beginning of the array using
			// splice(). Use a break statement to exit the loop when you reach a
			// non-whitespace character to prevent it from removing whitespace
			// in the middle of the string.
			for ( var i:int = 0; i < characters.length; i++ ) {
				if ( isWhitespace( characters[i] ) ) {
					characters.splice( i, 1 );
					i--;
				} else {
					break;
				}
			}
		
			// Loop backward through the array removing whitespace elements until a
			// non-whitespace character is encountered. Then break out of the loop.
			for ( i = characters.length - 1; i >= 0; i-- ) {
				if ( isWhitespace( characters[i] ) ) {
					characters.splice( i, 1 );
				} else {
					break;
				}
			}
		
			// Recreate the string with the join() method and return the result.
			return characters.join("");
		}
		
		public static function truncate(text:String, maxLength:Number, appendedString:String = ""):String{
			
			var ttext:String;
			
			if(text.length > maxLength){
				ttext = text.substr(0, maxLength);
				
				
				var j:uint = ttext.length - 1;
				while (!StringUtils.isWhitespace(ttext.charAt(j))) 
				{
					if (j > 0) {
						j--;
					}else {
						break;
					}
				}
				//trace(j);
				ttext = text.substring(0, j);
				
				if(ttext.length == 0){
					var pos:uint = text.search(" ");
					ttext = text.substring(0, pos);
				}
				
				
				if(ttext != text){
					ttext+= appendedString;
				}	
			}else{
				ttext = text;
			}
			
			
			return ttext;
			
		}
		
		/**
		 * 
		 * @param	original
		 * @param	padrao
		 * @return
		 */
		public static function removeString(original:String, padrao:String):String{
			while(original.search(padrao) >= 0){
				var extracted:String = original.replace(padrao, "");
				original = extracted;
			}
			return original;
		}
		
		/**
		 * 
		 * @param	original
		 * @param	pattern
		 * @param	replacewith
		 * @param	caseSensitive
		 * @return
		 */
		public static function replaceString(original:String, pattern:String, replacewith:String = "", caseSensitive:Boolean = true):String {
			
			//trace(original)
			
			var tempOriginal:String;
			var tempPadrao:String;
			if (!caseSensitive) {
				tempOriginal = original.toString().toUpperCase();
				tempPadrao = pattern.toString().toUpperCase();
			}else {
				tempOriginal = original.toString();
				tempPadrao = pattern.toString();
			}

			var extracted:String;
			var realPadrao:String;
			while (tempOriginal.indexOf(tempPadrao) >= 0) {
				
				realPadrao = original.substr(tempOriginal.indexOf(tempPadrao), tempPadrao.length);
			
				/*var arr:Array = original.split(realPadrao);
				extracted = arr.join("");*/
				
				extracted = original.replace(realPadrao, replacewith);

				if (!caseSensitive) {
					tempOriginal = extracted.toUpperCase();
				}else {
					tempOriginal = extracted;
				}

				original = extracted;
			}
			return original;
		}
		
		
		/**
		 * Removes line feed, carriage return e tabs
		 * @param	original
		 * @return
		 */
		public static function clearSpecialChars(original:String):String{
			var regExp:RegExp;
			
			regExp = new RegExp(String.fromCharCode(9), "g");  
 			original = original.replace(regExp,"");
			
			regExp = new RegExp(String.fromCharCode(10), "g");  
			original = original.replace(regExp,"");
			
			regExp = new RegExp(String.fromCharCode(13), "g");  
			original = original.replace(regExp,"");
			
			return original;
		}
		
		
		public static  function isWhitespace( ch:String ):Boolean {
			return ch == '\r' || 
					ch == '\n' ||
					ch == '\f' || 
					ch == '\t' ||
					ch == ' '; 
		}
		
		/**
		 * Converts html encoded to plain text
		 * @param	str
		 * @return 
		 */
		 
		public static function htmlUnescape(str:String):String
		{
			var refArr:Array = StringUtils.HTML_ENTITIES;
			var _str:String = str;
			for (var i = 0; i < refArr.length; i++)
			{
				var arr:Array=_str.split(refArr[i][1]);
				_str = arr.join(refArr[i][0]);
			}

			return _str;
			
		}
		
		
		public static function escapeQuotes(original:String):String {
			var extracted:String;
			var pattern:RegExp = /\u0027+/g;  
   
			extracted = original.replace(pattern, "\\'");
			original = extracted;
			pattern = /\u0022+/g;  
			extracted = original.replace(pattern, "\\\"");
			original = extracted;
			
			return original;
		}
		
		public static function generateRandomKey (length:uint):String
		{

		  // start with a blank password
		  var password:String = "";

		  // define possible characters
		  var possible:String = "0123456789abcdefghjkmnpqrstvwxyz"; 
			
		  // set up a counter
		  var i:uint = 0; 
			
		  // add random characters to $password until $length is reached
		  var char:String;
		  while (i < length) { 

			// pick a random character from the possible ones
			char = possible.substr(NumberUtilities.random(0, possible.length-1), 1);
				
			// we don't want this character if it's already in the password
			if (password.indexOf(char)<0) { 
			  password += char;
			  i++;
			}

		  }

		  // done!
		  return password;

		}
		
		/**
		 * Receives a key char code (utf8) and returns de corresponding key input value 
		 * @param	num
		 * @return
		 */
		public static  function numberToChar(num:int):String {
			if (num > 47 && num < 58) {
				var strNums:String = "0123456789";
				return strNums.charAt(num - 48);
			} else if (num > 64 && num < 91) {
				var strCaps:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
				return strCaps.charAt(num - 65);
			} else if (num > 96 && num < 123) {
				var strLow:String = "abcdefghijklmnopqrstuvwxyz";
				return strLow.charAt(num - 97);
			} else {
				return num.toString();
			}
		}     
		
		/**
		 * Original namespace ascb.utils
		 * 
		 * @param	filename
		 * @return
		 */
		// This function returns everything after the last period, if any.
		public static function extractExtension( filename:String ):String {
			// Find the location of the period.
			var extensionIndex:Number = filename.lastIndexOf( '.' );
			if ( extensionIndex == -1 ) {
				// Oops, there is no period, so return the empty string.
				return "";
			} else {
				return filename.substr( extensionIndex + 1, filename.length );
			}
		}
		
		
		public static function serializeObject(obj:Object):String {
				
			var str:String;
			
			if (obj is Number  || obj is String ) {
				str = '\'' + obj.toString() + '\'';
			}else if (obj is Array) {
				
				str = '[';
				var i:int;
				var len:Number = (obj as Array).length;
				for (i = 0; i < len-1; i++) { str += StringUtils.serializeObject(obj[i]) + ','; }
				str += StringUtils.serializeObject(obj[i]) + ']';
		   }else {
				str = '{';
				var key:Object;
				for (key in obj) { str += key + ':' + StringUtils.serializeObject(obj[key]) + ','; }
				str = str.replace(/\,$/, '') + '}';
		   }
			   
			return str;
		}
	}
	
}