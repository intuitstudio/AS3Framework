package com.intuitStudio.loaders.core
{
	/**
	 * RemoteWrapper Class 
	 * @author Vanier,Peng 2013.5.17
	 * 封裝資料傳送接收的溝通及數據交換的行為，例如呼叫伺服端應用程式或服務，讀取遠端文件內容...等
	 * 
	 */
	
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

	public class RemoteWrapper extends EventDispatcher
	{
		protected var _url:String;
		protected var _loader:URLLoader;
		protected var _request:URLRequest;
		protected var _requestMethod:String;
		protected var _requestType:String;
		protected var _requestVars:URLVariables;
		protected var _requestData:Object;

		public function RemoteWrapper ()
		{
			loader = new URLLoader();
			request = new URLRequest();
			configureListeners ();
		}

		protected function configureListeners ():void
		{
			loader.addEventListener (Event.COMPLETE, completeHandler);
			loader.addEventListener (Event.OPEN, openHandler);
			loader.addEventListener (ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		protected function removeListeners ():void
		{
			loader.removeEventListener (Event.COMPLETE, completeHandler);
			loader.removeEventListener (Event.OPEN, openHandler);
			loader.removeEventListener (ProgressEvent.PROGRESS, progressHandler);
			loader.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.removeEventListener (HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.removeEventListener (IOErrorEvent.IO_ERROR, ioErrorHandler);
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

		/**
		 * 外部呼叫的公共界面
		 * @param	{url:String} , 資源網址 
		 */
		final public function load (path:String):void
		{
			doRemoteLoad (path);
		}

		protected function doRemoteLoad (path:String):void
		{
			url = path;
			request.url = path;
			
			if (requestMethod)
			{
				request.method = requestMethod;
			}
			if (requestVars)
			{
				request.data = requestVars;
			}
			if (requestType)
			{
				request.contentType = requestType;
			}
			if (requestData)
			{
				request.data = requestData;
			}

			try
			{
				loader.load (request);
			}
			catch (error:Error)
			{
				trace ("Unable to load requested document.");
				throw new IOError("Unable to load requested document");
			}
		}

		final public function get loader ():URLLoader
		{
			return _loader;
		}
		
		final public function set loader(target:URLLoader):void
		{
		  _loader = target;	
		}		
		
		final public function get url ():String
		{
			return _url;
		}
		
		final public function set url(path:String):void
		{
		  _url = path;	
		}		

		final public function get data ():*
		{
			return doGetData();
		}
		
		final public function get requestMethod():String 
		{
			return _requestMethod;
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
		
		final public function get requestVars():URLVariables
		{
			return _requestVars;
		}

		final public function set requestVars (vars:URLVariables):void
		{
			_requestVars = vars;
		}

		final public function set dataFormat (format:String):void
		{
			_loader.dataFormat = format;
		}

		final public function get requestType():String
		{
		   return _requestType;	
		}
		
		final public function set requestType (type:String):void
		{
			_requestType = type;
		}

		final public function get requestData():Object
		{
		   return _requestData;	
		}
		
		final public function set requestData (data:Object):void
		{
			_requestData = data;
		}
		
		final public function get request():URLRequest
		{
			return _request;
		}
		
		final public function set request(req:URLRequest):void
		{
			_request = req;
		}
		
		/**
		 * 清除事件監聽以及內容，釋出系統資源
		 */
		public function dispose():void
		{
			loader.close();			
			this.removeListeners();
			loader = null;
			request = null;
			requestVars = null;
			requestData = null;
		}		
		
		/**
		 * 洐生的子類別可視實際需求自行覆寫本函式內容 
		 */
		protected function doGetData():*
		{
			return _loader.data;
		}
		
		
	}

}