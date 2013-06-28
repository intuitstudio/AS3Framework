package com.intuitStudio.loaders.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.errors.IllegalOperationError;

	public class LoaderWrapper extends EventDispatcher
	{
		protected var _url:String;
		protected var _loader:Loader;
		protected var _request:URLRequest;
		protected var _bytesLoaded:Number = 0;
		protected var _bytesTotal:Number = 0;
		private var _percent:Number = 0;

		public function LoaderWrapper ()
		{
			_loader = new Loader();
			configureListeners ();
		}

		private function configureListeners ():void
		{
			var dispatcher:IEventDispatcher = _loader.contentLoaderInfo as IEventDispatcher;
			dispatcher.addEventListener (Event.COMPLETE, completeHandler);
			dispatcher.addEventListener (Event.OPEN, openHandler);
			dispatcher.addEventListener (Event.INIT, initHandler);
			dispatcher.addEventListener (Event.UNLOAD, unLoadHandler);
			dispatcher.addEventListener (ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
       
	    public function removeListeners():void
		{
			var dispatcher:IEventDispatcher = _loader.contentLoaderInfo as IEventDispatcher;
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
			trace('laderWrapper complete');
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
			_loader.unloadAndStop();
			removeListeners();
		}

		protected function httpStatusHandler (e:HTTPStatusEvent):void
		{
			//trace ('http Status is' ,e);
		}

		protected function ioErrorHandler (e:IOErrorEvent):void
		{
			trace ('load file error ', this._url);
			dispatchEvent (e);
		}
		
		final public function get loader():Loader
		{
			return _loader;
		}
		

		final public function get content ():Object
		{
			return _loader.contentLoaderInfo.content;
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
		
		public function unload():void
		{
			doUnLoad();
		}
		
		protected function doUnLoad():void
		{
			throw new IllegalOperationError('doUnLoad must be overridden');
		}
		
		protected function doLoad ():void
		{
			throw new IllegalOperationError('doLoad must be overridden');
		}

	}



}