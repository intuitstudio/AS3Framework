package com.intuitStudio.dataProcess.files
{
	import flash.display.Bitmap;
	import flash.net.FileFilter;
	import flash.events.Event;
	import com.intuitStudio.loaders.core.OpenLocalFile;
	import com.intuitStudio.loaders.concretes.ImageLoader;
	import com.intuitStudio.loaders.core.LoaderWrapper;


	public class OpenLocalImage extends OpenLocalFile
	{
		protected var _loader:LoaderWrapper;
		protected var _bitmap:Bitmap;

		public function OpenLocalImage ()
		{
			_bitmap = new Bitmap  ;
			super ();
		}

		override protected function doMakeFileFilter ():void
		{
			_fileFilters = [new FileFilter("Images","*.jpg;*.jpeg;*.gif;*.png")];
		}

		override protected function onFileSelect (e:Event):void
		{
			_file.addEventListener (Event.COMPLETE,onImageLoadComplete);
			_file.addEventListener (Event.CANCEL,onImageLoadCancel);
			_file.load ();
		}

		private function onImageLoadComplete (e:Event):void
		{
			_loader = new ImageLoader  ;
			_loader.addEventListener (Event.COMPLETE,onLocalFileRead);
			_loader.loader.loadBytes (_file.data);
		}

		private function onImageLoadCancel (e:Event):void
		{
			dispatchEvent (e);
		}

		private function onLocalFileRead (e:Event):void
		{
			_bitmap.bitmapData = ImageLoader(_loader).image.bitmapData.clone();
			dispatchEvent (new Event(Event.RENDER));
		}

		public function get image ():Bitmap
		{
			return _bitmap;
		}

		public function dispose ():void
		{
			if (_file)
			{
				_file.removeEventListener (Event.COMPLETE,onImageLoadComplete);
				_file.removeEventListener (Event.CANCEL,onImageLoadCancel);
				_file = null;
			}
           
		    if(_loader)
			{
				_loader.removeEventListener (Event.COMPLETE,onLocalFileRead);
				_loader.unload();
				_loader = null;
			} 
			
			if(_bitmap)
			{
				_bitmap.bitmapData.dispose();
				_bitmap = null;
			}

		}

	}

}