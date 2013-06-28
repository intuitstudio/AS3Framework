package com.intuitStudio.framework.concretes
{
	import com.intuitStudio.framework.abstracts.EmbedAssets;
	import flash.display.MovieClip;

	public class SwfAssets extends EmbedAssets
	{
		override protected function makeInstance(classRef:Class):*
		{
			return new classRef() as MovieClip;
		}
	}
}