package com.intuitStudio.utils
{
	public class TraceUtil
	{

		public static const INFO:String = 'info';
		public static const WARNING:String = "warning";
		public static const ERROR:String = 'error';

		public static var throwErrors:Boolean = false;
		public static var filter:Array = [INFO,WARNING,ERROR];

		public function TraceUtil ()
		{
			throw new Error("TraceUtil class cannot be instantiated");
		}

		public static function Trace (message:String,category:String=INFO):void
		{
			if (category == ERROR && throwErrors)
			{
				throw new Error(message);
			}

			if (! filter || ! filter.length || filter.indexOf(category) > -1)
			{
				trace (message);
			}
		}

		public static function TraceObject (message:String,object:Object,category:String=INFO):void
		{
			if (message)
			{
				Trace (message,category);
			}
			Trace (" " + object , category);
			for (var i:String in object)
			{
				Trace (" " + i + " : " + object[i] , category);
			}
		}

	}
}