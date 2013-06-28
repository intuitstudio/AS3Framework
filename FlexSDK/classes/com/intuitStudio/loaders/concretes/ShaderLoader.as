package com.intuitStudio.loaders.concretes
{
	import flash.display.Shader;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.net.URLLoaderDataFormat;

	import com.intuitStudio.loaders.core.RemoteLoader;
	
	public class ShaderLoader extends RemoteLoader
	{
		protected var _shader:Shader;
		
		override protected function doRemoteLoad (url:String):void
		{
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			super.doRemoteLoad (url);
		}
		
		override protected function completeHandler (e:Event):void
		{
			if(_shader==null)
			{
			    _shader = new Shader(_loader.data as ByteArray);			
			}			
			dispatchEvent (e);
		}
		
		public function get shader():Shader
		{
			return _shader;
		}
		
	}

}