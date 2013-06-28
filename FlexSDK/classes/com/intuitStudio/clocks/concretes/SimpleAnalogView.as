package com.intuitStudio.clocks.concretes
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;

	import flash.filters.DropShadowFilter;
	import flash.events.Event;

	import com.intuitStudio.clocks.core.ClockData;
	import com.intuitStudio.clocks.core.ClockController;
	import com.intuitStudio.clocks.abstracts.AbstractClockView;

	import com.intuitStudio.utils.TextFieldUtils;
	import com.intuitStudio.utils.ImageUtils;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.intuitStudio.clocks.core.ClockTime;

	public class SimpleAnalogView extends AbstractClockView
	{
		private var _hourHand:Shape;
		private var _minuteHand:Shape;
		private var _secondHand:Shape;
		private var _hands:Vector.<Shape > ;

		protected var _bgData:BitmapData;
		protected var _bg:Bitmap;
		protected var _timeImageData:BitmapData;
		protected var _timeImage:Bitmap;
		protected var _size:Number;
		protected var _color:uint;
		protected var _fontSize:uint;
		protected var _fontFamily:String;
		protected var _tfs:Vector.<TextField > ;
		protected var _scale:Number = 1;
		protected var _center:Point=new Point();

		public function SimpleAnalogView (model:ClockData,controller:ClockController,size:Number,color:uint=0,fontSize:int=36,fontFamily:String='Impact')
		{
			_size = size;
			_color = color;
			_fontSize = fontSize;
			_fontFamily = fontFamily;
			_center = new Point(_size * .5,_size * .5);
			super (model,controller);
		}

		override protected function init ():void
		{
			_tfs = new Vector.<TextField>();
			super.init ();
		}

		override protected function makeImages ():void
		{
			_bg = new Bitmap();
			_timeImage = new Bitmap();
			_bgData = ImageUtils.make32BitImage(_size,_size);
			_timeImageData = ImageUtils.make32BitImage(_size * 2,_size * 2);

			var bgShape:Shape = makeBackground();
			_bgData.draw (bgShape);
			makeHourImages ();
			//
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

			addChild (shape);
			return shape;
		}

		override protected function doCreateClockFace ():void
		{
			makeHands ();
			drawHands (_model.time);
		}

		protected function makeHands ():void
		{
			_hands = new Vector.<Shape>();
			createHand(5,-_size*.25);//hr
			createHand(2,-_size*.45);//minute
			createHand(1,-_size*.45);//second
		}

        private function createHand(thickness:uint,ypos:Number,color:uint=0):void
		{
			var hand:Shape = new Shape();
			hand.graphics.lineStyle (thickness, color);
			hand.graphics.lineTo (0, ypos);
			_hands.push (hand);
		}

		private function drawHands (time:ClockTime):void
		{
			_timeImageData.fillRect (_timeImageData.rect,0);
			var timeAngles:Vector.<Number >  = getHandAngles(time);
			for (var i:uint=0; i<_hands.length; i++)
			{
				drawHand (_hands[i],_center,timeAngles[i]);
			}
			//
			if (_timeImage.bitmapData)
			{
				_timeImage.bitmapData.dispose ();
			}
			_timeImage.bitmapData = _timeImageData.clone();
		}

		protected function drawHand (hand:Shape,destPoint:Point,rotateAmount:Number):void
		{
			var matrix:Matrix = new Matrix();
			matrix.rotate (rotateAmount);
			matrix.translate (destPoint.x,destPoint.y);
			_timeImageData.draw (hand,matrix);
		}


		override protected function drawClock ():void
		{
			_bg.bitmapData = _bgData.clone();
			_timeImage.bitmapData = _timeImageData.clone();
			addChild (_bg);
			addChild (_timeImage);
		}

		protected function makeHourImages ():void
		{
			var tf:TextField;
			var matrix:Matrix;
			var offsetAngle:Number = (Math.PI*2/12);
			var angle:Number = 0;
			var dx:Number = 0;
			var dy:Number = 0;
			var radius:Number = _size * .40;

			for (var i:uint=0; i<12; i++)
			{
				tf = TextFieldUtils.makeTextField(_fontSize,_color,_fontFamily,true,TextFormatAlign.LEFT,TextFieldAutoSize.LEFT);
				tf.text = String(i + 1);
				matrix = new Matrix();
				angle = offsetAngle*(i+1)-Math.PI*.5;

				dx = _center.x + Math.cos(angle) * radius - tf.width * .5;
				dy = _center.y + Math.sin(angle) * radius - tf.height * .5;
				matrix.translate (dx,dy);
				_bgData.draw (tf,matrix);
			}
		}

		protected function drawNow ():void
		{
			drawHands (_model.time);
			ImageUtils.applyFilter (_timeImageData,_timeImageData,new DropShadowFilter(1,45,0));
		}

		override public function onUpdateView (e:Event):void
		{
			drawNow ();
		}
	}


}