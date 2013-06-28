package com.intuitStudio.clocks.core
{	
    import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import com.intuitStudio.clocks.core.ClockTime;
	import com.intuitStudio.utils.GameTimer;
	
	public class ClockData extends EventDispatcher
	{
		protected var _frameHolder:Sprite;
		protected var _hourMeter:GameTimer;
		protected var _time:ClockTime;
		protected var _realTime:Boolean;
		protected var _startTime:uint;
		
		public function ClockData()
		{
			_startTime = getTimer();
			_frameHolder = new Sprite();
			_frameHolder.addEventListener(Event.ENTER_FRAME,onFrameLoop);
			_hourMeter = new GameTimer(onTick);
			_realTime = false;
		}
		
		private function onFrameLoop(e:Event):void
		{
			_hourMeter.tick ();
		}
		
		private function onTick():void
	    {
			if (_realTime)
			{
				dispatchEvent (new Event(Event.CHANGE));
			}
		}
		
		public function get time ():ClockTime
		{
			if (_realTime || _time == null)
			{
				var date:Date;

				if (_time == null)
				{
					date = new Date();
				}
				else
				{
					date = new Date(null, null, null, _time.hour, _time.minute,_time.second);
					date.milliseconds = getTimer() + _startTime;
				}
				return new ClockTime(date.hours, date.minutes, date.seconds);
			}
			else
			{
				return _time.clone();
			}
		}

		public function set time (value:ClockTime):void
		{
			_time = value.clone();
			dispatchEvent (new Event(Event.CHANGE));
		}
		
		public function set realTime (value:Boolean):void
		{
			_realTime = value;
		}
		
	}	
}