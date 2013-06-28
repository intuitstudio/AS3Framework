package com.intuitStudio.drawAPIs.core
{
	import flash.display.Graphics;

	public class TriangleFilled extends Triangle
	{
		protected var _color:uint;
		protected var _showTriangle:Boolean;

		public function TriangleFilled (color:uint=0,saw:Boolean=false)
		{
			_color = color;
			_showTriangle = saw;
			super ();
		}

		override protected function doDraw (g:Graphics):void
		{
			g.clear ();
			var blend:Number = (_showTriangle)?1.0:0;
			g.lineStyle (0,0,blend);
			g.beginFill (_color);
			g.drawTriangles (_vertices,_indices);
			g.endFill ();
		}

	}
}