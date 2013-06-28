package com.intuitStudio.motions.biDimen.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	/**
	 * Clas Spot2D
	 * @author vanier peng
	 * 2013.03.02
	 * Purpose : Basic particle which occupy position in two dimension world
	 */
	
	public class Spot2D
	{
		private var _x:Number;
		private var _y:Number;
		
		public function Spot2D(xLoc:Number, yLoc:Number)
		{
			x = xLoc;
			y = yLoc;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function draw(context:DisplayObject = null):void
		{
			if (context)
			{					
				doDraw(context);
			}
		}
		
		protected function getGraphic(context:DisplayObject):Graphics
		{
			var g:Graphics;
			if (context is Sprite)
			{
				g = Sprite(context).graphics;
			}
			if (context is Shape)
			{
				g = Shape(context).graphics;
			}			
				
			return g;
		}
		
		protected function doDraw(context:DisplayObject):void
		{
		    var graphic:Graphics = getGraphic(context);
			if (graphic)
			{				
				with (graphic)
				{
					clear();
					beginFill(0xFF0000);
					drawCircle(0, 0, 10);
					endFill();
				}
			}
		}
	
	}

}