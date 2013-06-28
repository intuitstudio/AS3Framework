package com.intuitStudio.common.patterns.observer.interfaces
{
	public interface ISubject
	{
		function addObserver(observer:IObserver,aspect:Function):Boolean;
		function removeObserver(observer:IObserver):Boolean;		
	}
	
}