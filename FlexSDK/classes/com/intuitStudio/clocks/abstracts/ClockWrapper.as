package com.intuitStudio.clocks.abstracts
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	import com.intuitStudio.clocks.core.ClockData;
	import com.intuitStudio.clocks.core.ClockController;
	import com.intuitStudio.clocks.core.ClockView;
	import flash.errors.IllegalOperationError;

	public class ClockWrapper extends EventDispatcher
	{
		protected var _model:ClockData;
		protected var _controller:ClockController;
		protected var _view:ClockView;
		//
		protected var _size:Number = 0;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _location:Point=new Point();
		protected var _updateView:uint = 0;
		protected var _scale:Number = 1.0;

		public function ClockWrapper ()
		{
           _model = new ClockData();
		   _controller =  makeController(_model);
		   _view = makeView(_model,_controller);
		}
      
	    public function makeController(data:ClockData):ClockController
		{
			return new ClockController(data);
		}
		
		public function makeView(data:ClockData,controller:ClockController):ClockView
		{
			throw new IllegalOperationError('makeView must be overridden.');
			return null;
		}
		
		public function start ():void
		{
             _model.realTime = true;
		}

		public function stop ():void
		{
            _model.realTime = false;
		}

		public function reset ():void
		{

		}

		public function modify (hh:Number,mm:Number,ss:Number):void
		{

		}
		
		public function get view():ClockView
		{
			return _view;
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

		public function set scale (value:Number):void
		{
			_scale = value;
			_updateView++;
		}

		public function get scale ():Number
		{
			return _scale;
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

		public function update (elapsed:Number = 1.0):void
		{

		}

		public function render ():void
		{
			if (_updateView > 0)
			{
                view.x = x;
				view.y = y;
				_updateView = 0;
			}
		}

	}

}