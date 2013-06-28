package com.intuitStudio.TBW.builder.abstracts
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class AbstractDisplayDirector
	{
		protected var _builder:AbstractDisplayBuilder;
		protected var rect:Rectangle = new Rectangle(0,0,0,0);
		protected var _wild:Number = 800;
		protected var _tall:Number = 640;

		public function AbstractDisplayDirector (builder:AbstractDisplayBuilder)
		{
			_builder = builder;
		}

		public function getView ():BitmapData
		{
			return _builder.getView();
		}

		public function assignRect (x:Number=0,y:Number=0,w:Number=0,h:Number=0):void
		{
			rect.x = x;
			rect.y = y;
			rect.width = w;
			rect.height = h;
		}
	}
}