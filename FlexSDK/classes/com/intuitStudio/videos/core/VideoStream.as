package com.intuitStudio.videos.core
{
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;

	public class VideoStream extends Video
	{
		public static const CONNECT:String = "connectSuccess";
		public static const STREAMNOTFOUND:String = "streamNotFound";
		public static const STREAMPLAY:String = 'streamPlay';
		public static const STARTPLAYSTREAM:String = "startPlayStream";
		public static const SECURITYERROR:String = "securityError";
		public static const ASYNCERROR:String = "asyncError";
		public static const STOP:String = "stopStream";
		public static const COMPLETE:String = "streamComplete";

		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _streamPath:String;
		private var _metaObj:Object;
		private var _bufferTime:Number = 10;
		private var _width:Number = 320;
		private var _height:Number = 240;
		private var _duration:Number = 0;

		public function VideoStream ()
		{
			init ();
		}

		protected function init ():void
		{
			//
			_metaObj = new Object();
			_metaObj.onMetaData = onMetaData;
			_metaObj.onCuePoint = onCuePoint;
			_metaObj.onImageData = onImageData;
			_metaObj.onPlayStatus = onPlayStatus;
			_metaObj.onTextData = onTextData;
			_metaObj.onXMPData = onXMPData;
		}

		public function makeVideo (url:String):void
		{			
			_streamPath = url;
			_nc = new NetConnection();
			startConnectEvent (true);
			_nc.connect (null);
		}

		private function connectStream ():void
		{
			_ns = new NetStream(_nc);
			_ns.addEventListener (NetStatusEvent.NET_STATUS,onNetStatus);
			_ns.client = _metaObj;
			_ns.bufferTime = _bufferTime;
			attachNetStream (_ns);
			var unique:String = (_streamPath.indexOf('http:')!=-1)
			?_streamPath+"?uniqueIndex="+ new Date().getTime()
			:_streamPath;
			_ns.play (unique);
		}

		public function startProgressEvent (start:Boolean):void
		{
			(start)?addEventListener(Event.ENTER_FRAME,onFrameLoop):removeEventListener(Event.ENTER_FRAME,onFrameLoop);
		}

		private function startConnectEvent (start:Boolean):void
		{
			if (start)
			{
				_nc.addEventListener (NetStatusEvent.NET_STATUS,onNetStatus);
				_nc.addEventListener (SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			}
			else
			{
				_nc.removeEventListener (NetStatusEvent.NET_STATUS,onNetStatus);
				_nc.removeEventListener (SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			}
		}

		private function onNetStatus (e:NetStatusEvent):void
		{
			var evt:Event;
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success" :
					connectStream ();
					startConnectEvent (false);
					evt = new Event(VideoStream.CONNECT);
					break;
				case "NetStream.Play.StreamNotFound" :
					trace ("Stream not found : " , _streamPath);
					evt = new Event(VideoStream.STREAMNOTFOUND);
					break;
				case "NetStream.Play.Start" :
					startProgressEvent (true);
					evt = new Event(VideoStream.STARTPLAYSTREAM);
					break;
				case "NetStream.Play.Stop" :
					startProgressEvent (false);
					evt = new Event(Event.COMPLETE);
					break;
			}
            
			if(evt)
			{
			   dispatchEvent (evt);
			}
		}

		private function onSecurityError (e:SecurityErrorEvent):void
		{
			trace ("securityErrorHandler: " + e);
			startConnectEvent (false);
			dispatchEvent (new Event(VideoStream.SECURITYERROR));
		}

		private function onFrameLoop (e:Event):void
		{
			dispatchEvent (new Event(Event.RENDER));
		}

		//--------------------------------------------

		public function closeVideoStream ():void
		{
			_ns.close ();
		}

		public function pauseVideo ():void
		{
			_ns.pause ();
		}

		public function resumeVideo ():void
		{
			_ns.resume ();
		}

		public function seekVideo (phead:Number):void
		{
			var pTime:int = Math.round(phead * 1000) / 1000;
			_ns.seek (pTime);
		}

		public function stopVideo ():void
		{
			_ns.seek (0);
			_ns.pause ();
		}

		public function get stream ():NetStream
		{
			return _ns;
		}

		public function get duration ():Number
		{
			return _duration;
		}

		public function get time ():Number
		{
			return _ns.time;
		}

		public function get streamBuffer ():Number
		{
			return _bufferTime;
		}

		public function set streamBuffer (value:Number):void
		{
			_bufferTime = value;
			_ns.bufferTime = _bufferTime;
		}

		public function dispose ():void
		{
			_ns.close ();
			_nc.close ();
			attachNetStream (null);
		}

		public function onMetaData (info:Object):void
		{
			_duration = info.duration;
		}

		public function onCuePoint (info:Object):void
		{
		}

		public function onImageData (info:Object):void
		{
		}

		public function onPlayStatus (info:Object):void
		{
		}

		public function onTextData (info:Object):void
		{
		}

		public function onXMPData (info:Object):void
		{
		}
	}


}