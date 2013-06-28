package com.intuitStudio.clocks.core
{
	import flash.events.Event;
	
	public class ClockController
	{
		protected var _model:ClockData;
		protected var _elapsed:Number = 0;
		protected var _unitTime:Number = 1;//second
		
		public function ClockController (data:ClockData)
		{
			_model = data;
		}

		
		public function modifyDate():void
		{
			
		}
		
		public function modifyHour():void
		{
			
		}
		
		public function modifyMinute():void
		{
			
		}
		
		public function modifySecond():void
		{
			
		}
		
		public function update(elapsed:Number):void
		{

		}
	}

}