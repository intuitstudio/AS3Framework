package com.intuitStudio.common.factories
{
	import flash.media.Sound;
	import com.intuitStudio.audios.core.AudioController
	import com.intuitStudio.common.factories.abstracts.AssetsFB;
	import com.intuitStudio.framework.factories.abstracts.AbstractAssetFactory;

	public class FactoryAudio extends AudioController
	{
		public  function FactoryImage (pathOrClass:Object,fc:AbstractAssetFactory)
		{
			AssetsFB.setFactory(fc);
			super(pathOrClass);
		}
		
		override protected function makeSoundByFactory (assetName:String):Sound
		{			
			return AssetsFB.getEmbedAssetByName(assetName) as Sound;
		}
	}
}