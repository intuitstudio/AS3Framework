package com.intuitStudio.flash3D.abstracts
{
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.geom.PerspectiveProjection;
	import flash.errors.IllegalOperationError;

	public class TriDimensContainer extends Sprite
	{
		protected var _location:Vector3D;
		protected var _rotations:Vector3D;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _updateSize:int = 0;
		protected var _updateView:int = 0;
		protected var _container:DisplayObjectContainer;

		public function TriDimensContainer (container:DisplayObjectContainer,vanishingPoint:Point=null)
		{
			transform.perspectiveProjection = new PerspectiveProjection();
			_container = container;
			if(vanishingPoint!=null)
			{
				setVanishingPoint(vanishingPoint);
			}
			_location = new Vector3D();
			_rotations = new Vector3D();			
			//
			init();
		}
		
		protected function init():void
		{
			throw new IllegalOperationError('init must be overridden by derivated classes');
		}

		public function set location (loc:Vector3D):void
		{
			_location = loc.clone();
		}

		public function get location ():Vector3D
		{
			return _location;
		}

		override public function set x (value:Number):void
		{
			_location.x = value;
			_updateView++;
		}

		override public function get x ():Number
		{
			return _location.x;
		}

		override public function set y (value:Number):void
		{
			_location.y = value;
			_updateView++;
		}

		override public function get y ():Number
		{
			return _location.y;
		}

		override public function set z (value:Number):void
		{
			_location.z = value;
			_updateView++;
		}

		override public function get z ():Number
		{
			return _location.z;
		}

		public function set rotations (rotates:Vector3D):void
		{
			_rotations = rotates.clone();
		}

		public function get rotations ():Vector3D
		{
			return _rotations;
		}

		override public function set rotationX (value:Number):void
		{
			_rotations.x = value;
			_updateView++;
		}

		override public function get rotationX ():Number
		{
			return _rotations.x;
		}

		override public function set rotationY (value:Number):void
		{
			_rotations.y = value;
			_updateView++;
		}

		override public function get rotationY ():Number
		{
			return _rotations.y;
		}

		override public function set rotationZ (value:Number):void
		{
			_rotations.z = value;
			_updateView++;
		}

		override public function get rotationZ ():Number
		{
			return _rotations.z;
		}
		override public function set width (value:Number):void
		{
			_width = value;
			_updateSize++;
		}

		override public function get width ():Number
		{
			return _width;
		}

		override public function set height (value:Number):void
		{
			_height = value;
			_updateSize++;
		}

		override public function get height ():Number
		{
			return _height;
		}

		public function update (elapsed:Number=1.0):void
		{

		}

		public function render ():void
		{
			if (_updateSize > 0)
			{
				_updateView++;
				_updateSize = 0;
			}

			if (_updateView > 0 )
			{
				doRender ();
				_updateView = 0;
			}
		}

		protected function doRender ():void
		{
			//_container.x = x;
			//_container.y = y;
			//_container.z = z;
			//_container.rotationX = rotationX;
			//_container.rotationY = rotationY;
			//_container.rotationZ = rotationZ;
			super.x = x ;
			super.y = y ;
			super.z = z;
			super.width = _width;
			super.height = _height;
			super.rotationX = rotationX;
			super.rotationY = rotationY;
			super.rotationZ = rotationZ;
		}

		public function get pp ():PerspectiveProjection
		{
			return transform.perspectiveProjection;
		}

		public function setVanishingPoint (point:Point):void
		{
			pp.projectionCenter = point;
		}

		public function incrementView (offset:Number=2.0):void
		{
			setFieldOfView (pp.fieldOfView+offset);
		}

		public function decrementView (offset:Number=2.0):void
		{
			setFieldOfView (pp.fieldOfView-offset);
		}

		private function setFieldOfView (value:Number):void
		{
			pp.fieldOfView = Math.max(.1,Math.min(value,179.9));
		}

	}

}