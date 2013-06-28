package com.intuitStudio.flip.core 
{
	/**
	 * SlicePiece Class
	 * @author vanier peng
	 * 頁面的局部截圖 , 包含正反兩面的畫面
	 */
	
	import flash.display.DisplayObject; 
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Matrix;
	 
	public class SlicePiece extends Sprite
	{
		private var _frontData:BitmapData;
		private var _backData:BitmapData;
		private var _frontBitmap:Bitmap;
		private var _backBitmap:Bitmap;
		private var _startX:Number;
		private var _startY:Number;		
		private var _oriMatrix:Matrix;
		
		public function SlicePiece(drawFront:DisplayObject,drawBack:DisplayObject,oriX:Number,oriY:Number,w:Number,h:Number) 
		{
			startX = oriX;
			startY = oriY;
			frontBitmapData = makePiece(drawFront, w, h);
			backBitmapData = makePiece(drawBack, w, h);
			createImages(frontBitmapData,backBitmapData);	
		}
		
		public function clone():SlicePiece {
		   var w:Number = frontBitmapData.width;
		   var h:Number = frontBitmapData.height;
		   var copy:SlicePiece = new SlicePiece(frontImage, backImage,startX,startY,w,h);
		   return copy;
		}
		
		private function createImages(front:BitmapData,back:BitmapData):void
		{
			frontImage = new Bitmap(front);
			frontImage.smoothing = true;
			addChild(frontImage);
			//
			backImage = new Bitmap(back);
			backImage.smoothing = true;
			backImage.visible = false;	
			addChild(backImage);
		}
	
		private function makePiece(source:DisplayObject, w:Number, h:Number):BitmapData
		{
			var mat:Matrix = new Matrix();
			mat.translate( -startX, startY);
			var bd:BitmapData = new BitmapData(w, h, true, 0xFF0000);
			bd.draw(source, mat, null, null, null, true);
			return bd;			
		}
		
		public function dispose():void
		{
			frontBitmapData.dispose();
			backBitmapData.dispose();
			frontImage = null;
			backImage = null;
			frontBitmapData = null;
			backBitmapData = null;			
		}
		
		public function get frontBitmapData():BitmapData
		{
		   return _frontData;
		}

		public function set frontBitmapData(source:BitmapData):void
		{
		    _frontData = source.clone();
		}
		
		public function get backBitmapData():BitmapData
		{
		   return _backData;
		}

		public function set backBitmapData(source:BitmapData):void
		{
		    _backData = source.clone();
		}

		public function get frontImage():Bitmap
		{
		   return _frontBitmap;
		}

		public function set frontImage(source:Bitmap):void
		{
		    _frontBitmap = new Bitmap(source.bitmapData.clone());
		}
		
		public function get backImage():Bitmap
		{
		   return _backBitmap;
		}

		public function set backImage(source:Bitmap):void
		{
		    _backBitmap = new Bitmap(source.bitmapData.clone());
		}

		public function get startX():Number
		{
			return _startX;
		}
		
		public function set startX(value:Number):void
		{
			_startX = value;
		}
		
		public function get startY():Number
		{
			return _startY;
		}		
		
		public function set startY(value:Number):void
		{
			_startY = value;
		}
		
		public function get oriMatrix():Matrix
		{
			return _oriMatrix;
		}		
		
		public function set oriMatrix(mat:Matrix):void
		{
			_oriMatrix = mat;
		}
		
		public function show(page:int):void
		{
			if (page === 1) {
				frontImage.visible = true;
				backImage.visible = false;
			}
			if (page === 2) {
				frontImage.visible = false;
				backImage.visible = true;
			}
		}
		
	}//end of class

}