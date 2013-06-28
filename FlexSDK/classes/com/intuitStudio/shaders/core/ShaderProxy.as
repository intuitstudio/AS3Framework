package com.intuitStudio.shaders.core
{
	import flash.display.Shader;
	import flash.display.ShaderData;
	import flash.display.ShaderParameter;
	import flash.display.ShaderInput;
	import flash.utils.ByteArray;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.shaders.core.ShaderWrapper;

	dynamic public class ShaderProxy extends Proxy implements IEventDispatcher
	{
		private var _shader:ShaderWrapper;
		private var _eventDispatcher:EventDispatcher;
		private var _valid:Boolean = false;

		public function ShaderProxy (wrapper:ShaderWrapper)
		{
			_eventDispatcher = new EventDispatcher();
			_shader = wrapper;
			init ();
		}

		public function init ():void
		{
			if (! _shader.valid)
			{
				_shader.addEventListener (Event.RENDER,onReadyToRender);
			}
			else
			{
				_valid = true;
			}
		}

		protected function onReadyToRender (e:Event):void
		{
			removeEventListener (Event.RENDER,onReadyToRender);
			_valid = true;
			dispatchEvent (new Event(Event.RENDER));
		}

		final public function get wrapper ():ShaderWrapper
		{
			return _shader;
		}

		final public function get shader ():Shader
		{
			return _shader.shader;
		}

		final public function get information ():ShaderData
		{
			return _shader.shader.data;
		}

		final public function get percision ():String
		{
			return _shader.shader.precisionHint;
		}

		final public function set percision (value:String):void
		{
			_shader.shader.precisionHint = value;
		}

		public function toString ():String
		{
			return _shader.shader.data.toString();
		}

		public function get valid ():Boolean
		{
			return _valid;
		}

		//----------------------------------------------------

		override flash_proxy function getProperty (name:*):*
		{
			if (_shader.shader)
			{
				var result:Object = getParameter(name);
				if(result==null)
				{
					result = getInput(name);
				}
				return result;
			}
			return null;
		}

		override flash_proxy function setProperty (name:*,value:*):void
		{
			if (_shader.shader)
			{
				if(!setParameter(name,value))
				{
				   setInput (name,value);
				}
			}
		}

		public function getParameter (name:String):Object
		{
			if (_shader.shader.data.hasOwnProperty(name) && _shader.shader.data[name] is ShaderParameter)
			{
				var value:Object = _shader.shader.data[name].value;
				var type:String = _shader.shader.data[name].type;
				if (type == "float" || type == "int")
				{
					value = (value as Array)[0];
				}
				return value;
			}
			return null;
		}

		public function setParameter (name:String,value:Object):Boolean
		{
			if (_shader.shader.data.hasOwnProperty(name) && _shader.shader.data[name] is ShaderParameter)
			{
				if (!(value is Array))
				{
					value = [value];
				}
				_shader.shader.data[name].value = value;
				return true;
			}
			return false;
		}

        public function setInput(name:String,value:Object):Boolean
		{
			if(_shader.shader.data.hasOwnProperty(name) && _shader.shader.data[name] is ShaderInput)
			{
				_shader.shader.data[name].input = value;
				return true;
			}
			return false;
		}
		
		public function getInput(name:String):Object
		{
			if (_shader.shader.data.hasOwnProperty(name) && _shader.shader.data[name] is ShaderInput)
			{
				return _shader.shader.data[name].input;				
			}
			return null;			
		}

		public function addEventListener (type:String,listener:Function,useCapture:Boolean=false,priority:int=0,useWeakReference:Boolean=true):void
		{
			_eventDispatcher.addEventListener (type,listener,useCapture,priority,useWeakReference);
		}

		public function removeEventListener (type:String,listener:Function,useCapture:Boolean=false):void
		{
			_eventDispatcher.removeEventListener (type,listener,useCapture);
		}

		public function dispatchEvent (e:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(e);
		}

		public function willTrigger (type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}

		public function hasEventListener (type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}

	}
}