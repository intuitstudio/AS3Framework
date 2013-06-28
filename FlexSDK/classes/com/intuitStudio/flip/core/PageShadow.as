package com.intuitStudio.flip.core
{
	/**
	 * PageShadow Class
	 * @author vanier peng,2013.4.23
	 * 頁面的陰影影像效果
	 */
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import com.intuitStudio.utils.MathTools;
	
	public class PageShadow extends Sprite
	{
		private var _direction:String = 'left';
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _mat:Matrix = new Matrix();
		private var _alpha:Number = .6;
		private var _color:uint = 0xFFFFFF;
		private var _shadow:uint = 0x000000;
		
		public function PageShadow(dir:String, w:Number = 0, h:Number = 0, blend:Number = .6)
		{
			_direction = dir;
			_alpha = blend;
			setSize(w, h);
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(dir:String):void
		{
			_direction = dir;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			width = w;
			height = h;
		}
		
		public function setColor(front:uint, back:uint = 0x000000):void
		{
			_color = front;
			_shadow = back;
		}
		
		public function setAlpha(value:Number):void
		{
			_alpha = MathTools.clamp(value, 0, 1);
		}
		
		public function locate(xLoc:Number, yLoc:Number):void
		{
			x = xLoc;
			y = yLoc;
		}
		
		public function rendering(context:DisplayObject = null):void
		{
			draw(context||this);
		}
		
		protected function draw(context:DisplayObject):void
		{
			if (!context.hasOwnProperty('graphics'))
				return;
			
			var gs:Graphics = (context is Sprite) ? Sprite(context).graphics : (context is Shape) ? Shape(context).graphics : null;
			
			if (gs !== null)
			{
				var point:Point, colors:Array, alphas:Array, ratios:Array = [0, 128, 255];
				
				_mat.createGradientBox(width, height);
				if (direction === 'left')
				{
					point = new Point(-width, 0);
					//colors = [0xFFFFFF, 0xCCCCCC, 0x000000];
					colors = [_color, _color, _shadow];
					alphas = [0, _alpha * .5, _alpha];
					_mat.translate(-width, 0);
				}
				else
				{
					point = new Point(0, 0);
					//colors = [0x000000, 0xCCCCCC, 0xFFFFFF];
					colors = [_shadow, _color, _color];
					alphas = [_alpha, _alpha * .5, 0];
				}
				
				with (gs)
				{
					clear();
					lineStyle(0, 0, 0);
					beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, _mat);
					drawRect(point.x, point.y, width, height);
				}
			}
		
			//
		
		}
	
	} // end of class

}