package com.intuitStudio.ui.buttons.abstracts
{
	import com.intuitStudio.ui.commands.interfaces.ICommand;
	import com.intuitStudio.ui.buttons.interfaces.IButton;
	import com.intuitStudio.ui.buttons.interfaces.IClickable;
	import com.intuitStudio.utils.*;

    import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.BlendMode;
	import flash.display.GradientType;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.filters.DropShadowFilter;


	public class AbstractBlitTextButton extends Sprite implements IButton,IClickable
	{
		public static const OFF:int = 0;
		public static const OVER:int = 1;
		public static const SELECTED:int = 2;
		public static const LOCKED:int = 3;

		protected var _wild:Number;
		protected var _tall:Number;
		protected var _xLoc:Number = 0;
		protected var _yLoc:Number = 0;

		public var buttonType:String = "abstract";

		protected var offBgBitmapData:BitmapData;
		protected var overBgBitmapData:BitmapData;
		protected var offTextBitmapData:BitmapData;
		protected var overTextBitmapData:BitmapData;
		protected var labelText:String;
		protected var format:TextFormat;
		protected var colorOff:uint;
		protected var colorHover:uint;
		protected var colorTextOff:uint;
		protected var colorTextHover:uint;

		protected var canvasBitmapData:BitmapData;
		protected var canvasRect:Rectangle;
		protected var backgroundBitmap:Bitmap;
		protected var labelBitmap:Bitmap;
		protected var canvasBitmap:Bitmap;
		protected var drawingCanvas:Shape = new Shape();
		protected var offsetHolder:Number = 0;
		protected var radius:uint = 11;

		public var isSelected:Boolean = false;
		public var isPressed:Boolean = false;
		protected var isLocked:Boolean = false;
		protected var holdCounter:int = 0;
		protected var holdDelay:int = 60;
		protected var holdInterval:int = 0;
		protected var holdMax:int = 120;
		protected var orifilter:Array;


		public function AbstractBlitTextButton (wild:Number,tall:Number,lb:String="", offColor:uint= 0xEEEEEE,overColor:uint= 0xFFFFFF, offTextColor:uint=0,overTextColor:uint=0,fontSize:Number=12,isBold:Boolean=true,pOffset:Number=2,radius:Number=11)
		{
			_wild = wild;
			_tall = tall;
			labelText = lb;
			colorOff = offColor;
			colorHover = overColor;
			colorTextOff = offTextColor;
			colorTextHover = overTextColor;
			format = new TextFormat();
			format.size = fontSize;
			format.bold = isBold;
			offsetHolder = pOffset;
			radius = radius;
			//
			drawButton ();
			this.focusRect = false;
			//
			// addListeners();
		}

		public function addListeners ():void
		{
			doubleClickEnabled = true;
			addEventListener ( MouseEvent.MOUSE_OVER , dispatchMouse,false,0,true);
			addEventListener ( MouseEvent.MOUSE_OUT , dispatchMouse,false,0,true);
			addEventListener ( MouseEvent.CLICK , dispatchMouse,false,0,true);
			addEventListener ( MouseEvent.MOUSE_DOWN , dispatchMouse ,false,0,true);
			addEventListener ( MouseEvent.MOUSE_UP , dispatchMouse ,false,0,true);
			addEventListener ( MouseEvent.DOUBLE_CLICK , dispatchMouse,false,10,true );
		}

		public function removeListeners ():void
		{
			removeEventListener ( MouseEvent.MOUSE_OVER , dispatchMouse );
			removeEventListener ( MouseEvent.MOUSE_OUT , dispatchMouse );
			removeEventListener ( MouseEvent.CLICK , dispatchMouse );
			removeEventListener ( MouseEvent.MOUSE_DOWN ,dispatchMouse);
			removeEventListener ( MouseEvent.MOUSE_UP,dispatchMouse);
			removeEventListener ( MouseEvent.DOUBLE_CLICK,dispatchMouse);
		}

		public function drawButton ():void
		{
			createBackground ();
			createHoverBackground ();
			createLabelImage ();
			addChildAt (backgroundBitmap,0);
			if (labelBitmap)
			{
				addChild (labelBitmap);
			}
			orifilter = [new DropShadowFilter(6,45,0,.4,7,7,4)];
			filters = orifilter;
		}

		protected function createBackground ():void
		{
			offBgBitmapData = makeGradientBitmapData(colorOff,true);
			backgroundBitmap = makeBitmap(offBgBitmapData);
			//backgroundBitmap = makeGradientBitmapWithColor(colorOff);
		}

		protected function createHoverBackground ():void
		{
			overBgBitmapData = makeGradientBitmapData(colorHover,true);
		}

		protected function makeGradientBitmapData (color:uint,transparent:Boolean=false):BitmapData
		{
			canvasBitmapData = new BitmapData(_wild,_tall,transparent,color);
			var gradientBoxMatrix:Matrix = new Matrix();
			gradientBoxMatrix.createGradientBox (_wild, _tall,80,0,0);
			var colors:Array = [ColorUtils.darker(color),color];
			var alphas:Array = [1,1];
			var ratios:Array = [20,180];

			drawingCanvas.graphics.clear ();
			drawingCanvas.graphics.beginGradientFill (GradientType.LINEAR,colors,alphas,ratios,gradientBoxMatrix);
			drawingCanvas.graphics.lineStyle (1, 0x000000,.5);
			drawingCanvas.graphics.drawRoundRect (0,0,_wild-1,_tall-1,radius);
			drawingCanvas.graphics.endFill ();
			canvasBitmapData.draw (drawingCanvas,null,null,null,null,true);
			var cloneBitmapData:BitmapData = canvasBitmapData.clone();
			canvasBitmapData.dispose ();
			return cloneBitmapData;
		}

		protected function makeBitmap (data:BitmapData,opacity:Number=1.0,transparent:Boolean=false):Bitmap
		{
			var canvas:Bitmap = new Bitmap(data);
			canvasRect = new Rectangle(0,0,_wild,_tall);
			canvas.scrollRect = canvasRect;
			canvas.alpha = opacity;
			return canvas;
		}

		protected function makeGradientBitmapWithColor (color:uint,opacity:Number=1.0,transparent:Boolean=false):Bitmap
		{
			var canvas:Bitmap = new Bitmap(makeGradientBitmapData(color,transparent));
			canvasRect = new Rectangle(0,0,_wild,_tall);
			canvas.scrollRect = canvasRect;
			canvas.alpha = opacity;

			return canvas;
		}

		public function createLabelImage ():void
		{
			if (labelText == null || labelText == "" || labelText == " ")
			{
				return;
			}

			var field:TextField = TextFieldUtils.createDisplayText(labelText,1,1,new Point(0,0),format);
			field.autoSize = TextFieldAutoSize.LEFT;
			field.text = labelText;
			format.color = colorTextHover;
			field.setTextFormat (format);

			canvasBitmapData = new BitmapData(field.textWidth + offsetHolder * 2,field.textHeight + offsetHolder * 2,true,0x00000000);
			canvasBitmapData.draw (field,null,null,null,null,true);
			offTextBitmapData = canvasBitmapData.clone();

			labelBitmap = new Bitmap(offTextBitmapData);
			labelBitmap.x = .5*(backgroundBitmap.width -field.textWidth)-offsetHolder*2;
			labelBitmap.y = .5*(backgroundBitmap.height - field.textHeight)-offsetHolder*2;

			//
			format.color = colorTextOff;
			field.setTextFormat (format);
			canvasBitmapData = new BitmapData(field.textWidth + offsetHolder * 2,field.textHeight + offsetHolder * 2,true,0x00000000);
			canvasBitmapData.draw (field,null,null,null,null,true);
			overTextBitmapData = canvasBitmapData.clone();

		}

		final public function get wild ():Number
		{
			return _wild;
		}
		final public function set wild (value:Number):void
		{
			_wild = value;
		}
		final public function get tall ():Number
		{
			return _tall;
		}
		final public function set tall (value:Number):void
		{
			_tall = value;
		}

		public function get xLoc ():Number
		{
			return _xLoc;
		}

		public function get yLoc ():Number
		{
			return _yLoc;
		}

		public function place (px:Number,py:Number):void
		{
			_xLoc = px;
			_yLoc = py;
			update ();
		}

		public function update (type:String=null):void
		{
			x = _xLoc;
			y = _yLoc;
		}

		public function dispatchMouse (e:MouseEvent):void
		{
			e.stopPropagation ();
			dispatchEvent (e);
		}

		public function setCommand (target:*,cmd:ICommand):void
		{
			doSetCommand (target,cmd);
		}

		protected function doSetCommand (target:*,cmd:ICommand):void
		{
			throw new IllegalOperationError('doSetCommand must be overridden');
		}


		public function onHover (e:MouseEvent):void
		{
			doOnHover (e);
		}

		public function onOut (e:MouseEvent):void
		{
			doOnOut (e);
		}

		protected function doOnHover (e:MouseEvent):void
		{
			throw new IllegalOperationError('doOnHover must be overridden');
		}

		protected function doOnOut (e:MouseEvent):void
		{
			throw new IllegalOperationError('doOnOut must be overridden');
		}

		public function onClick (e:MouseEvent):void
		{
			doOnClick (e);
		}
		
		public function onPressDown (e:MouseEvent):void
		{
			doOnPressDown (e);
		}
		
		public function onReleaseUp (e:MouseEvent):void
		{
			doOnReleaseUp (e);
		}
		
		public function onDbClick (e:MouseEvent):void
		{
			doOnDbClick (e);
		}
		
		protected function doOnClick (e:MouseEvent):void
		{
			throw new IllegalOperationError('doOnClick must be overridden');
		}
		
		protected function doOnPressDown (e:MouseEvent):void
		{
			throw new IllegalOperationError('doOnPressDown must be overridden');
		}
		
		protected function doOnReleaseUp (e:MouseEvent):void
		{
			throw new IllegalOperationError('doOnReleaseUp must be overridden');
		}
		
		protected function doOnDbClick (e:MouseEvent):void
		{
			throw new IllegalOperationError('doOnDbClick must be overridden');
		}		
		

	}
}