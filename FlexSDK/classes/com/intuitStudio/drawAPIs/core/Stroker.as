package com.intuitStudio.drawAPIs.core
{
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsEndFill;
    import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsShaderFill;
	import flash.display.GradientType;

	public class Stroker
	{
		public static const STROKE_LINE:int = 0;
		public static const STROKE_DOT:int = 1;
		public static const STROKE_THINEST:int = 2;
		public static const STROKE_WIDER:int = 3;
		public static const STROKE_GRADIENT:int = 4;
		public static const STROKE_SHADER:int = 5;

		protected var _size:Number;
		protected var _color:Number;
		protected var _blend:Number;
		protected var _stroke:GraphicsStroke;

		public function Stroker (size:Number,color:uint,type:int=0,openness:Number = 1.0)
		{
			_size = size;
			_color = color;
			_blend = openness;
			_stroke = new GraphicsStroke();
			makeStroke (type);
		}

		//override by sub class
		protected function makeStroke (type:int):void
		{
			_stroke.thickness = size;
			
			switch (type)
			{
				case Stroker.STROKE_LINE :					
					_stroke.fill = new GraphicsSolidFill(color,openness);
					break;
				case Stroker.STROKE_DOT :
					_stroke.fill = new GraphicsGradientFill(GradientType.LINEAR,[color,color],[1,0],[0,255]);
					break;
			}
		}

		public function get stroke ():GraphicsStroke
		{
			return _stroke;
		}

		public function set size (value:Number):void
		{
			_size = value;
		}

		public function get size ():Number
		{
			return _size;
		}

		public function set color (value:uint):void
		{
			_color = value;
		}

		public function get color ():uint
		{
			return _color;
		}

		public function set openness (value:Number):void
		{
			_blend = value;
		}

		public function get openness ():Number
		{
			return _blend;
		}
	}

}