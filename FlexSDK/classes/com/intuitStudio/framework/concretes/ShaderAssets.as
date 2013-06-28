package com.intuitStudio.framework.concretes
{
	import com.intuitStudio.framework.abstracts.EmbedAssets;
	import flash.utils.ByteArray;
	import flash.display.Shader;

	public class ShaderAssets extends EmbedAssets
	{
		override protected function makeInstance(classRef:Class):*
		{
			return new Shader(new classRef() as ByteArray);
		}
	}
}