package com.intuitStudio.framework.concretes
{
	import com.intuitStudio.framework.abstracts.EmbedAssets;
	import flash.display.Bitmap;

	public class ImageAssets extends EmbedAssets
	{
		override protected function makeInstance(classRef:Class):*
		{
			return new classRef() as Bitmap;
		}
	}
}