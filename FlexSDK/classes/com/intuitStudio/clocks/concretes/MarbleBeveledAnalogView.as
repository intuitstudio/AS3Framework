package com.intuitStudio.clocks.concretes
{
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.BlurFilter;


	import com.intuitStudio.clocks.core.*;
	import com.intuitStudio.clocks.concretes.BeveledAnalogView;
	import com.intuitStudio.utils.ImageUtils;
	import aether.textures.natural.MarbleTexture;


	public class MarbleBeveledAnalogView extends BeveledAnalogView
	{
		protected var _perlinNoise:BitmapData;
		protected var _perlinOffsets:Array;
		protected var _perlinSeed:int;
		protected var _gradient:BitmapData;
		protected var _faceImage:Bitmap;
		protected var _faceImageData:BitmapData;

		public function MarbleBeveledAnalogView (model:ClockData,controller:ClockController,size:Number,color:uint=0,fontSize=36,fontFamily:String='Impact')
		{
			super (model,controller,size,color,fontSize,fontFamily);
		}

		override protected function makeImages ():void
		{
			super.makeImages ();
			_faceImage = new Bitmap();
		}

		override protected function doCreateClockFace ():void
		{
			makeGradientOverlay ();
			makeNoise ();
			makeClockFace ();
			super.doCreateClockFace ();
		}


		override protected function drawClock ():void
		{
 
			super.drawClock ();
			addChild (_faceImage);
			addChild (_timeImage);
 
		}

		private function makeClockFace ():void
		{
			applyNoise ();
			_faceImageData = _bgData.clone();
			//lessen left side distortion
			_perlinNoise.copyPixels (
			   _gradient,
			   _gradient.rect,
			   new Point(),
			   _perlinNoise,
			   new Point(),
			   true
			   );
			//distort bg

			ImageUtils.applyFilter (
			   _faceImageData,
			   _faceImageData,
			   new DisplacementMapFilter(
			     _perlinNoise,
			     new Point(),
			     BitmapDataChannel.RED,
			     BitmapDataChannel.RED,
			     40,
			     40
			   )
			);
/*
			ImageUtils.applyFilter (
			   _faceImageData,
			   _faceImageData,
			   new BlurFilter(2,2)			  
			);
             */
			//add lighting effect
			ImageUtils.copyChannel (_bgData,_faceImageData,BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

			_faceImageData.draw (
			   _perlinNoise,
			   null,
			   new ColorTransform(1, 1, 1, 0.5),
			   BlendMode.HARDLIGHT
			);

			ImageUtils.copyChannel (_faceImageData,_timeImageData,BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			_faceImage.bitmapData = _faceImageData.clone();
		}

		private function makeNoise ():void
		{
			_perlinNoise = _bgData.clone();
			_perlinSeed = int(new Date());
			_perlinOffsets = [new Point()];
		}

		private function applyNoise ():void
		{
			_perlinNoise.perlinNoise (200,200,1,_perlinSeed,false,true,BitmapDataChannel.RED,true,_perlinOffsets);
			Point(_perlinOffsets[0]).x -=  10;
			ImageUtils.copyChannel (_bgData,_perlinNoise,BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		}


		override protected function makeBackground ():Shape
		{
			var shape:Shape = new Shape();
			var marbleTexture:BitmapData = makeMarble();
			with (shape.graphics)
			{
				beginBitmapFill (marbleTexture);
				drawCircle (_size*.5,_size*.5,_size*.5);
				endFill ();
			}
			return shape;
		}

		private function makeMarble ():BitmapData
		{
			var bitmapData:BitmapData = new MarbleTexture(_size * 2,_size * 2,0xFF5484b4).draw();
			var lighting:BitmapData = ImageUtils.make32BitImage(900,900);
			lighting.fillRect (lighting.rect,0);
			lighting.fillRect (new Rectangle(0,0,900,900),0x44000000);
			var matrix:Matrix = new Matrix();
			matrix.rotate (Math.PI*.25);
			bitmapData.draw (lighting,matrix);
			lighting.dispose ();

			return bitmapData;
		}

		private function makeGradientOverlay ():void
		{
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox (_size*2,_size*2);
			var colors:Array = [0x7f7f7f,0x7f7f7f];
			var alphas:Array = [1,8];
			var ratios:Array = [20,80];
			var shape:Shape = new Shape();
			with (shape.graphics)
			{
				beginGradientFill (
				GradientType.LINEAR,
				colors,
				alphas,
				ratios,
				matrix
				);
				drawRect (0,0,_size*2,_size*2);
				endFill ();
			}
			_gradient = ImageUtils.make32BitImage(_size * 2,_size * 2);
			_gradient.draw (shape);
		}

	}
}