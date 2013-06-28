package com.intuitStudio.motions.triDimens.concretes
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import com.intuitStudio.motions.triDimens.core.VerletPoint3D;
	import com.intuitStudio.motions.triDimens.concretes.VerletStick;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;

	public class VerletTriangle
	{
		protected var _points:Vector.<VerletPoint3D > ;
		protected var _sticks:Vector.<VerletStick > ;

		public function VerletTriangle (pointA:VerletPoint3D,pointB:VerletPoint3D,pointC:VerletPoint3D)
		{
			_points = Vector.<VerletPoint3D > (new Array(pointA,pointB,pointC));
			_sticks = new Vector.<VerletStick > ();
			makeStick (pointA,pointB);
			makeStick (pointB,pointC);
			makeStick (pointC,pointA);
		}

		private function makeStick (pointA:VerletPoint3D,pointB:VerletPoint3D):void
		{
			var stick:VerletStick = new VerletStick(pointA,pointB);
			_sticks.push (stick);
		}

		public function get points ():Vector.<VerletPoint3D > 
		{
			return _points;
		}

		public function get sticks ():Vector.<VerletStick > 
		{
			return _sticks;
		}

		public function update (elapsed:Number = 1.0):void
		{
			for each (var point:VerletPoint3D in points)
			{
				point.update (elapsed);
			}

			var loop:int = 5;
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
		}

	}

}