package com.intuitStudio.clocks.abstracts
{
	import flash.errors.IllegalOperationError;
	import com.intuitStudio.clocks.core.ClockView;
	import com.intuitStudio.clocks.core.ClockData;
	import com.intuitStudio.clocks.core.ClockController;

	public class AbstractClockView extends ClockView
	{
		public function AbstractClockView (model:ClockData,controller:ClockController)
		{
			super (model,controller);
			init ();
		}

		protected function init ():void
		{
			createClockFace ();
		}

		public function createClockFace ():void
		{
			makeImages ();
			doCreateClockFace ();
			drawClock();
		}
		
		protected function makeImages():void
		{
			throw new IllegalOperationError('makeImages must be overridden');
		}

		protected function doCreateClockFace ():void
		{
			throw new IllegalOperationError('doCreatClockFace must be overridden');
		}
		
		protected function drawClock ():void
		{
			throw new IllegalOperationError('drawClock must be overridden');
		}
    }

}