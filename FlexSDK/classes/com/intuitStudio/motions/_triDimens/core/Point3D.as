package com.intuitStudio.motions.triDimens.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import com.intuitStudio.motions.biDimens.core.Vector2D;

	public class Point3D extends Sprite
	{
		public static var pixelsPerFoot:Number = 1;
        protected var fl:Number = 250;
		protected var vp:Point;
		protected var _screenXY:Point;
		protected var _center:Vector3D;
		protected var _location:Vector3D;
		public var boundary:Dictionary;
		
		public function Point3D (x:Number=0,y:Number=0,z:Number=0)
		{			
			location = new Vector3D(x,y,z);
			init();
		}
		
		protected function init()
		{
			vp = new Point();
			_screenXY = new Point();
			center = new Vector3D();
			//define boundary
			boundary =  new Dictionary();			
			boundary['top'] = 0;
			boundary['bottom'] = 1000;
			boundary['left'] = 0;
			boundary['right'] = 1000;
			boundary['fore'] = 1000;
			boundary['back'] = -250;
		}
		
		public function set center(value:Vector3D):void
		{
			_center =  value;
		}
		
		public function get center():Vector3D
		{
			return _center;
		}

		public function set location(value:Vector3D):void
		{
			_location =  value;
		}
		
		public function get location():Vector3D
		{
			return _location;
		}
		
		override public function set x(value:Number):void
		{
			location.x = value;			
		}
		
		override public function get x():Number
		{
			return location.x;
		}
		
		override public function set y(value:Number):void
		{
			location.y = value;			
		}
		
		override public function get y():Number
		{
			return location.y;
		}
		
		override public function set z(value:Number):void
		{
			location.z = value;
		}
		
		override public function get z():Number
		{
			return location.z;
		}
		
		public function set screenXY(value:Point):void
		{
			_screenXY = value;
		}
		
		public function get screenXY():Point
		{
			return _screenXY;
		}
		
		public function set focalLength(value:Number):void
		{
			fl = value;
			render();
		}
		
		public function get focalLength():Number
		{
			return fl;
		}												 
		
		public function set vanishingPoint(vpt:Point):void
		{
			vp = vpt;
		}
		
		public function get vanishingPoint():Point
		{
			return vp;
		}

        public function render():void
		{
			perspective2D(fl,vp);		
		}

		public function perspective2D (fl:Number,vp:Point,transparent:Boolean=false):void
		{
			if (z >  -  fl-center.z)
			{
				var scale:Number = fl/(fl+z+center.z);
				
				scaleX = scaleY = scale;
				screenXY.x = vp.x + x * scale;
				screenXY.y = vp.y + y * scale;
				if (transparent)
				{
					alpha = scale * .7 + .3;
				}
				visible = true;
			}
			else
			{
				visible = false;
			}
			//
			var loc:Vector2D = Vector2D.pointToVector(screenXY);
			loc.multiply(pixelsPerFoot);			
			super.x = loc.x;
			super.y = loc.y;			
			trace('render ' , loc.toString());
		}

        public function get screenX():Number
		{
			var scale:Number = fl/(fl+z+center.z);
			var xpos:Number = (vp.x + (center.x+x)*scale )* pixelsPerFoot;
			return xpos;
		}

        public function get screenY():Number
		{
			var scale:Number = fl/(fl+location.z+center.z);
			var ypos:Number = (vp.y + (center.y+y)*scale)* pixelsPerFoot;
			return ypos;
		}
		
		public function getSpaceX(x:Number):Number
		{
			var scale:Number = fl/(fl+location.z+center.z);
			return ((x-vp.x)/scale) - center.x;
		}
		
		public function getSpaceY(y:Number):Number
		{
			var scale:Number = fl/(fl+location.z+center.z);
			return ((y-vp.y)/scale) - center.y;
		}
		
		public function rotateX(angleX:Number):void
		{
			var cosX:Number = Math.cos(angleX);
			var sinX:Number = Math.sin(angleX);
			var y1:Number = cosX*location.y-sinX*location.z;
			var z1:Number = cosX*location.z+sinX*location.y;
			location.y = y1;
			location.z = z1;
		}

		public function rotateY(angleY:Number):void
		{
			var cosY:Number = Math.cos(angleY);
			var sinY:Number = Math.sin(angleY);
			var x1:Number = cosY*location.x-sinY*location.z;
			var z1:Number = cosY*location.z+sinY*location.x;
			location.x = x1;
			location.z = z1;
		}
		
		public function rotateZ(angleZ:Number):void
		{
			var cosZ:Number = Math.cos(angleZ);
			var sinZ:Number = Math.sin(angleZ);
			var x1:Number = cosZ*location.x-sinZ*location.y;
			var y1:Number = cosZ*location.y+sinZ*location.z;
			location.x = x1;
			location.y = y1;
		}
		
		public function setBoundary(top:Number,bottom:Number,left:Number,right:Number,fore:Number=1000,back:Number=-250):void
		{
			boundary.top = top;
			boundary.bottom = bottom;
			boundary.left = left;
			boundary.right = right;
			boundary.fore = fore;
			boundary.back = back;
		}
	}
}