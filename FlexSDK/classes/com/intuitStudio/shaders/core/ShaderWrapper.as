package com.intuitStudio.shaders.core
{
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.loaders.concretes.ShaderLoader;

	public class ShaderWrapper extends EventDispatcher
	{
		protected var _loader:ShaderLoader;//used  for loading shader file
		protected var _shader:Shader;
		protected var _percision:String;//used to set shader.precisionHint property ,default value is ShaderPercision.FULL.
		protected var _valid:Boolean = false;

/**
        *  Constructure , there are three ways to manufacture wrapper : 
        * with Class Object embed , create shader object directly
        * with Class Name definded , create shader object by other asset factory class
        * with file path , loading external shader pbk file
        */
		public function ShaderWrapper (pathOrClass:Object = null)
		{
			_shader = new Shader();
			if(pathOrClass)
			{
			  init (pathOrClass);
			}
		}

		public function init (pathOrClass:Object):void
		{
			addEventListener (Event.COMPLETE,onShaderReady);
			makeShader (pathOrClass);
		}

		protected function makeShader (pathOrClass:Object):void
		{
			var classRef:Class = pathOrClass as Class;
			if (classRef != null)
			{
				makeShaderByData (ByteArray(new classRef()));
			}
			else
			{
				var shader:Shader = makeShaderByFactory(pathOrClass as String);
				if (shader != null)
				{
					_shader = shader;
					dispatchEvent (new Event(Event.COMPLETE));
				}
				else if ( (pathOrClass as String ) != null)
				{
					makeShaderByLoadFile (pathOrClass as String);
				}
				else
				{
					throw new IllegalOperationError('Invalid object passed to ShaderWrapper !');
				}
			}
		}

		private function makeShaderByData (data:ByteArray):void
		{
			setShaderByBytecode (data);
			dispatchEvent (new Event(Event.COMPLETE));
		}

		protected function makeShaderByFactory (assetName:String):Shader
		{
			throw new IllegalOperationError('makeShaderByFactory must be overridden by derivative classes !');
			return null;
		}

		protected function makeShaderByLoadFile (url:String):void
		{
			if (_loader == null)
			{
				_loader = new ShaderLoader();
				_loader.addEventListener (Event.COMPLETE,onShaderLoaded);
			}
			_loader.load (url);
		}

		protected function onShaderReady (e:Event):void
		{
			//trace (' ShaderWrapper > onShaderReady' );
			removeEventListener (Event.COMPLETE,onShaderReady);
			_valid = true;
			dispatchEvent(new Event(Event.RENDER));
		}

		private function onShaderLoaded (e:Event):void
		{
			_shader = _loader.shader;
			dispatchEvent (e);
			_loader.removeEventListener (Event.COMPLETE,onShaderLoaded);
			_loader = null;
		}

		public function setShaderByBytecode (value:ByteArray):void
		{
			if (_shader == null)
			{
				_shader = new Shader();
			}
			_shader.byteCode = value;
		}

		public function get shader ():Shader
		{
			return _shader;
		}

		public function get information ():ShaderData
		{
			return _shader.data;
		}

		public function get percision ():String
		{
			return _shader.precisionHint;
		}

		public function set percision (value:String):void
		{
			_shader.precisionHint = value;
		}

		override public function toString ():String
		{
			return _shader.data.toString;
		}

		public function get valid ():Boolean
		{
			return _valid;
		}

	}
}