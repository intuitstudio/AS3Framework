package com.intuitStudio.motions.triDimens.concretes
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import com.intuitStudio.motions.triDimens.core.VerletPoint3D;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;

	public class VerletStick 
	{
		private var _length:Number;
		protected var _points:Vector.<VerletPoint3D>;
		
		public function VerletStick(pointA:VerletPoint3D,pointB:VerletPoint3D,len:Number=-1)
		{
			_points = Vector.<VerletPoint3D>(new Array(pointA,pointB));			
			length = (len>0)?len:Vector3D.distance(pointA.location,pointB.location);
		}
				
	    public function get points():Vector.<VerletPoint3D>
		{
			return _points;
		}
		
		public function set length(value:Number):void
		{
			_length = value;
		}
		
		public function get length():Number
		{
			return _length;
		}
		
		public function update(elapsed:Number = 1.0):void
		{
		
			var dist:Number = Vector3D.distance(points[0].location,points[1].location);
			var diffV3:Vector3D = points[1].location.subtract(points[0].location);			
			var offsetV3:Vector3D = Vector3DUtils.expandTo(diffV3,(length-dist)/dist*.5);
			points[0].location = points[0].location.subtract(offsetV3);
			points[1].location = points[1].location.add(offsetV3);			
			
			var loop:int = 1;
			var count:int = 0;
			while (count<loop)
			{
				for each (var point:VerletPoint3D in points)
				{
					point.constrain ();
				}
				count++;
			}
			
		}
		
		public function render(g:Graphics):void		
		{
			var locA:Vector2D = new Vector2D(points[0].x,points[0].y).multiply(VerletPoint3D.PixelsPerFoot);
			var locB:Vector2D = new Vector2D(points[1].x,points[1].y).multiply(VerletPoint3D.PixelsPerFoot);

			g.lineStyle(0);
			g.moveTo(locA.x,locA.y);
			g.lineTo(locB.x,locB.y);
			
			points[0].render(g);
			points[1].render(g);
		}
		
		
	}	
	
}