package com.intuitStudio.loaders.core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;

	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.errors.IllegalOperationError;
	import flash.errors.IOError;
	import flash.net.URLVariables;

	public class RemoteLoader extends EventDispatcher
	{
		protected var _url:String;
		protected var _loader:URLLoader;
		protected var _request:URLRequest;
		protected var _requestMethod:String;
		protected var _requestType:String;
		protected var _requestVars:URLVariables;
		protected var _requestData:Object;

		public function RemoteLoader ()
		{
			_loader = new URLLoader();
			configureListeners ();
		}

		protected function configureListeners ():void
		{
			_loader.addEventListener (Event.COMPLETE, completeHandler);
			_loader.addEventListener (Event.OPEN, openHandler);
			_loader.addEventListener (ProgressEvent.PROGRESS, progressHandler);
			_loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_loader.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			_loader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		protected function removeListeners ():void
		{
			_loader.removeEventListener (Event.COMPLETE, completeHandler);
			_loader.removeEventListener (Event.OPEN, openHandler);
			_loader.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			_loader.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_loader.removeEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			_loader.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		protected function completeHandler (e:Event):void
		{
			removeListeners();
			dispatchEvent (e);
		}
		
		protected function openHandler (e:Event):void
		{
			dispatchEvent (e);
		}
		protected function progressHandler (e:ProgressEvent):void
		{
			dispatchEvent (e);
		}
		protected function securityErrorHandler (e:SecurityErrorEvent):void
		{
			throw new IOError("SecurityError occur when loading requested document!");
		}
		protected function httpStatusHandler (e:HTTPStatusEvent):void
		{
			dispatchEvent (e);
		}
		protected function ioErrorHandler (e:IOErrorEvent):void
		{
			trace('檔案讀取失敗');
			throw new IOError("Unable to load requested document");
		}

		final public function load (url:String):void
		{
			doRemoteLoad (url);
		}

		protected function doRemoteLoad (url:String):void
		{
			_url = url;
			_request = new URLRequest(url);
			if (_requestMethod)
			{
				_request.method = _requestMethod;
			}
			if (_requestVars)
			{
				_request.data = _requestVars;
			}
			if (_requestType)
			{
				_request.contentType = _requestType;
			}
			if (_requestData)
			{
				_request.data = _requestData;
			}

			try
			{
				_loader.load (_request);
			}
			catch (error:Error)
			{
				trace ("Unable to load requested document.");
				throw new IOError("Unable to load requested document");
			}
		}

		final public function get url ():String
		{
			return _url;
		}

		final public function get data ():*
		{
			return doGetData();
		}

		final public function set requestMethod (value:String):void
		{
			if (value.toLocaleUpperCase() == "POST")
			{
				_requestMethod = URLRequestMethod.POST;
			}
			else
			{
				if (value.toLocaleUpperCase() == "GET")
				{
					_requestMethod = URLRequestMethod.GET;
				}
			}
		}

		final public function set requestVars (data:URLVariables):void
		{
			_requestVars = data;
		}

		final public function set dataFormat (format:String):void
		{
			_loader.dataFormat = format;
		}

		final public function set requestType (type:String):void
		{
			_requestType = type;
		}

		final public function set requestData (data:Object):void
		{
			_requestData = data;
		}
		
		protected function doGetData():*
		{
			return _loader.data;
		}
		
		
	}

}