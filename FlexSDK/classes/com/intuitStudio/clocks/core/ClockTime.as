package com.intuitStudio.clocks.core
{
	public class ClockTime
	{
		private var _hour:uint;
		private var _minute:uint;
		private var _second:uint;

		public function ClockTime (hour:uint=0, minute:uint=0, second:uint=0)
		{
			_hour = hour;
			_minute = minute;
			_second = second;
		}

		public function get hour ():uint
		{
			return _hour;
		}

		public function set hour (value:uint):void
		{
			_hour = value;
		}

		public function get minute ():uint
		{
			return _minute;
		}

		public function set minute (value:uint):void
		{
			_minute = value;
		}

		public function get second ():uint
		{
			return _second;
		}

		public function set second (value:uint):void
		{
			_second = value;
		}

		public function clone ():ClockTime
		{
			return new ClockTime(_hour, _minute, _second);
		}
		
		public static function transToSeconds():Number
		{
			return 0;
		}
	}
}