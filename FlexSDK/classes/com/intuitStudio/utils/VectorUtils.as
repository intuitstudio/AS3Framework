package com.intuitStudio.utils
{
	import flash.utils.ByteArray;

	public class VectorUtils
	{
		public static function vector2Array (vec:*):Array
		{
			var result:Array = new Array();
			for (var i:uint = 0; i<vec.length; i++)
			{
				result[i] = vec[i];
			}
			return result;
		}

		public static function sortOn (vec:*,fieldName:String,options:Object=null):Array
		{
			return vector2Array(vec).sortOn(fieldName, options);
		}

		public static function clone (vec:*):*
		{
			var ba:ByteArray = new ByteArray();
			ba.writeObject (vec);
			ba.position = 0;
			return ba.readObject();
		}
		
		public static function toString(vec:*):String
		{
			var str:String = '';
			trace(vec.length)
			for (var i:uint=0;i<vec.length;i++)
			{
				var obj:Object = vec[i] as Object;
				str += obj.toString();
			}			
			return str;
		}

	}

}