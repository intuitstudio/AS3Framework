package com.intuitStudio.animation.core
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.events.EventDispatcher;
	import flash.errors.IllegalOperationError;
	import com.intuitStudio.images.core.BitmapWrapper;

	public class GraphicsMovie extends EventDispatcher
	{
		protected var _holder:Sprite;
		protected var _bitmap:Bitmap;
		protected var _framesData:Vector.<BitmapData > ;
		protected var _framesXML:XML;
		protected var _imageData:BitmapWrapper;
		protected var _isPlaying:Boolean = false;
		protected var _isLoop:Boolean = true;
		protected var _fps:Number = 24;
		protected var _duration:Number = 0;
		protected var _delay:Number = 0;
		protected var _currentFrame:uint = 0;
		protected var _totalFrames:uint = 0;
		protected var _isReverse:Boolean = false;
		protected var _updateView:uint = 0;
		protected var _updateSize:uint = 0;

		protected var _location:Point = new Point  ;
		protected var _size:Point = new Point  ;
		protected var _valid:Boolean = false;

		public function GraphicsMovie (data:XML,loop:Boolean=true,reverse:Boolean=false,fps:Number=24)
		{
			_framesXML = data;
			_imageData = wrapper;
			_isLoop = loop;
			_isReverse = reverse;
			_fps = fps;
			init ();
		}

		protected function init ():void
		{
			_framesData = new Vector.<BitmapData >   ;
			_holder = new Sprite  ;
			_bitmap = new Bitmap  ;
			_holder.addChild (_bitmap);
			//
			_isReverse = false;
			_isPlaying = false;
			_location = new Point  ;
			_size = new Point  ;
			//
			_duration = 1 / _fps;
			_delay = 0;
			_updateView = 0;
			_updateSize = 0;
			_valid = false;
			//
			_totalFrames = parseFrames();
			_currentFrame = _isReverse ? _totalFrames - 1:0;
		}

		protected function parseFrames ():uint
		{
			throw new IllegalOperationError('parseFrames must be overridden by devired classes');
			return 0;
		}

		protected function makeFrames ():void
		{
			throw new IllegalOperationError('makeFrames must be overridden by devired classes');
		}

		public function start ():void
		{
			_isPlaying = true;
		}

		public function stop ():void
		{
			_isPlaying = false;
			_delay = 0;
		}

		public function next ():void
		{
			_delay = _duration;
			update ();
			render ();
		}

		public function previous ():void
		{
			_currentFrame = _isReverse ? _currentFrame + 2:_currentFrame - 2;
			_delay = _duration;
			update ();
			render ();
		}
		public function reverse ():void
		{
			_isReverse = true;
			_currentFrame = _totalFrames;
			_updateView++;
			render ();
		}

		public function dispose ():void
		{
			for each (var bitmapData:BitmapData in _framesData)
			{
				bitmapData.dispose ();
			}

			_framesData = null;
			_holder.removeChild (_bitmap);
			_bitmap = null;
			_holder = null;
		}

		public function get instance ():Sprite
		{
			return _holder;
		}

		public function set location (point:Point):void
		{
			_locaiton = point;
		}

		public function get location ():Point
		{
			return _location;
		}

		public function set x (value:Number):void
		{
			_locaiton.x = value;
			_updateView++;
		}

		public function get x ():Number
		{
			return _location.x;
		}

		public function set y (value:Number):void
		{
			_locaiton.y = value;
			_updateView++;
		}

		public function get y ():Number
		{
			return _location.y;
		}

		public function set width (value:Number):void
		{
			_size.x = value;
			_updateSize++;
		}

		public function get width ():Number
		{
			return _size.x;
		}

		public function set height (value:Number):void
		{
			_size.y = value;
			_updateSize++;
		}

		public function get height ():Number
		{
			return _size.y;
		}

		public function update (elapsed:Number=1.0):void
		{
			if (_isPlaying)
			{
				_delay++;

				if (_delay >= _duration)
				{
					if (! _isReverse)
					{
						_curretFrame++;
						if (_curretFrame >= _totalFrames)
						{
							if (_isLoop)
							{
								_curretFrame = 0;
							}
							else
							{
								_curretFrame = _totalFrames;
								stop ();
							}
						}
					}
					else
					{
						_curretFrame--;
						if (_curretFrame <= 0)
						{
							if (_isLoop)
							{
								_curretFrame = _totalFrames;
							}
							else
							{
								_curretFrame = 0;
								stop ();
							}
						}
					}

					_delay = 0;
					_updateView++;
				}
			}
		}

		public function rendering ():void
		{
			if (_updateView > 0)
			{
				_holder.x = x;
				_hodler.y = y;
				_bitmap.bitmapData = _framesData[_currentFrame];
				_updateView = 0;
			}

			if (_updateSize > 0)
			{
				_holder.width = width;
				_holder.height = height;
				_updateSize = 0;
			}
		}


	}

}