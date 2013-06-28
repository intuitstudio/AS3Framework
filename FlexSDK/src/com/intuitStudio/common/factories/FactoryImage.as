package com.intuitStudio.common.factories
{
	import flash.display.Bitmap;
	import com.intuitStudio.images.core.BitmapWrapper;
	import com.intuitStudio.common.factories.abstracts.AssetsFB;
	import com.intuitStudio.framework.factories.abstracts.AbstractAssetFactory;

	public class FactoryImage extends BitmapWrapper
	{
		public  function FactoryImage (pathOrClass:Object,fc:AbstractAssetFactory)
		{
			AssetsFB.setFactory(fc);
			super(pathOrClass);
		}
		
		override protected function makeImageByFactory (assetName:String):Bitmap
		{			
			return AssetsFB.getEmbedAssetByName(assetName) as Bitmap;
		}
	}
}