package com.intuitStudio.videos.core
{
	import flash.events.EventDispatcher;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.geom.Point;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.events.Event;

	import com.intuitStudio.videos.abstracts.VideoBox;
	import com.intuitStudio.videos.core.VideoStream;

	public class CameraWrapper extends EventDispatcher
	{
		protected var _camera:Camera;
		protected var _stream:VideoStream;
		protected var _frameRate:uint;
		protected var _location:Point;
		protected var _width:Number;
		protected var _height:Number;
		protected var _scale:Number;
		protected var _updateView:int = 0;

		public function CameraWrapper (w:Number,h:Number,frameRate:uint=15)
		{			
			_width = w;
			_height = h;			
			_frameRate = frameRate;
			init();
		}
		
		protected function init():void
		{
			_location = new Point();
			_camera = Camera.getCamera();
			if (_camera != null)
			{
				_camera.setMode (width,height,_frameRate);
				makeVideo ();
				_updateView++;
			}
		}

		private function makeVideo ():void
		{
			_stream = new VideoStream();
			_scale = Math.min(width/_stream.width,height/_stream.height);
			_stream.attachCamera (_camera);
			_stream.startProgressEvent (true);
			_stream.addEventListener (Event.RENDER,onVideoRender);
		}

		public function get video ():Video
		{
			return _stream;
		}

		public function set location (point:Point):void
		{
			_location = point;
			_updateView++;
		}

		public function get location ():Point
		{
			return _location;
		}

		public function set x (value:Number):void
		{
			_location.x = value;
			_updateView++;
		}

		public function get x ():Number
		{
			return _location.x;
		}

		public function set y (value:Number):void
		{
			_location.y = value;
			_updateView++;
		}

		public function get y ():Number
		{
			return _location.y;
		}

		public function set width (value:Number):void
		{
			_width = value;
			_updateView++;
		}

		public function get width ():Number
		{
			return _width;
		}

		public function set height (value:Number):void
		{
			_height = value;
			_updateView++;
		}

		public function get height ():Number
		{
			return _height;
		}
		
		public function set frameRate(value:uint):void
		{
			_frameRate = value;
			_camera.setMode(width,height,value);
		}
		
		public function get scale():Number
		{
			return _scale;
		}

		public function render ():void
		{
			if (_updateView > 0)
			{
				video.scaleX = -scale;
				video.scaleY = scale;
				video.x = x + width;
				video.y = y;
				
				_updateView = 0;
			}

		}

		private function onVideoRender (e:Event):void
		{
			dispatchEvent (e);
		}
	}

}