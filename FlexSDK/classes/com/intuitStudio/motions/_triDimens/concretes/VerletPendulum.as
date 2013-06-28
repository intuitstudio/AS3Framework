package com.intuitStudio.motions.triDimens.concretes
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import com.intuitStudio.motions.triDimens.core.VerletPoint3D;
	import com.intuitStudio.motions.triDimens.concretes.VerletStick;
	import com.intuitStudio.motions.triDimens.concretes.VerletTriangle;
	import com.intuitStudio.motions.triDimens.concretes.VerletSquare;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;

	public class VerletPendulum
	{
		protected var _points:Vector.<VerletPoint3D > ;
		protected var _sticks:Vector.<VerletStick > ;
		protected var _triangles:Vector.<VerletTriangle > ;
		protected var _squares:Vector.<VerletSquare > ;
		private var _base:VerletTriangle;
		private var _arm:VerletStick;
		private var _weights:VerletSquare;

		public function VerletPendulum (triangle:VerletTriangle,stick:VerletStick,square:VerletSquare)
		{
			_points = new Vector.<VerletPoint3D > ();
			_sticks = new Vector.<VerletStick>();
			_triangles = new Vector.<VerletTriangle >();
			_squares = new Vector.<VerletSquare>();

			makeBase (triangle);
			makeScalesArm (stick);
			makeWeights (square);

		}
		//a big triangle
		private function makeBase (triangle:VerletTriangle):void
		{
			_points = triangle.points;
			_sticks = _sticks.concat(triangle.sticks);
			_triangles.push (triangle);
			_base = triangle;

		}
		//a stick 
		private function makeScalesArm (stick:VerletStick):void
		{
			_points = _points.concat(stick.points);
			_sticks.push (stick);
			_arm = stick;

		}
		//a square
		private function makeWeights (square:VerletSquare):void
		{
			_points = _points.concat(square.points);
			_sticks = _sticks.concat(square.sticks);
			_triangles = _triangles.concat(square.triangles);
			_squares.push (square);

			_weights = square;
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

		public function get squares ():Vector.<VerletSquare > 
		{
			return _squares;
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
				_base.update (elapsed);
				_arm.update (elapsed);
				_weights.update (elapsed);
				count++;
			}

		}

		public function render (g:Graphics):void
		{
			_base.render (g);
			_arm.render (g);
			_weights.render (g);
		}

	}

}