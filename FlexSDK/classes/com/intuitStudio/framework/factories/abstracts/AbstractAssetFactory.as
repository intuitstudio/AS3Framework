package com.intuitStudio.framework.factories.abstracts
{
	import flash.utils.getDefinitionByName;
	import flash.errors.IllegalOperationError;
	
	import com.intuitStudio.framework.factories.interfaces.IAssetFactory;
	
	public class AbstractAssetFactory implements IAssetFactory
	{
        //----------- interface method , call by other classes or objects ------------
		
		public static function getEmbedAssetByName(assetName:String,type:int):*
		{
			throw new IllegalOperationError("getEmbedAssetByName must be overridden. ");
			return null;
		}
		
		public function makeAsset (assetName:String,type:int):*
		{
			return doMakeAsset(assetName,type);
		}

		public function getClassName (classRef:Class):String
		{
            return doGetClassName(classRef);
		}
		
		// ------- abstract methods , implement by sub class ---------
		
		protected function doMakeAsset (assetName:String,type:int):*
		{
			throw new IllegalOperationError("doMakeAsset will call makeAssetInstance function  , and must be overridden. ");
			return null;
		}
		
		protected function makeAssetInstance(symbolName:String,type:int):*
		{
			throw new IllegalOperationError("makeAssetInstance must be overridden. ");
			return null;		
		}

		protected function doGetClassName (classRef:Class):String
		{
			throw new IllegalOperationError("getClassName must be overridden. ");
			return null;
		}

	}


}