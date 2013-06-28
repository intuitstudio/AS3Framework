package com.intuitStudio.dataProcess.XML.core
{
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.dataProcess.XML.core.XMLWrapper;

	dynamic public class XMLProxy extends Proxy implements IEventDispatcher
	{
		private var _wrapper:XMLWrapper;
		private var _eventDispatcher:EventDispatcher;
		private var _valid:Boolean = false;

		public function XMLProxy (wrapper:XMLWrapper)
		{
			_eventDispatcher = new EventDispatcher();
			_wrapper = wrapper;
			init ();
		}

		public function init ():void
		{ 
			_wrapper.addEventListener (Event.CHANGE,onReadyToRead);
			_valid = _wrapper.valid;
		}

		protected function onReadyToRead (e:Event):void
		{
			_wrapper.removeEventListener (Event.CHANGE,onReadyToRead);
			_valid = true;
			dispatchEvent (e);
		}

		final public function get wrapper ():XMLWrapper
		{
			return _wrapper;
		}

		final public function get xmlData ():XML
		{
			return _wrapper.data;
		}

		//----------------------------------------------------

		override flash_proxy function getProperty (params:*):*
		{
			if (_wrapper.data)
			{
				var result:XMLList = getElements(params);

				if (! result.toString())
				{
					result = getAttribute(params);
				}
				return result;
			}
			return null;
		}

		override flash_proxy function setProperty (params:*,value:*):void
		{
			if (_wrapper.data)
			{
				if (! setChildNodes(params,value))
				{
					setElements (params,value);
				}
			}
		}

		protected function getElements (params:*):*
		{
			throw new IllegalOperationError("getElements must be overridded by derivated classes");

			return null;
		}

		protected function getAttribute (name:*):*
		{
			throw new IllegalOperationError("getAttribute must be overridded by derivated classes");

			return null;
		}

		protected function setChildNodes (name:*,value:Object):Boolean
		{
			throw new IllegalOperationError("setChildNodes must be overridded by derivated classes");

			return false;
		}

		protected function setElements (name:*,value:Object):Boolean
		{
			throw new IllegalOperationError("setElements must be overridded by derivated classes");

			return false;
		}

		//Implements IEventDispatcher Interfaces
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