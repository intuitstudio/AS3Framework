package com.intuitStudio.TBW.builder.abstracts
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.errors.IllegalOperationError;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.BlendMode;
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	
	public class AbstractDisplayBuilder
	{
		protected var _top:DisplayObjectContainer;
		protected var _bitmap:BitmapData;
		protected var _backgroundColor:uint = 0x00000000;
		protected var _wild:int;
		protected var _tall:int;
		protected var _pt:Point;
		protected var _tile:Shape;
		
		public function AbstractDisplayBuilder(top:DisplayObjectContainer)
		{
			_top = top;
			_tile = new Shape();
			_pt = new Point(0,0);
		}
		
		final public function createDisplay ():void
		{
			bitmap = doCreateDisplay();
		}

		final public function getView ():BitmapData
		{
			return bitmap;
		}
		
		final public function get width ():int
		{
			return _wild;
		}
		final public function set width (w:int):void
		{
			_wild = w;
		}

		final public function get height ():int
		{
			return _tall;
		}
		final public function set height (h:int):void
		{
			_tall = h;
		}

		final public function get backgroundColor ():uint
		{
			return _backgroundColor;
		}

		final public function set backgroundColor (bgColor:uint):void
		{
			_backgroundColor = bgColor;
		}

		final public function get bitmap ():BitmapData
		{
			return _bitmap;
		}

		final public function set bitmap (bmpData:BitmapData):void
		{
			_bitmap = bmpData;
		}

		protected function doCreateDisplay ():BitmapData
		{
			return new BitmapData(width,height,true,backgroundColor);
		}

		protected function addTile (dO:DisplayObject,rect:Rectangle):void
		{			
			var sprite:BitmapData = snapShot(dO);			
			_pt.x = rect.x;
			_pt.y = rect.y;
			
			if (rect.width > 0 || rect.height > 0)
			{
				sprite = tile(sprite,rect);
			}

			bitmap.copyPixels (sprite,sprite.rect,_pt,null,null,true);
		}
        
		//parameter multipX,multipY can use to modify thhe area of displayobject,
		protected function snapShot (dO:DisplayObject,multipX:Number=1,multipY:Number=1):BitmapData
		{				
			var snapshot:BitmapData = new BitmapData(dO.width*multipX,dO.height*multipY,true,0);
			var matrix:Matrix = new Matrix();
			matrix.translate (dO.x,dO.y);
			snapshot.draw (dO,matrix,null,BlendMode.NORMAL,null,false);
			
			return snapshot;
		}

		protected function tile (bmpData:BitmapData,area:Rectangle):BitmapData
		{
			
			var _t:Shape = _tile;
			var g:Graphics = _t.graphics;
			g.clear ();
			g.beginBitmapFill (bmpData,null,true,false);
			g.drawRect (0,0,area.width,area.height);
			g.endFill ();

			return snapShot(_t);
		}

	}
	
	
	
	
}