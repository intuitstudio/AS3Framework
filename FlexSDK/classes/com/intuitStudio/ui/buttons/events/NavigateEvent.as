package com.intuitStudio.ui.buttons.events
{
    import flash.events.Event;

	public class NavigateEvent extends Event
	{
		public static const SCROLL_UP:String = 'ScrollUp';
		public static const SCROLL_DOWN:String = 'ScrollDown';
		public static const SCROLL_LEFT:String = 'ScrollLeft';
		public static const SCROLL_RIGHT:String = 'ScrollRight';
		public static const SCROLL_START:String = 'ScrollStart';
		public static const SCROLL_STOP:String = 'ScrollStop';
		public static const GOPREVIOUS:String = 'goPrevious';
		public static const GONEXT:String = 'goNext';		
		
		private var _navigate:String = '';
		
		public function NavigateEvent(type:String,navigate:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super (type, bubbles, cancelable);
			_navigate = navigate;			
		}

		public override function clone ():Event
		{
			return new NavigateEvent(type,_navigate,bubbles,cancelable);
		}
		
		public function getNavigateCommand():String
		{
			return _navigate;
		}		
		
	}	
}