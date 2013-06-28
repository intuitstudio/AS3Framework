package com.intuitStudio.loaders.concretes
{
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;

	import com.intuitStudio.loaders.core.LoaderWrapper;

	public class ImageLoader extends LoaderWrapper
	{
		protected var _image:Bitmap;
		
		public function get image ():Bitmap
		{
			return _image;
		}

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
			if (_image == null)
			{
				_image = content as Bitmap;
			}
			dispatchEvent (e);
		}
		
	}

}