package com.intuitStudio.common.concretes
{
	import flash.display.Bitmap;
	import com.intuitStudio.images.core.BitmapWrapper;

	public class LoadImage extends BitmapWrapper
	{
		public  function LoadImage(pathOrClass:Object)
		{
			super(pathOrClass);
		}
		
		override protected function makeImageByFactory (assetName:String):Bitmap
		{			
			return null;
		}
	}
}