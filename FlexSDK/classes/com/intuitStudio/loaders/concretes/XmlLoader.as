package com.intuitStudio.loaders.concretes
{
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;

	import com.intuitStudio.loaders.core.RemoteLoader;

	public class XmlLoader extends RemoteLoader
	{
		protected var _data:XML;
		
	
		override protected function doGetData():*
		{
			return _data as XML;
		}
		
		override protected function completeHandler (e:Event):void
		{
			if (_data == null)
			{
				_data = new XML(e.target.data);				
			}
			dispatchEvent (e);
		}
		
	}

}