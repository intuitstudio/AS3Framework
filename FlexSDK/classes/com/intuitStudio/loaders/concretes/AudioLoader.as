package com.intuitStudio.loaders.concretes
{
 
	import flash.net.URLRequest;
	import flash.events.Event;

	import com.intuitStudio.loaders.core.LoaderWrapper;

	public class AudioLoader extends LoaderWrapper
	{
		override protected function doLoad ():void
		{
			_request = new URLRequest(_url);
			_loader.load (_request);
		}
		
		override protected function doUnLoad ():void
		{
			_loader.unload ();
		}
		
		override protected function completeHandler (e:Event):void
		{
			dispatchEvent (e);
		}
		
	}

}