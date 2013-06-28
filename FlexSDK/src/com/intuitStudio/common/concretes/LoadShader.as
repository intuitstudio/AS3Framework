package com.intuitStudio.common.concretes
{
	import flash.display.Shader;
	import com.intuitStudio.shaders.core.ShaderWrapper;

	public class LoadShader extends ShaderWrapper
	{
		public  function LoadShader(pathOrClass:Object)
		{
			super(pathOrClass);
		}
		
		override protected function makeShaderByFactory (assetName:String):Shader
		{			
			return null;
		}
	}
}