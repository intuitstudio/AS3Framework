package com.intuitStudio.loaders.core
{
	//custom safeloader
	import fl.display.SafeLoader;
	import fl.display.SafeLoaderInfo;
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.errors.IllegalOperationError;

	public class SafeLoaderWrapper extends EventDispatcher
	{
		protected var _url:String;
		protected var _loader:*;
		protected var _request:URLRequest;
		protected var _bytesLoaded:Number = 0;
		protected var _bytesTotal:Number = 0;
		private var _percent:Number = 0;

		public function SafeLoaderWrapper ()
		{
			_loader = new fl.display.SafeLoader();
			
		}

		private function configureListeners ():void
		{
			var dispatcher:IEventDispatcher = _loader.contentLoaderInfo as SafeLoaderInfo;
			dispatcher.addEventListener (Event.COMPLETE, completeHandler);
			dispatcher.addEventListener (Event.OPEN, openHandler);
			dispatcher.addEventListener (Event.INIT, initHandler);
			dispatcher.addEventListener (Event.UNLOAD, unLoadHandler);
			dispatcher.addEventListener (ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		public function removeListeners ():void
		{
			var dispatcher:IEventDispatcher = _loader.contentLoaderInfo as SafeLoaderInfo;
			dispatcher.removeEventListener (Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener (Event.OPEN, openHandler);
			dispatcher.removeEventListener (Event.INIT, initHandler);
			dispatcher.removeEventListener (Event.UNLOAD, unLoadHandler);
			dispatcher.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		protected function completeHandler (e:Event):void
		{
			trace ('safeLoaderWrapper complete');
			dispatchEvent (e);
		}

		protected function progressHandler (e:ProgressEvent):void
		{
			if (_bytesTotal == 0)
			{
				_bytesTotal = e.bytesTotal;
				if (_bytesTotal == 0 || isNaN(_bytesTotal))
				{
					_bytesTotal = 0.00000001;
				}
			}

			_bytesLoaded = e.bytesLoaded;
			_percent = (_bytesLoaded/_bytesTotal)*100;
			//trace ('loading... '+ _percent.toFixed(2) + ' %' );
		}

		protected function initHandler (e:Event):void
		{
			//trace ('initlizing...',this.width,this.height);
		}

		protected function openHandler (e:Event):void
		{
			//trace ('open resurce');
		}

		protected function unLoadHandler (e:Event):void
		{
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_loader.unloadAndStop ();
			
		}

		protected function httpStatusHandler (e:HTTPStatusEvent):void
		{
			//trace ('http Status is' ,e);
		}

		protected function ioErrorHandler (e:IOErrorEvent):void
		{
			dispatchEvent (e);
		}

		final public function get loader ():*
		{
			return _loader as fl.display.SafeLoader;
		}

		final public function get content ():DisplayObject
		{
			return _loader.content;
		}

		final public function get loadPercent ():Number
		{
			return _percent;
		}

		final public function load (url:String):void
		{
			_url = url;
			_percent = 0;
			doLoad ();
		}

		public function unload ():void
		{
			doUnLoad ();
		}

		protected function doUnLoad ():void
		{
			//throw new IllegalOperationError('doUnLoad must be overridden');
			_loader.unloadAndStop();
			removeListeners ();
		}

		protected function doLoad ():void
		{
			configureListeners ();
			_loader.load(new URLRequest(_url));
		}
	}
}