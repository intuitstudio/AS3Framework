package com.intuitStudio.motions.biDimens.shapes
{
	import flash.display.Sprite;
	import com.intuitStudio.motions.biDimens.core.Vector2D;
	
	public class Circle extends Sprite
	{
		private var _radius:Number;
		private var _color:uint;
		
		public function Circle(r:Number,c:uint=0x000000)
		{
			_radius= r;
			_color = c;
			draw();
		}
		
		protected function draw():void
		{
			graphics.clear();
			graphics.lineStyle(0,_color);
			graphics.drawCircle(0,0,_radius);
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set location(v2:Vector2D):void
		{
			x = v2.x;
			y = v2.y;
		}
		
		public function get location():Vector2D
		{
			return new Vector2D(x,y);
		}		

	}	
}