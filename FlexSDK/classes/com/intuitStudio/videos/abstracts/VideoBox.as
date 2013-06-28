package com.intuitStudio.videos.abstracts
{
	import flash.media.Video;
	import flash.geom.Point;	

	import com.intuitStudio.videos.core.VideoWrapper;

	public class VideoBox
	{
		protected var _stream:VideoWrapper;
		protected var _scale:Number = 1.0;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _location:Point;
		protected var _updateView:int = 0;

		public function VideoBox (stream:VideoWrapper,scale:Number=1.0)
		{
			_stream = stream;
			_scale = scale;
			init ();
		}

		protected function init ():void
		{
			_location = new Point();
			_updateView = 0;
		}

		public function set width (value:Number):void
		{
			_stream.width = value;
			_updateView++;
		}

		public function get width ():Number
		{
			return _stream.width;
		}

		public function set height (value:Number):void
		{
			_stream.height = value;
			_updateView++;
		}

		public function get height ():Number
		{
			return _stream.height;
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

		public function get video ():Video
		{
			return _stream.vidoe;
		}

        public function flipHorizontal():void
		{
			
		}

		public function render ():void
		{
			if (_updateView > 0)
			{
				video.x = x-video.width*.5;
				video.y = y-video.height*.5;
				_updateView = 0;
			}
		}

	}

}