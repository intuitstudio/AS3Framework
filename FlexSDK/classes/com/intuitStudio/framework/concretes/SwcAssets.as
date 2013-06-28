package com.intuitStudio.framework.concretes
{
	import com.intuitStudio.framework.abstracts.EmbedAssets;
	import flash.utils.ByteArray;

	public class SwcAssets extends EmbedAssets
	{
		override protected function makeInstance(classRef:Class):*
		{
			return new classRef() as ByteArray;
		}
	}
}