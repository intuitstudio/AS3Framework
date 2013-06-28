package com.intuitStudio.flip.core 
{
	/**
	 * BlankPage Class
	 * @author vanier peng,2013.4.23
	 * 空白頁面,本身
	 */
	

	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import com.intuitStudio.utils.ColorUtils;
	
	public class _BlankPage extends MovieClip
	{
		private const maxShadowWidth:int = 100;
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _shadowR:PageShadow;
		private var _shadowL:PageShadow;
		private var _canvasData:BitmapData;
		private var _canvas:Bitmap;
		private var _drawShape:Shape;
		private var _color:uint = 0xFFFFFF;
				
		public function _BlankPage(shadowed:Boolean=true) 
		{
			if (shadowed)
			{
			    addLeftShadow();
			  	addRightShadow();
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}

		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
						
		public function addLeftShadow():void
		{
			_shadowL = new PageShadow('left');
			addChild(_shadowL);
		}

		public function addRightShadow():void
		{
			_shadowR = new PageShadow('right');
			addChild(_shadowR);
		}
		
		public function setColor(tint:uint,amount:Number=1.0):void
		{
			amount = Math.min(1.0, amount);
			var cTrans:ColorTransform = ColorUtils.colorTransform(tint,amount);
		//	cTrans.redMultiplier = cTrans.greenMultiplier = amount;
			_color = cTrans.color;
			if (_shadowL)
			{
				_shadowL.setColor(tint);
			}
			if (_shadowR)
			{
				_shadowR.setColor(tint);
			}		
		}
		
		public function setSize(w:Number,h:Number):void
		{
		   width = (w << 1);
		   height = h;
		   var sWide:Number = Math.min(maxShadowWidth,width * 2 / 3);

		   if (_shadowL) {
   			   _shadowL.setSize(sWide, height);
		   }
		   if (_shadowR) {
			   _shadowR.setSize(sWide, height);
		   }
		}
		
		public function rendering(context:DisplayObject=null):void
		{
           drawShadows();
		   draw(this);
		}
		
		private function drawShadows():void
		{
		   var destX :Number = x + (width >> 1);
		   if (_shadowL) {
			   _shadowL.locate(destX, y);
			   _shadowL.rendering();			  
		   }
		   if (_shadowR) {
			    _shadowR.locate(destX, y);
			   _shadowR.rendering();
		   }
		}
		
		protected function draw(context:DisplayObject):void
		{
            //draw background;
			if (_canvasData == null) {
				_canvasData = new BitmapData(width, height, true, 0);
			}
			var g:Graphics  = MovieClip(context).graphics;
			with (g)
			{
				beginFill(_color);
				drawRect(0,0,width, height);
				endFill();
			}
			
			_canvasData.draw(context);
			
		}
		
		
		
	}

}