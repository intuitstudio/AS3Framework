package com.intuitStudio.flash3D.abstracts
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.events.Event;

	import com.intuitStudio.images.abstracts.AdvancedImage;
	import com.intuitStudio.images.abstracts.ImageComponent;
	import com.intuitStudio.utils.Vector3DUtils;


	public class TriDimensImage extends Sprite
	{
		protected var _image:ImageComponent;
		protected var _location:Vector3D;
		protected var _rotations:Vector3D;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _updateView:int = 0;
		protected var _updateSize:int = -1;

		public function TriDimensImage (image:ImageComponent)
		{
			transform.perspectiveProjection = new PerspectiveProjection();
			_image = image;
			_location = new Vector3D();
			_rotations = new Vector3D();
			init ();
		}

		protected function init ():void
		{
			if (_image.valid)
			{
				makeContent ();
			}
			else
			{
				_image.image.addEventListener (Event.RENDER,onRender);
			}

		}

		private function makeContent ():void
		{
			if (_updateSize == -1)
			{
				_width = AdvancedImage(_image).width;
				_height = AdvancedImage(_image).height;
				_updateSize = 1;
			}
			else
			{
				AdvancedImage(_image).width = width;
				AdvancedImage(_image).height = height;
				_updateSize = 1;
			}
		 
			bitmap.x =  -  width * .5;
			bitmap.y =  -  height * .5;
			addChild (bitmap);
			_updateView = 0;
			render();
		}

		public function onRender (e:Event):void
		{
			_image.image.removeEventListener (Event.RENDER,onRender);
			makeContent ();
		}

		public function get valid ():Boolean
		{
			return _image.valid;
		}

		public function get bitmap ():Bitmap
		{
			return _image.bitmap;
		}

		public function get bitmapData ():BitmapData
		{
			return _image.bitmapData;
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
			//AdvancedImage(_image).width = _width;
			_updateSize++;
		}

		override public function get width ():Number
		{
			return _width;
		}

		override public function set height (value:Number):void
		{
			_height = value;
			//AdvancedImage(_image).height = _height;
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
			if (! valid)
			{
				return;
			}

			if (_updateSize > 0)
			{
				bitmap.x =   -  bitmap.width * .5;
				bitmap.y =   -  bitmap.height * .5;
 
				_updateView++;
				_updateSize = 0;
			}

			if (_updateView > 0 && valid)
			{
				doRender ();
				_updateView = 0;
			}
		}

		protected function doRender ():void
		{
			_image.render ();
			super.x = x ;
			super.y = y ;
			super.z = z;
			super.scaleX = width/bitmap.width;
			super.scaleY = height/bitmap.height;
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

		public function decreaseView (offset:Number=2.0):void
		{
			setFieldOfView (pp.fieldOfView-offset);
		}

		private function setFieldOfView (value:Number):void
		{
			pp.fieldOfView = Math.max(.1,Math.min(value,179.9));
		}


	}
}