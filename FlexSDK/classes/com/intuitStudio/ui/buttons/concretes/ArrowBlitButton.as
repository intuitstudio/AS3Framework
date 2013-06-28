package com.intuitStudio.ui.buttons.concretes
{
	import com.intuitStudio.ui.buttons.abstracts.AbstractBlitTextButton;
	import com.intuitStudio.ui.commands.interfaces.ICommand;
	import com.intuitStudio.utils.ColorUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	import flash.display.BlendMode;
	import flash.display.LineScaleMode;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class ArrowBlitButton extends AbstractBlitTextButton
	{
		public static const MT:int = 1;
		public static const LT:int = 2;

		private var cross_command:Vector.<int > ;
		private var cross_coords:Vector.<Number > ;
		private var _radius:Number = 40;
		private var _direction:String = 'right';
		private var hitSprite:Sprite = new Sprite();
		private var arrowSprite:Sprite = new Sprite();


		public function ArrowBlitButton (wild:Number,tall:Number,radius:Number,dir:String ='right' ,offColor:uint= 0xEEEEEE,overColor:uint= 0xFFFFFF)
		{
			_radius = radius;
			_direction = dir;			
			super (wild,tall,"",offColor,overColor);
			buttonType = dir + "arrow";
		}

        public function get direction():String
		{
			return _direction;
		}
		
		override public function addListeners ():void
		{
			doubleClickEnabled = true;
			arrowSprite.addEventListener ( MouseEvent.MOUSE_OVER , onHover );
			arrowSprite.addEventListener ( MouseEvent.MOUSE_OUT , onOut );
			//addEventListener ( MouseEvent.CLICK , onClick );
			arrowSprite.addEventListener ( MouseEvent.MOUSE_DOWN , onPressDown ,false,0,true);
			arrowSprite.addEventListener ( MouseEvent.MOUSE_UP , onReleaseUp ,false,0,true);
			//arrowSprite.addEventListener ( MouseEvent.DOUBLE_CLICK , onDbClick,false,10,true );
			//
			hitSprite.addEventListener ( MouseEvent.MOUSE_OVER , onHitHover );
			hitSprite.addEventListener ( MouseEvent.MOUSE_OUT , onHitOut );
		}

		override public function removeListeners ():void
		{
			arrowSprite.removeEventListener ( MouseEvent.MOUSE_OVER , onHover );
			arrowSprite.removeEventListener ( MouseEvent.MOUSE_OUT , onOut );
			//addEventListener ( MouseEvent.CLICK , onClick );
			arrowSprite.removeEventListener ( MouseEvent.MOUSE_DOWN , onPressDown );
			arrowSprite.removeEventListener ( MouseEvent.MOUSE_UP , onReleaseUp );
			//arrowSprite.removeEventListener ( MouseEvent.DOUBLE_CLICK , onDbClick,false,10,true );
			//
			hitSprite.removeEventListener ( MouseEvent.MOUSE_OVER , onHitHover );
			hitSprite.removeEventListener ( MouseEvent.MOUSE_OUT , onHitOut );
		}

		override protected function doSetCommand (target:*,cmd:ICommand):void
		{

		}

		override public function drawButton ():void
		{
			createHitArea ();
			addChildAt (hitSprite,0);
			createBackground ();
			createHoverBackground ();
			arrowSprite.addChild (backgroundBitmap);
			addChild (arrowSprite);
			arrowSprite.alpha = 0;
			orifilter = [new DropShadowFilter(5,45,0,.4,7,7,4)];
			filters = orifilter;
			placeArrow ();
		}

		//centerlize arrow sign 
		private function placeArrow ():void
		{
			switch (_direction)
			{
				case 'up' :
					arrowSprite.x = (_wild-(_radius<<1))>>1;
					arrowSprite.y = (_tall-_radius)>>1;
					break;
				case 'down' :
					arrowSprite.x = (_wild-(_radius<<1))>>1;
					arrowSprite.y = -((_tall-_radius)>>1);
					break;
				case 'left' :
					arrowSprite.x = (_wild-_radius)>>1;
					arrowSprite.y = (_tall-(_radius<<1))>>1;
					break;
				case 'right' :
					arrowSprite.x = -((_wild-_radius)>>1);
					arrowSprite.y = (_tall-(_radius<<1))>>1;
					break;
			}
		}

		private function createHitArea ():void
		{
			canvasBitmapData = new BitmapData(_wild,_tall,true,0);
			drawingCanvas.graphics.clear ();
			drawingCanvas.graphics.beginFill (0,0.3);
            drawingCanvas.graphics.beginFill (0,0);			
			//drawingCanvas.graphics.drawRect (0,0,_wild,_tall);
			drawingCanvas.graphics.endFill ();
			canvasBitmapData.draw (drawingCanvas,null,null,BlendMode.MULTIPLY,null,true);
			hitSprite.addChild (new Bitmap(canvasBitmapData.clone()));
			canvasBitmapData.dispose ();
		}

		override protected function makeGradientBitmapData (color:uint,transparent:Boolean=false):BitmapData
		{
			canvasBitmapData = new BitmapData(_radius * 2,_radius * 2,transparent,color);
			var colors:Array = [ColorUtils.darker(color),color];
			var alphas:Array = [.3,.3];
			var ratios:Array = [0,255];
			//
			cross_command = new Vector.<int>();
			cross_coords = new Vector.<Number>();
			cross_command.push (MT,LT,LT);

			switch (_direction)
			{
				case 'up' :
					cross_coords.push (4,_radius-4,_radius,4,(_radius<<1)-4,_radius-4);
					break;
				case 'down' :
					cross_coords.push (4,_radius,_radius,(_radius<<1)-4,(_radius<<1)-4,_radius);
					break;
				case 'left' :
					cross_coords.push (_radius,4,4,_radius,_radius,(_radius<<1)-4);				
					break;
				case 'right' :
					cross_coords.push (_radius,4,(_radius<<1)-4,_radius,_radius,(_radius<<1)-4);
					break;
			}

			drawingCanvas.graphics.clear ();
            drawingCanvas.graphics.beginFill (0,0);				
            //drawingCanvas.graphics.beginFill (0xaa0000,0.3);	
            	
			drawingCanvas.graphics.lineStyle (0,0,0);
			drawingCanvas.graphics.drawCircle (_radius,_radius,_radius);
			drawingCanvas.graphics.endFill ();
			drawingCanvas.graphics.lineStyle (7, 0xefefef,.78);
			drawingCanvas.graphics.drawPath (cross_command, cross_coords);
			canvasBitmapData.draw (drawingCanvas,null,null,BlendMode.MULTIPLY,null,true);
			var cloneBitmapData:BitmapData = canvasBitmapData.clone();
			canvasBitmapData.dispose ();
			return cloneBitmapData;
		}

		private function onHitHover (e:MouseEvent):void
		{
			drawArrow ();
		}
		private function onHitOut (e:MouseEvent):void
		{
			if (checkArrowArea() == false)
			{
				trace ('arrow hit out');
				drawArrow (false);
			}
		}

		public function drawArrow (valid:Boolean=true):void
		{
			arrowSprite.alpha = (valid)?1:0;
		}

		public function checkArrowArea ():Boolean
		{
			var res:Boolean = false;
			var clickPoint2:Point = new Point(hitSprite.mouseX,hitSprite.mouseY);
			var pt:Point = hitSprite.localToGlobal(clickPoint2);
			res = arrowSprite.hitTestPoint(pt.x,pt.y,true);
			return res;
		}

		override protected function doOnHover (e:MouseEvent):void
		{

			if (isSelected)
			{
				buttonMode = false;
				return;
			}
			buttonMode = ! isLocked;
			backgroundBitmap.bitmapData = overBgBitmapData;


			//
			if (! isLocked)
			{
				dispatchEvent (new Event(Event.CHANGE));
			}
		}

		override protected function doOnOut (e:MouseEvent):void
		{
			buttonMode = false;

			if (isSelected)
			{
				return;
			}
			backgroundBitmap.bitmapData = offBgBitmapData;

			if (isPressed)
			{
				unPress ();
			}

/*
			if (_outCommand)
			{
				_outCommand.execute ();
			}
			*/
			filters = orifilter;
			//
			if (! isLocked && hasEventListener(Event.ENTER_FRAME))
			{

			}
		}

		override protected function doOnPressDown (e:MouseEvent):void
		{

		}

		override protected function doOnReleaseUp (e:MouseEvent):void
		{

		}

		public function unPress ():void
		{

		}

		override public function update (type:String=null):void
		{
			if (type != buttonType)
			{
				drawArrow (checkArrowArea());
			}

			super.update ();
		}

	}

}