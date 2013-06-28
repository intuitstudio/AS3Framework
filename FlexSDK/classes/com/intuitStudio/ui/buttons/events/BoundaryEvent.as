package com.intuitStudio.ui.buttons.events
{
    import flash.events.Event;

	public class BoundaryEvent extends Event
	{
		public static const ENTER:String = 'enterBoundary';
		public static const LEAVE:String = 'outOfBoundary';
		
		private var outOfBoundary:Boolean = false;
		
		public function BoundaryEvent(type:String,isOut:Boolean=true,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super (type, bubbles, cancelable);
			outOfBoundary = isOut;			
		}

		public override function clone ():Event
		{
			return new BoundaryEvent(type,outOfBoundary,bubbles,cancelable);
		}
		
		public function isOut():Boolean
		{
			return outOfBoundary;
		}		
	}	
}