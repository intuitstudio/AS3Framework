package com.intuitStudio.framework.interfaces
{
	import flash.events.Event;
	public interface IEventHandler
	{
		function addHandler ( eventHandler:IEventHandler ):void;
		function forwardEvent ( e : Event ):void;
	}

}