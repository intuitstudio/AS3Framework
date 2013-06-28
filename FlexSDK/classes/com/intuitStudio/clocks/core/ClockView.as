package com.intuitStudio.clocks.core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.intuitStudio.clocks.core.ClockData;
	import com.intuitStudio.clocks.core.ClockTime;
	import com.intuitStudio.clocks.core.ClockController;

	public class ClockView extends Sprite
	{
		protected var _model:ClockData;
		protected var _controller:ClockController;

		public function ClockView (clock:ClockData,controller:ClockController)
		{
			_model = clock;
			_controller = controller;
			_model.addEventListener (Event.CHANGE,onUpdateView);
		}

		protected function getTimeString ():String
		{
			var time:ClockTime = _model.time;
			var timeString:String = " " + zeroFill(time.hour) + " : " + zeroFill(time.minute) + " : " + zeroFill(time.second) + " ";
			return timeString;
		}

		protected function getHandAngles (time:ClockTime):Vector.<Number > 
		{
			var angles:Vector.<Number> = new Vector.<Number>();
			var hr:Number = time.hour % 12;
			var mm:Number = time.minute;
			var ss:Number = time.second;
			var angleHR:Number = (30 * hr + 30 * mm / 60)/180 * Math.PI;
			var angleMM:Number = (6 * mm + 6 * ss / 60)/180 * Math.PI;
			var angleSS:Number = (6 * ss)/180 * Math.PI;
			angles.push (angleHR);
			angles.push (angleMM);
			angles.push (angleSS);
			return angles;
		}
		
		protected function zeroFill (value:Number):String
		{
			if (value > 9)
			{
				return value.toString();
			}
			else
			{
				return "0" + value;
			}
		}

		public function onUpdateView (e:Event):void
		{

		}

	}

}