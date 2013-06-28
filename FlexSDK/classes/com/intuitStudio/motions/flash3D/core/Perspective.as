package com.intuitStudio.motions.flash3D.core
{
	import flash.utils.Dictionary;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.geom.PerspectiveProjection;

	public class Perspective
	{
		private var _perspective:Dictionary = new Dictionary();

		public function Perspective (pp:PerspectiveProjection=null)
		{
			_perspective = new Dictionary();
			makeProjection (pp);
		}
         
		public function clone():Perspective
		{
			var copy:Perspective = new Perspective();
			copy._perspective = this._perspective;
			return copy;
		}
		 
		private function makeProjection (pp:PerspectiveProjection):void
		{
			if (pp)
			{
				_perspective['fl'] = pp.focalLength;
				_perspective['vanisingPoint'] = pp.projectionCenter;
				_perspective['fieldOfView'] = pp.fieldOfView;
				_perspective['center'] = new Vector3D();
				_perspective['floor'] = 0;
			}
			else
			{
				defaultProjection ();
			}
		}

		private function defaultProjection ():void
		{
			_perspective['fl'] = 250;
			_perspective['vanisingPoint'] = new Point();
			_perspective['fieldOfView'] = 350;
			_perspective['center'] = new Vector3D();
		}

		public function set center (loc:Vector3D):void
		{
           _perspective.center = loc;
		}

		public function get center ():Vector3D
		{
           return _perspective.center;
		}

		public function set centerX (value:Number):void
		{
           _perspective.center.x = value;
		}

		public function get centerX ():Number
		{
           return _perspective.center.x;
		}

		public function set centerY (value:Number):void
		{
           _perspective.center.y = value;
		}

		public function get centerY ():Number
		{
           return _perspective.center.y;
		}

		public function set centerZ (value:Number):void
		{
           _perspective.center.z = value;
		}

		public function get centerZ ():Number
		{
           return _perspective.center.z;
		}

		public function set projectCenter (point:Point):void
		{
           _perspective.vanisingPoint = point;
		}

		public function get projectCenter ():Point
		{
           return _perspective.vanisingPoint;
		}

		public function set focalLength (value:Number):void
		{
           _perspective.fl = value;
		}

		public function get focalLength ():Number
		{
           return _perspective.fl;
		}

		public function set fieldOfView (value:Number):void
		{
           _perspective.fieldOfView = value;
		}

		public function get fieldOfView ():Number
		{
           return _perspective.fieldOfView;
		}

		public function set vision (value:Number):void
		{
           _perspective.fieldOfView = value;
		}

		public function get vison ():Number
		{
           return _perspective.fieldOfView;
		}
		
		public function set floor (value:Number):void
		{
           _perspective.floor = value;
		}

		public function get floor ():Number
		{
           return _perspective.floor;
		}

	}

}