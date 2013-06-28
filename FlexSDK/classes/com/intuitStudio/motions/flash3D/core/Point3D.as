/*
  class Point3D is a virtual 3D space virtual point information , including loaction,
  focal-length, vanishingPoint...,and it is based on flash 3D system.
*/

package com.intuitStudio.motions.flash3D.core
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.errors.IllegalOperationError;
	
	import com.intuitStudio.motions.flash3D.core.Perspective;

	public class Point3D
	{
		protected var _location:Vector3D;
		protected var _perspective:Perspective;
		// for render
		protected var _updateView:int = 0;

		public function Point3D (x:Number=0,y:Number=0,z:Number=0,w:Number=0)
		{
			init ();
		}

		protected function init ():void
		{
			_location = new Vector3D();
			_perspective = new Perspective();
			_updateView = 1;
			//draw ();
		}

		public function perspective (pp:Perspective):void
		{
			_perspective = pp;
		}

		public function set fl (value:Number):void
		{
			_perspective.focalLength = value;
		}

		public function get fl ():Number
		{
			return _perspective.focalLength;
		}

		public function set fieldOfView (value:Number):void
		{
			_perspective.fieldOfView = value; 
		}

		public function get fieldOfView ():Number
		{
			return _perspective.fieldOfView;
		}
		
		public function set projectionCenter (point:Point):void
		{
			_perspective.projectCenter = point;
		}

		public function get projectionCenter ():Point
		{
			return _perspective.projectCenter;
		}

		public function set location (point:Vector3D):void
		{
			_location = point;
			_updateView++;
		}

		public function get location ():Vector3D
		{
			return _location;
		}
		
		public function set center (point:Vector3D):void
		{
			_perspective.center = point;
			_updateView++;
		}

		public function get center ():Vector3D
		{
			return _perspective.center;
		}

		public function set x (value:Number):void
		{
			location.x = value;
			_updateView++;
		}

		public function get x ():Number
		{
			return location.x;
		}

		public function set y (value:Number):void
		{
			location.y = value;
			_updateView++;
		}

		public function get y ():Number
		{
			return location.y;
		}

		public function set z (value:Number):void
		{
			location.z = value;
			_updateView++;
		}

		public function get z ():Number
		{
			return location.z;
		}

		public function set w (value:Number):void
		{
			location.w = value;
			_updateView++;
		}

		public function get w ():Number
		{
			return location.w;
		}

		public function render ():void
		{

		}

		
		public function draw ():void
		{
			 trace('call draw by Point3D');
             doDraw();
		}
		//override by sub class 
		protected function doDraw():void
		{

		}

		// drsw point in demonstate 
		public function drawPoint (g:Graphics):void
		{
			g.clear ();
			g.beginFill (0x999999);
			g.drawCircle (0,0,20);
			g.endFill ();
		}
		

	}

}