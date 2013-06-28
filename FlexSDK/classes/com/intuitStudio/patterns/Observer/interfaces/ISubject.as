package com.intuitStudio.patterns.Observer.interfaces
{
	public interface ISubject
	{
		function subscribe (target:IObserver):void;
		function unsubscribe (target:IObserver):void;
		function notify (...rest):void;
	}

}