package com.intuitStudio.drawAPIs.abstracts
{
	import flash.display.Shader;
	import flash.events.Event;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.loaders.concretes.ShaderLoader;

	public class AbstractShaderWrapper extends ShaderLoader
	{
		public function AbstractShaderWrapper (pathOrClassName:String)
		{
			_shader = createShader(pathOrClassName);
			if (_shader != null)
			{
				dispatchEvent (new Event(Event.RENDER));
			}
			else if (pathOrClassName != "" )
			{
				load (pathOrClassName as String);
			}
			else
			{
				throw new IllegalOperationError('Invalid object passed to AbstractShaderWrapper !');
			}
		}

		protected function createShader (className:String):Shader
		{
			throw new IllegalOperationError('createShader must be overridden by derivative classes !');
			return null;
		}

	}

}