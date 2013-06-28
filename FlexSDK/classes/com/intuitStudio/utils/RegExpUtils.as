package com.intuitStudio.utils
{
	import com.intuitStudio.utils.EarthUtils;

	public class RegExpUtils
	{

		public static function checkEmail (data:String):Boolean
		{
			return false;
		}

		public static function checkIdCard (country:int=8886002):Boolean
		{
			switch (country)
			{
				case EarthUtils.NATION_CODE_TW :
					break;
				case EarthUtils.NATION_CODE_CHINA :

					break;
				case EarthUtils.NATION_CODE_JAPAN :
					break;
				case EarthUtils.NATION_CODE_USA :
					break;
				default :
			}

			return false;
		}

		public static function removeEdgeBlank (value:String):String
		{
			var pat:RegExp = /^\s*|\s*$/;
			value = value.replace(pat,"");

			return value;
		}

		public static function getAnyWordNumUnderline (data:String):String
		{
			var pat:RegExp = /[a-zA-Z0-9_ ][^class ][a-zA-Z0-9_]+/;
			data = pat.exec(data);
			data = removeEdgeBlank(data);
			return data;
		}

	}

}