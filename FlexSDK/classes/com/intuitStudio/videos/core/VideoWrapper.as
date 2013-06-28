package com.intuitStudio.videos.core
{
	import flash.media.Video;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.videos.core.VideoStream;

	public class VideoWrapper extends EventDispatcher
	{
		protected var _video:Video;
		protected var _streamPath:String;
		protected var _width:Number;
		protected var _height:Number;
		protected var _valid:Boolean;

		public function VideoWrapper (path:String=null,w:Number=320,h:Number=240)
		{
			_streamPath = path;
			_width = w;
			_height = h;
			init ();
		}

		protected function init ():void
		{
			_valid = false;
			_video = new VideoStream();
			_video.width = width;
			_video.height = height;
			addListeners ();
			if(_streamPath!=null)
			{
			    VideoStream(_video).makeVideo (_streamPath);
			}
		}

		private function addListeners ():void
		{
			_video.addEventListener (VideoStream.COMPLETE,onComplete);
			_video.addEventListener (VideoStream.STREAMPLAY,onSuccess);
			_video.addEventListener (VideoStream.STARTPLAYSTREAM,onPlayStream,false,0,true);
			_video.addEventListener (VideoStream.STOP,onStopStream,false,0,true);
			_video.addEventListener (VideoStream.STREAMNOTFOUND,IOErrorHandler,false,0,true);
			_video.addEventListener (VideoStream.ASYNCERROR,IOErrorHandler,false,0,true);
		}

        private function onComplete(e:Event):void
		{
			//dispatchEvent(e);
		}

		private function onSuccess (e:Event):void
		{
			_valid = true;
		}

		private function IOErrorHandler (e:Event):void
		{
			trace ('Security Error occur!',e.type);
		}

        private function onPlayStream(e:Event):void
		{
			dispatchEvent(e);
		}
		
        private function onStopStream(e:Event):void
		{
			
		}
        //------------------------------------------
		
		public function get vidoe ():Video
		{
			return _video;
		}

		public function get valid ():Boolean
		{
			return _valid;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
			var scale:Number = _video.width/value;
			_video.scaleX = _video.scaleY = scale;
			_height *= scale;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
			var scale:Number = _video.height/value;
			_video.scaleX = _video.scaleY = scale;
			_width *= scale;
		}
		
		public function get height():Number
		{
			return _height;
		}

	}
}