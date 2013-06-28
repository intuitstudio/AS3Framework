package com.intuitStudio.triMotion.core
{
	/**
	 * Perspective Class
	 * @author vanier peng,2013.4.20
	 * 定義Flash 3d的透視屬性抽象物件 , 儲存資料:
	 *  focalLength - 焦距 
	 *  vanishingPoint - 透視點
	 *  fieldOfView - 視角
	 *  center - 中心點
	 *  floor - 地面高度
	 */
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
		
		public function get projection():PerspectiveProjection
		{
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.focalLength = fl;
			pp.fieldOfView = scope;
			pp.projectionCenter = vanishingPoint;
			return pp;
		}
         
		public function clone():Perspective
		{
			var copy:Perspective = new Perspective();
			copy._perspective = this._perspective;
			return copy;
		}
		 
		private function makeProjection (pp:PerspectiveProjection):void
		{
			defaultProjection();
			if (pp)
			{
				_perspective['focalLength'] = pp.focalLength;
				_perspective['vanishingPoint'] = pp.projectionCenter;
				_perspective['fieldOfView'] = pp.fieldOfView;
			}
		}

		private function defaultProjection ():void
		{
			_perspective['focalLength'] = 250;
			_perspective['vanishingPoint'] = new Point();
			_perspective['fieldOfView'] = 350;
			_perspective['center'] = new Vector3D();
		}

		public function set center (point:Vector3D):void
		{
           _perspective.center = point;		   
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

		public function set vanishingPoint (point:Point):void
		{
           _perspective.vanishingPoint = point;
		}

		public function get vanishingPoint ():Point
		{
           return _perspective.vanishingPoint;
		}

		public function set fl (value:Number):void
		{
           _perspective.focalLength = value;
		}

		public function get fl ():Number
		{
           return _perspective.focalLength;
		}

		public function set scope (value:Number):void
		{
           _perspective.fieldOfView = value;
		}

		public function get scope ():Number
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