package com.intuitStudio.framework.concretes
{
	import com.intuitStudio.framework.abstracts.EmbedAssets;

	public class XMLAssets extends EmbedAssets
	{
		override protected function makeInstance(classRef:Class):*
		{
			return new classRef() as XML;
		}
	}
}