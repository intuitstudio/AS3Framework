package com.intuitStudio.motions.triDimens.isometric.concretes
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import com.intuitStudio.motions.triDimens.isometric.IsoUtils;
	import com.intuitStudio.motions.triDimens.isometric.core.DrawnIsoTile;
	import com.intuitStudio.utils.ColorUtils;


	public class DrawnIsoCircle extends DrawnIsoTile
	{
        private var circle:Shape;
		
		public function DrawnIsoCircle (size:Number,col:uint,h:Number=0)
		{
			super (size,col,h);
		}

		override public function draw ():void
		{
           super.draw();
		   this.mask = drawCircle(color);		
		}

		private function drawCircle (color:uint,h:Number=0):Shape
		{
			circle = new Shape();
			var g:Graphics = circle.graphics;
			g.beginFill (color);
			g.lineStyle (0,0,.1);
			g.drawCircle (0,0,size*.5);
			g.endFill();
			circle.transform.matrix = new Matrix(1,0,0,.5,0,0);
			addChild(circle);
			return circle;
		}

		public function changeCircleColor(col:uint):void
		{
			circle.transform.colorTransform = ColorUtils.colorTransform(col);
		}

	}
}