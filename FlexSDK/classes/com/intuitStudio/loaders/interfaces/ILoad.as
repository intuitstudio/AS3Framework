package com.intuitStudio.loaders.interfaces
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	
	public interface ILoad
	{
		function  load(url:String):void;		
		function  onComplete(e:Event):void;
        function  progressing(e:ProgressEvent):void;
		function  onInit(e:Event):void;
		function  onOpen(e:Event):void;
		function  onIOError(e:IOErrorEvent):void;
		function  onSecurityError(e:SecurityErrorEvent):void;
		function  onHttpStatus (e:HTTPStatusEvent):void;
		function  onUnLoad(e:Event):void;
		
	}


	
}