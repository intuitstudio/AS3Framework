package com.intuitStudio.clocks.concretes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.filters.DropShadowFilter;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.intuitStudio.clocks.abstracts.AbstractClockView;
	import com.intuitStudio.clocks.core.ClockData;
	import com.intuitStudio.clocks.core.ClockController;
	import com.intuitStudio.images.concretes.BeveledTextImage;
	import com.intuitStudio.utils.TextFieldUtils;
	import com.intuitStudio.utils.ImageUtils;

	public class SimpleDigitalView extends AbstractClockView
	{
		protected var _bgData:BitmapData;
		protected var _bg:Bitmap;
		protected var _timeImageData:BitmapData;
		protected var _timeImage:Bitmap;
		protected var _clockField:TextField;
		protected var _size:Number;
		protected var _color:uint;
		protected var _fontSize:uint;
		protected var _fontFamily:String;
		protected var _tf:TextField;
		protected var _scale:Number = 1;
		protected var _offset:Point=new Point();

		public function SimpleDigitalView (model:ClockData,controller:ClockController,size:Number,color:uint=0,fontSize=36,fontFamily:String='Impact')
		{
			_size = size;
			_color = color;
			_fontSize = fontSize;
			_fontFamily = fontFamily;
			super (model,controller);
		}

		override protected function doCreateClockFace ():void
		{			
			makeTimeFieldImage ();
		}

		override protected function makeImages ():void
		{
			_bg = new Bitmap();
			_timeImage = new Bitmap();
			_bgData = ImageUtils.make32BitImage(_size,_size);
			_timeImageData = ImageUtils.make32BitImage(_size * 2,_size * 2);			

			var bgShape:Shape = makeBackground();
			_bgData.draw (bgShape);	
		}
		
		override protected function drawClock ():void
		{
			_bg.bitmapData = _bgData.clone();
			_timeImage.bitmapData = _timeImageData.clone();
			addChild (_bg);
			addChild (_timeImage);
		}        

		protected function makeBackground ():Shape
		{
			var shape:Shape = new Shape();
			with (shape.graphics)
			{
				beginFill (0xFFFFFF);
				drawCircle (_size*.5,_size*.5,_size*.5);
				endFill ();
			}
			return shape;
		}

		protected function makeTimeFieldImage ():void
		{
			_timeImageData.fillRect (_timeImageData.rect,0);
			_tf = TextFieldUtils.makeTextField(_fontSize,_color,_fontFamily,true,TextFormatAlign.LEFT,TextFieldAutoSize.LEFT);
			_tf.text = " 00 : 00 : 00 ";
			_scale = _size / _tf.textWidth;
			_offset.x = 0;
			_offset.y = (_size-_tf.textHeight*_scale)*.5;
			drawTimeFieldImage (_tf);
		}

		protected function drawTimeFieldImage (target:DisplayObject):void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale (_scale,_scale);
			matrix.translate (_offset.x,_offset.y);

			_timeImageData.fillRect (_timeImageData.rect,0);
			_timeImageData.draw (target,matrix);
			ImageUtils.applyFilter (_timeImageData,_timeImageData,new DropShadowFilter(1,45,0));
			_timeImage.bitmapData = _timeImageData.clone();
		}

		override public function onUpdateView (e:Event):void
		{
			_tf.text = getTimeString();
			drawTimeFieldImage (_tf);
		}

	}
}