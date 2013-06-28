/*
   ImageDrawingObject : use drawTriangle() API to create image-filled graphic objects, which can free transform ,distort , 
                        especially draw flash 3D Object.

*/
package com.intuitStudio.drawAPIs.abstracts
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.IGraphicsData;
	import flash.display.GraphicsStroke;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.drawAPIs.core.TriangleBitmap;
	import com.intuitStudio.drawAPIs.grid.TriangleGrid;

	public class ImageDrawingObject extends TriangleBitmap
	{
		protected var _cloumns:int;
		protected var _rows:int;
		protected var _grid:TriangleGrid;
		protected var _instance:Sprite;
		protected var _shape:Shape;
		protected var _location:Point;
		protected var _updateView:int;
		protected var _updateSize:int;
		protected var _defalutGridSize:Number = 50;
		protected var _canvasGraphics:Graphics;

		public function ImageDrawingObject (image:Bitmap,gridObj:TriangleGrid=null,showTriangle:Boolean=false)
		{
			_image = image;
			var scale:Number = makeGrid(gridObj);
			super (image,scale,showTriangle);
		}

		override protected function init ():void
		{
			makeInstance ();
			_grid.calculateTriangles ();
			_updateSize = 0;
			_updateView = 1;
			_location = new Point();
			super.init ();
		}

		private function makeGrid (gridObj:TriangleGrid):Number
		{
			var scale:Number = 1.0;
			if (gridObj == null)
			{
				_grid = defaultGrid();
			}
			else
			{
				_grid = gridObj;
				scale = calculateZoom();
			}
			return scale;
		}

		private function makeInstance ():void
		{
			_instance = new Sprite();
			_shape = new Shape();
			_instance.addChild (_shape);
		}

		private function calculateZoom ():Number
		{
			if (_grid.autoScale)
			{
				var w0:Number = _image.bitmapData.width;
				var h0:Number = _image.bitmapData.height;
				var w1:Number = _grid.columns * _grid.size;
				var h1:Number = _grid.rows * _grid.size;
				return Math.min(w1/w0,h1/h0);

			}
			else
			{
               return 1.0;
			}
		}

		private function adjustSize ():void
		{
			_scale = calculateZoom();
			_grid.calculateTriangles ();
			wide = _grid.columns * _grid.size;
			tall = _grid.rows * _grid.size;
			makeTriangles ();
		}

		//get vertices,indices,uvtData information from grid object
		override protected function makeTriangles ():void
		{
			_vertices = _grid.vertices;
			_indices = _grid.indices;
			_uvtData = _grid.uvtData;
		}

		//---------  getter / setter --------------------
		public function get instance ():Sprite
		{
			return _instance;
		}

		public function set grid (value:TriangleGrid):void
		{
			_grid = value;
			_updateSize++;
		}

		public function get grid ():TriangleGrid
		{
			return _grid;
		}

		//columns of grid is same , but size will change
		override public function set wide (value:Number):void
		{
			_wide = value;
			_grid.size = Math.round(_wide / _grid.columns);
			_tall = _grid.rows * _grid.size;
			_updateSize++;
		}
		//rows of grid is same , but size will change
		override public function set tall (value:Number):void
		{
			_tall = value;
			_grid.size = Math.round(_wide / _grid.rows);
			_wide = _grid.columns * _grid.size;
			_updateSize++;
		}

		public function set location (loc:Point):void
		{
			_location = loc;
			_updateView++;
		}

		public function get location ():Point
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

		public function set canvas (data:Graphics):void
		{
			_canvasGraphics = data;
		}

		public function get canvas ():Graphics
		{
			if (_canvasGraphics == null)
			{
				_canvasGraphics = _shape.graphics;
			}
			return _canvasGraphics;
		}

		//---------- abstract function ------------------ 
		//abstract function overrided by sub class
		public function defaultGrid ():TriangleGrid
		{
			var gridObj:TriangleGrid = new TriangleGrid();
			return doDefaultGrid(gridObj);
		}

		protected function doDefaultGrid (gridObj:TriangleGrid):TriangleGrid
		{
			var w:Number = _image.bitmapData.width;
			var h:Number = _image.bitmapData.height;
			gridObj.columns = Math.floor(w / _defalutGridSize);
			gridObj.rows = Math.floor(h / _defalutGridSize);
			gridObj.size = _defalutGridSize;
			return gridObj;
		}

		// abstract function , override by sub class in need
		public function update (elapsed:Number=1.0):void
		{

		}

		//sub class can override the render method by self
		public function render ():void
		{
			if (_updateSize > 0)
			{
				adjustSize ();
				_updateSize = 0;
			}

			if (_updateView > 0)
			{
				instance.x = x;
				instance.y = y;
				draw (canvas);
				_updateView = 0;
			}
		}

	}
}