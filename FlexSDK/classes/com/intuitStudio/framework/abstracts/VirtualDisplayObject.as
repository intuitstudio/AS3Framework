/*
    VirtualDisplayObject class is non DisplayObject but own similar behaviors of displayObject ,such width ,height,x,y,z....
*/
package com.intuitStudio.framework.abstracts
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;

	import flash.geom.Matrix;
	import flash.geom.Vector3D;

	import flash.errors.IllegalOperationError;

	public class VirtualDisplayObject
	{
		protected var _instance:Sprite;
		protected var _shape:Shape;
		protected var _canvas:Bitmap;
		protected var _wide:Number;
		protected var _tall:Number;
		protected var _location:Vector3D;
		protected var _updateView:int = 0;
		protected var _updateSize:int = 0;
		protected var _sketchPad:Graphics;

		public function VirtualDisplayObject (w:Number,h:Number)
		{
			_wide = w;
			_tall = h;
			init ();
		}

		protected function init ():void
		{
			makeInstance ();
			makeCanvas ();
		}

		protected function makeInstance ():void
		{
			_instance = new Sprite();
			_shape = new Shape();
			_instance.addChild (_shape);
		}

		protected function makeCanvas ():void
		{
			_canvas = new Bitmap(new BitmapData(width,height,true,0x00000000));			
		}

		private function get defaultGraphics ():Graphics
		{
			return _shape.graphics;
		}

		public function set drawGraphics (g:Graphics):void
		{
			_sketchPad = g;
		}
		 
		public function get instance():Sprite
		{
			return _instance;
		}
		
		public function set filters(filters:Array):void
		{
			_instance.filters = filters;
		}

		public function set width (value:Number):void
		{
			_wide = value;
			_updateSize++;
		}

		public function get width ():Number
		{
			return _wide;
		}

		public function set height (value:Number):void
		{
			_tall = value;
			_updateSize++;
		}

		public function get height ():Number
		{
			return _tall;
		}

		public function set location (loc:Vector3D):void
		{
			_location = loc;
			_updateView++;
		}

		public function get location ():Vector3D
		{
			return _location;
		}

		public function set x (value:Number):void
		{
			_location.x = value;
			_updateView++;
		}

		public function get x ():Number
		{
			return _location.x;
		}

		public function set y (value:Number):void
		{
			_location.y = value;
			_updateView++;
		}

		public function get y ():Number
		{
			return _location.y;
		}

		public function set z (value:Number):void
		{
			_location.z = value;
			_updateView++;
		}

		public function get z ():Number
		{
			return _location.z;
		}
		
		public function updateView(value:int=1):void
		{
			(value==1)?_updateView++:_updateView=0;			
		}
		
		public function updateSize(value:int=1):void
		{
			(value==1)?_updateSize++:_updateSize=0;	
		}
		
		public function cleanCanvas():void
		{
			_canvas.bitmapData.fillRect (_canvas.bitmapData.rect,0);
		}

		public function update (elapsed:Number = 1.0):void
		{
			throw new IllegalOperationError('render must be overridden by inheristed classes');
		}

		public function render ():void
		{
			throw new IllegalOperationError('render must be overridden by inheristed classes');
		}

		public function draw (g:Graphics=null):void
		{
			g = (_sketchPad==null)?defaultGraphics:_sketchPad;
			doDraw (g);
		}

		//override by sub classes in need
		protected function doDraw (g:Graphics):void
		{
			copyDrawnToCanvas ();

			g.clear ();
			g.beginBitmapFill (_canvas.bitmapData);
			g.drawRect (x,y,width,height);
			g.endFill ();
		}

		protected function copyDrawnToCanvas ():void
		{
			cleanCanvas();
			_canvas.bitmapData.draw (_instance);
		}

	}

}