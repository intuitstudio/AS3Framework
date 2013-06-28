package com.intuitStudio.biMotion.core
{
	/**
	 * Point2d Class
	 * @author vanier peng,2013.4.17
	 * 定義平面物件的基礎類別- 點，賦與基本的座標、質量、尺寸等屬性
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	
	public class Point2d extends Point
	{
		private var _tx:Number;
		private var _ty:Number;
		private var _mass:Number = 1.0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function Point2d(xpos:Number = 0, ypos:Number = 0)
		{
			x = xpos;
			y = ypos;
			_tx = xpos;
			_ty = ypos;
		}
		
		public function get tx():Number
		{
			return _tx;
		}
		
		public function set tx(value:Number):void
		{
			_tx = value;
		}
		
		public function get ty():Number
		{
			return _ty;
		}
		
		public function set ty(value:Number):void
		{
			_ty = value;
		}
		
		public function get mass():Number
		{
			return _mass;			
		}
		
		public function set mass(value:Number):void
		{
			_mass = value;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}	
		
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function rendering(context:DisplayObject=null):void
		{
			draw(context);
		}
		
		// 繪製示意用的圓點
		protected function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
				var radius:Number = 2;
				var color:Number = 0x000000;
				var gs:Graphics = (context is Sprite) ? Sprite(context).graphics : (context is Shape) ? Shape(context).graphics : null;
				
				with (gs)
				{
					//clear();
					lineStyle(0);
					beginFill(color);
					drawCircle(x - (radius >> 1), y - (radius >> 1), radius);
					endFill();
				}
			}
		}
	
	} //end of class

}