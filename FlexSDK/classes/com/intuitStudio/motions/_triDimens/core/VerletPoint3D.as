package com.intuitStudio.motions.triDimens.core
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;

	public class VerletPoint3D
	{
		public static var PixelsPerFoot:Number = 30;
		protected var _location:Vector3D;
		protected var _oldLocation:Vector3D;
		private var bounce:Number = -.6;
		public var boundary:Dictionary;

		public function VerletPoint3D (x:Number=0,y:Number=0,z:Number=0)
		{
			setPosition (x,y,z);
			init ();
		}

		protected function init ():void
		{
			setBoundary (0,100,0,100);
		}

		public function setBoundary (top:Number,bottom:Number,left:Number,right:Number,fore:Number=1000,back:Number=-250):void
		{
			if (boundary == null)
			{
				boundary =  new Dictionary();
			}

			boundary.top = top;
			boundary.bottom = bottom;
			boundary.left = left;
			boundary.right = right;
			boundary.fore = fore;
			boundary.back = back;
		}

		public function update (elapsed:Number=1.0):void
		{
			var tempLoc:Vector3D = _location.clone();
			_location = _location.add(Vector3DUtils.expandTo(velocity,elapsed));
			_oldLocation = tempLoc;
		}

		public function render (g:Graphics):void
		{
			var pos:Vector3D = _location.clone();
			pos = Vector3DUtils.expandTo(pos,PixelsPerFoot);

			var radius:Number = 4;
			g.beginFill (0);
			g.drawCircle (pos.x, pos.y, radius);
			g.endFill ();

			//draw 3D Sphere object


		}

		public function setPosition (x,y,z):void
		{
			_location = new Vector3D(x,y,z);
			_oldLocation = _location.clone();
		}

		public function constrain ():void
		{
			x = Math.max(boundary.left, Math.min(boundary.right,x));
			y = Math.max(boundary.top, Math.min(boundary.bottom,y));
			z = Math.max(boundary.back, Math.min(boundary.fore,z));
			//trace ('constrain ' ,x, y);
			return;
			if (x > boundary.right)
			{
				x = boundary.right;
				vx *=  bounce;
			}
			if (x < boundary.left)
			{
				x = boundary.left;
				vx *=  bounce;
			}
			if (y > boundary.bottom)
			{
				y = boundary.bottom;
				vy *=  bounce;
				
			}
			if (y < boundary.top)
			{
				y = boundary.top;
				vy *=  bounce;
			}
			if (z > boundary.fore)
			{
				z = boundary.fore;
				vz *=  bounce;
			}
			if (z < boundary.back)
			{
				z = boundary.back;
				vz *=  bounce;
			}
		}

		public function set location (value:Vector3D):void
		{
			_location = value;
		}

		public function get location ():Vector3D
		{
			return _location;
		}

		public function set oldLocation (value:Vector3D):void
		{
			_oldLocation = value;
		}

		public function get oldLocation ():Vector3D
		{
			return _oldLocation;
		}

		public function set velocity (vel:Vector3D):void
		{
			_oldLocation = _location.subtract(vel);
		}

		public function get velocity ():Vector3D
		{
			return _location.subtract(_oldLocation);
		}

		public function set x (value:Number):void
		{
			location.x = value;
		}

		public function get x ():Number
		{
			return location.x;
		}

		public function set y (value:Number):void
		{
			location.y = value;
		}

		public function get y ():Number
		{
			return location.y;
		}

		public function set z (value:Number):void
		{
			location.z = value;
		}

		public function get z ():Number
		{
			return location.z;
		}

		public function set vx (value:Number):void
		{
			_oldLocation.x = x - value;
		}

		public function get vx ():Number
		{
			return x-_oldLocation.x;
		}

		public function set vy (value:Number):void
		{
			_oldLocation.y = y - value;
		}

		public function get vy ():Number
		{
			return y-_oldLocation.y;
		}

		public function set vz (value:Number):void
		{
			_oldLocation.z = z - value;
		}

		public function get vz ():Number
		{
			return z-_oldLocation.z;
		}

	}

}