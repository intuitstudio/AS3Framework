package com.intuitStudio.ui.buttons.concretes
{
	import com.intuitStudio.ui.buttons.abstracts.AbstractBlitTextButton;
	import com.intuitStudio.ui.commands.interfaces.ICommand;
    import com.intuitStudio.utils.ColorUtils;
 
    import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
    import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.display.Shape;
	
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.filters.DropShadowFilter;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;

	import flash.events.MouseEvent;

	public class TriangleBlitButton extends AbstractBlitTextButton
	{		
		public static const MT:int = 1;
		public static const LT:int = 2;

		private var triangle_command:Vector.<int > ;
		private var triangle_coords:Vector.<Number > ;

		public function TriangleBlitButton (wild:Number,tall:Number, offColor:uint= 0xEEEEEE,overColor:uint= 0xFFFFFF)
		{
			super (wild,tall,"",offColor,overColor);
            buttonType = "triangle";
		}

		override public function drawButton ():void
		{
			createBackground ();
			createHoverBackground ();
			addChildAt (backgroundBitmap,0);
			//orifilter = [new DropShadowFilter(5,45,0,.4,7,7,4)];
			filters = orifilter;
		}

		override protected function makeGradientBitmapData (color:uint,transparent:Boolean=false):BitmapData
		{
			canvasBitmapData = new BitmapData(_wild,_tall,transparent,color);
			var gradientBoxMatrix:Matrix = new Matrix();
			gradientBoxMatrix.createGradientBox (_wild, _tall,0,0,0);
			var colors:Array = [ColorUtils.darker(color),color];
			var alphas:Array = [1,1];
			var ratios:Array = [0,255];

			//
			triangle_command = new Vector.<int>();
			triangle_coords = new Vector.<Number>();

			triangle_command.push (MT,LT,LT,LT);
			triangle_coords.push (0,0,_wild,_tall>>1,0,_tall);
			drawingCanvas.graphics.clear ();
			drawingCanvas.graphics.beginGradientFill (GradientType.LINEAR,colors,alphas,ratios,gradientBoxMatrix);
			drawingCanvas.graphics.lineStyle (1, 0x000000,.5);
			drawingCanvas.graphics.drawPath (triangle_command, triangle_coords);
			drawingCanvas.graphics.endFill ();
			canvasBitmapData.draw (drawingCanvas,null,null,BlendMode.MULTIPLY,null,true);
			var cloneBitmapData = canvasBitmapData.clone();
			canvasBitmapData.dispose ();
			return cloneBitmapData;
		}

		override public function update (type:String=null):void
		{
			if (type != buttonType)
			{

			}

			super.update ();
		}
	}

}