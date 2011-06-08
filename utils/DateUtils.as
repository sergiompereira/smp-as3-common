package com.smp.common.utils
{
	
	public class DateUtils
	{

		public static const PORTUGUESE_MONTHS:Array = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];

		
		public static function daysInMonth(iMonth:Number, iYear:Number):Number
		{
			return 32 - new Date(iYear, iMonth, 32).getDate();
		}
		
		public static function getPortugueseMonthById(id:uint, maxchars:uint = 0 ):String {
			if (maxchars > 0) {
				return DateUtils.PORTUGUESE_MONTHS[id].substr(0,maxchars);
			}
			return DateUtils.PORTUGUESE_MONTHS[id];
		}
	}
	
}