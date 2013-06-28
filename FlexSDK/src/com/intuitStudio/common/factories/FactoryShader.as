package com.intuitStudio.common.factories
{
	import flash.display.Shader;
	import com.intuitStudio.shaders.core.ShaderWrapper;
	import com.intuitStudio.common.factories.abstracts.AssetsFB;
	import com.intuitStudio.framework.factories.abstracts.AbstractAssetFactory;

	public class FactoryShader extends ShaderWrapper
	{
		public  function FactoryShader (pathOrClass:Object,fc:AbstractAssetFactory)
		{
			AssetsFB.setFactory(fc);
			super(pathOrClass);
		}
		
		override protected function makeShaderByFactory (assetName:String):Shader
		{			
			return AssetsFB.getEmbedAssetByName(assetName) as Shader;
		}
	}
}