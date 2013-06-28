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

	public class PauseBlitButton extends AbstractBlitTextButton
	{
		public static const MT:int = 1;
		public static const LT:int = 2;

		private var path_command:Vector.<int > ;
		private var path_coords:Vector.<Number > ;

		public function PauseBlitButton (wild:Number,tall:Number,offColor:uint=0xEEEEEE,overColor:uint=0xFFFFFF)
		{
			super (wild,tall,"",offColor,overColor);
			buttonType = "triangle";
		}

		override public function drawButton ():void
		{
			createBackground ();
			createHoverBackground ();
			addChildAt (backgroundBitmap,0);
			orifilter = [new DropShadowFilter(5,45,0,.4,7,7,4)];
			filters = orifilter;
		}

		override protected function makeGradientBitmapData (color:uint,transparent:Boolean=false):BitmapData
		{
			canvasBitmapData = new BitmapData(_wild,_tall,transparent,color);
			var gradientBoxMatrix:Matrix = new Matrix  ;
			gradientBoxMatrix.createGradientBox (_wild,_tall,0,0,0);
			var colors:Array = [ColorUtils.darker(color),color];
			var alphas:Array = [1,1];
			var ratios:Array = [0,255];

			//
			path_command = new Vector.<int >   ;
			path_coords = new Vector.<Number >   ;

			path_command.push (MT,LT,LT,LT,LT);

			drawingCanvas.graphics.clear ();
			drawingCanvas.graphics.lineStyle (1,0x000000,.5);
			
			drawingCanvas.graphics.beginGradientFill (GradientType.LINEAR,colors,alphas,ratios,gradientBoxMatrix);
			path_coords.push (_wild / 8,0,_wild * 3 / 8,0,_wild * 3 / 8,_tall-1,_wild / 8,_tall-1,_wild / 8,0);
			drawingCanvas.graphics.drawPath (path_command,path_coords);
			
			path_coords = new Vector.<Number >   ;
			path_coords.push ( _wild*(1 / 2 + 1 / 8),0,_wild*(1 / 2 + 3 / 8),0,_wild * (1 / 2 + 3 / 8),_tall-1,_wild * (1 / 2 + 1 / 8),_tall-1,_wild * (1 / 2 + 1 / 8),0);
			drawingCanvas.graphics.drawPath (path_command,path_coords);			
			
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