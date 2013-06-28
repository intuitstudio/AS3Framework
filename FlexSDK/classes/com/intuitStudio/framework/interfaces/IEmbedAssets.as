package com.intuitStudio.framework.interfaces
{
	public interface IEmbedAssets
	{
		function getAssetByName (symbolName:String):*;
		function get classRefPath():String;
		function set classRefPath(value:String):void;
	}
		
}