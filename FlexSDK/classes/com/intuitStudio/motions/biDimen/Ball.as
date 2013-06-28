package com.intuitStudio.motions.biDimen
{
	/**
	 * Class Ball
	 * @author vanier peng
	 * Purpose : Draw a Circle shape with basic motion behavoirs.
	 *
	 */
	
	import com.intuitStudio.motions.biDimen.core.MoveEntity;
	import com.intuitStudio.motions.biDimen.core.Vector2D;
	import flash.display.DisplayObject;
	import flash.display.Graphics;	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	public class Ball extends MoveEntity
	{
		private var _color:uint;
		private var _radius:Number;
		private var _oldLocation:Vector2D = new Vector2D();
		
		public function Ball(rad:Number = 30, col:uint = 0xFF0000)
		{
			super(0, 0, rad * 2, rad * 2);
			_radius = rad;
			_color = col;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set oldLocation(v2:Vector2D):void
		{
			_oldLocation = v2.clone();
		}
		
		public function get oldLocation():Vector2D {
			return _oldLocation;
		}
		
		public function trackVelocity():void
		{
			velocity.x = x - oldLocation.x;
			velocity.y = y - oldLocation.y;
			
			oldLocation.x = x;
			oldLocation.y = y;
		}		
		
		public function getBounds():Rectangle
		{
			return new Rectangle(x, y, width, height);
		}
		
		override protected function doDraw(context:DisplayObject):void
		{
			var graphic:Graphics = getGraphic(context);
			if (graphic)
			{
				with (graphic)
				{
					clear();
					beginFill(color);
					drawCircle(0, 0, radius);
					endFill();
				}
			}
		}
		
		public function move(elapsed:Number = 1.0):void
		{
			update(elapsed);
		}
		
		public function moveEasing(point:Point, elapsed:Number = 1.0):void
		{
			applyEasing(point);
			update(elapsed);
		}
		
		public function moveSpring(point:Point, elapsed:Number = 1.0):void
		{
			applySpring(point);
			update(elapsed);
		}
		
		public function moveOffsetSpring(point:Point, elapsed:Number = 1.0):void
		{
			applyOffsetSpring(point);
			update(elapsed);
		}
	
		public function springTo(point:Point):void
		{
			moveOffsetSpring(point);
		}
		
		
		
		override public function rendering():void
		{
			if (content)
			{
				content.width = width;
				content.height = height;
			}
			super.rendering();
		}
		
	}

}