package com.intuitStudio.patterns.Observer
{
	import com.intuitStudio.patterns.Observer.interfaces.*;
	
	public class RealSubject implements ISubject
	{
		private var _observers:Vector.<IObserver>;

		public function RealSubject ()
		{
			observers = new Array  ;
		}
		
		public function get observers():Vector.<IObserver>
		{
			return _observers;
		}
		
		public function set observers(data:Vector.<IObserver>):void
		{
			_observers = data;
		}		
		
		public function subscribe (target:IObserver):void
		{
			for (var ob:int = 0; ob < observers.length; ob++)
			{
				if (observers[ob] == target)
				{
					trace ('target has subscribed in Subject allready!');					
					return;
				}
			}
			observers.push (target);
		}
		
		public function unsubscribe (target:IObserver):void
		{
			for (var ob:int = 0; ob < observers.length; ob++)
			{
				if (observers[ob] == target)
				{
					trace('remove observer ' + ob);
					observers.splice (ob,1);
					break;
				}
			}
		}
		
		/**
		 * 通知所有被觀察對象 
		 * @param	...rest
		 */
		public function notify(...rest):void{
			for(var symbol:IObserver in observers)
			{				
				var argment:Array = rest||[];
				observers[symbol].change.apply(argment);
			}			
		}


	}






}