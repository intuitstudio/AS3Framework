package com.intuitStudio.motions.triDimens.concretes
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import com.intuitStudio.motions.triDimens.core.VerletPoint3D;
	import com.intuitStudio.motions.triDimens.concretes.VerletStick;
	import com.intuitStudio.motions.triDimens.concretes.VerletTriangle;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;

	public class VerletSquare
	{
		protected var _points:Vector.<VerletPoint3D > ;
		protected var _sticks:Vector.<VerletStick > ;
		protected var _triangles:Vector.<VerletTriangle > ;
		

		public function VerletSquare (triangleA:VerletTriangle,triangleB:VerletTriangle)
		{
			_points = new Vector.<VerletPoint3D > (6,true);
			_sticks = new Vector.<VerletStick>(6,true);
			_triangles = Vector.<VerletTriangle > (new Array(triangleA,triangleB));
			makeSquare (triangleA,triangleB);
		}

		//use two trianges to makeup a square, the points of triangles must be in clockwise order
		private function makeSquare (triangleA:VerletTriangle,triangleB:VerletTriangle):void
		{
			_points = triangleA.points;
			_points = _points.concat(Vector.<VerletPoint3D > (new Array(triangleB.points[1])));
			//
			_sticks = triangleA.sticks;
			_sticks = _sticks.concat(Vector.<VerletStick > (new Array(triangleB.sticks[0],triangleB.sticks[1])));
		}

		public function get points ():Vector.<VerletPoint3D > 
		{
			return _points;
		}

		public function get sticks ():Vector.<VerletStick > 
		{
			return _sticks;
		}

		public function get triangles ():Vector.<VerletTriangle > 
		{
			return _triangles;
		}

		public function update (elapsed:Number = 1.0):void
		{
			for each (var point:VerletPoint3D in points)
			{
				point.update (elapsed);
			}

			var loop:int = 1;
			var count:int = 0;
			while (count<loop)
			{
				for each (point in points)
				{
					point.constrain ();
				}
				for each (var stick:VerletStick in sticks)
				{
					stick.update (elapsed);
				}
				triangles[0].update (elapsed);
				triangles[1].update (elapsed);
				count++;
			}
		}

		public function render (g:Graphics):void
		{
			
			for each (var point:VerletPoint3D in points)
			{
				point.render (g);
			}
			for each (var stick:VerletStick in sticks)
			{
				stick.render (g);
			}
			
			triangles[0].render (g);
			triangles[1].render (g);
		}

	}

}