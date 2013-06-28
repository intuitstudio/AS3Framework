package com.intuitStudio.framework.concretes
{
	import com.intuitStudio.framework.abstracts.EmbedAssets;
	import flash.media.Sound;

	public class AudioAssets extends EmbedAssets
	{
		override protected function makeInstance(classRef:Class):*
		{
			return new classRef() as Sound;
		}
	}
}