package com.intuitStudio.drawAPIs.core
{
	import flash.display.Graphics;
	import flash.display.IGraphicsData;
	import flash.display.GraphicsTrianglePath;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsBitmapFill;
	import flash.display.TriangleCulling;
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.intuitStudio.utils.VectorUtils;

	public class TriangleBitmap extends Triangle
	{
		protected var _image:Bitmap;
		protected var _wide:Number;
		protected var _tall:Number;
		protected var _scale:Number;
		protected var _uvtData:Vector.<Number > ;
		protected var _showTriangle:Boolean;
		protected var _culling:String;

		protected var _stroke:GraphicsStroke;
		protected var _graphicsData:Vector.<IGraphicsData > ;
		protected var _trianglesPath:GraphicsTrianglePath;
		protected var _bitmapFill:GraphicsBitmapFill;

		public function TriangleBitmap (image:Bitmap,scale:Number=1.0,saw:Boolean=false)
		{
			_image = image;
			_scale = scale;
			_showTriangle = saw;
			_uvtData = new Vector.<Number>();
			super ();
			init ();
		}

		protected function init ():void
		{
			makeGraphicsDraw ();
			//
			_culling = TriangleCulling.NEGATIVE;
			_wide = _image.bitmapData.width * scale;
			_tall = _image.bitmapData.height * scale;
			makeTriangles ();
		}

		protected function makeGraphicsDraw ():void
		{
			_graphicsData = new Vector.<IGraphicsData>();
			_stroke = new GraphicsStroke();
			_trianglesPath = new GraphicsTrianglePath();
			_bitmapFill = new GraphicsBitmapFill(_image.bitmapData,null,false,true);
		}

		private function makeTrianglesPath ():void
		{
			_trianglesPath.vertices = _vertices;
			_trianglesPath.indices = _indices;
			_trianglesPath.uvtData = _uvtData;
			_trianglesPath.culling = culling;
		}

		protected function makeTriangles ():void
		{
			addPoints ([0,0,wide,0,wide,tall,0,tall]);
			addIndices ([0,1,3]);
			addIndices ([1,2,3]);
			addUVT ([0,0,1,0,1,1,0,1]);
		}

		public function set wide (value:Number):void
		{
			_wide = value;
		}

		public function get wide ():Number
		{
			return _wide;
		}

		public function set tall (value:Number):void
		{
			_tall = value;
		}

		public function get tall ():Number
		{
			return _tall;
		}

		public function set scale (value:Number):void
		{
			_scale = value;
		}

		public function get scale ():Number
		{
			return _scale;
		}

		public function set culling (type:String):void
		{
			_culling = type;
		}

		public function get culling ():String
		{
			return _culling;
		}

		public function addUVT (uvtData:Array):void
		{
			_uvtData = Vector.<Number > (VectorUtils.vector2Array(_uvtData).concat(uvtData));
		}
		
		override protected function doDraw (g:Graphics):void
		{
			g.clear ();
			var blend:Number = (_showTriangle)?1.0:0;
			//
			_graphicsData.length = 0;
			_stroke.fill = new GraphicsSolidFill(0,blend);
			_graphicsData.push (_stroke);
			_graphicsData.push (_bitmapFill);
			makeTrianglesPath ();
			_graphicsData.push (_trianglesPath);
			g.drawGraphicsData (_graphicsData);

		}

		protected function doSimpleDraw (g:Graphics):void
		{
			g.clear ();
			var blend:Number = (_showTriangle)?1.0:0;
			g.lineStyle (0,0,blend);
			g.beginBitmapFill (_image.bitmapData);
			g.drawTriangles (_vertices,_indices,_uvtData,culling);
			g.endFill ();

		}


	}
}