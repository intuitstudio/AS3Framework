package com.intuitStudio.framework.factories.interfaces
{
	public interface IAssetFactory
	{
		function makeAsset (assetName:String,type:int):*;
		function getClassName (classRef:Class):String;
    }
	
}