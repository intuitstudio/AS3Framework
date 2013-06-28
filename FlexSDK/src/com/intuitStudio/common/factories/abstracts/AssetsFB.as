/*
    Define external Assets resource ,and provide methods to build instances of these assets.
	use meta tag [Embed()] to define linked resource class, global function makeAsset() is the interface for outside world.
	there are three kind of assets , bitmap,swf,and audio.
	
*/
package com.intuitStudio.common.factories.abstracts
{
	import com.intuitStudio.framework.factories.abstracts.AbstractAssetFactory;
	import com.intuitStudio.utils.RegExpUtils;

	public class AssetsFB extends AbstractAssetFactory
	{
		public static const MIMETYPE_IMAGE:int = 0;
		public static const MIMETYPE_SWF:int = 1;
		public static const MIMETYPE_SOUND:int = 2;
		public static const MIMETYPE_BYTES:int = 3;
		public static const MIMETYPE_SHADER:int = 4;

        protected static var _factory:AbstractAssetFactory;		
		
		public static function setFactory(obj:AbstractAssetFactory):void
		{
			_factory = obj;
		}
		
		public static function getEmbedAssetByName(assetName:String,type:int):*
		{
			if(_factory==null)
			{
				_factory = new AssetsFB();
			}
			
			return _factory.makeAsset(assetName,type);			
		}

		override protected function doGetClassName (classRef:Class):String
		{
			return RegExpUtils.getAnyWordNumUnderline(String(classRef));
		}
		
	}

}