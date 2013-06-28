package com.intuitStudio.patterns.Observer
{
	import com.intuitStudio.patterns.Observer.interfaces.IObserver;
	
	public class RealObserver implements IObserver
	{
		private var _subName:String;
		
		public function RealObserver (name:String)
		{
			subName = name;
		}
		
		public function get subName():String
		{
		   return _subName;	
		}
		
		public function set subName(value:String):void
		{
			_subName = value;
		}
		
		public function change (...arg):void
		{
			trace('Method change must be overridden.'); 
		}

	}

}