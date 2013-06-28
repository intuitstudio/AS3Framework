package com.intuitStudio.flash3D.abstracts
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Vector3D;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	import com.intuitStudio.drawAPIs.concretes.Painter;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.Vector3DUtils;


	public class AbstractPolygon extends TriDimensContainer
	{
		public static var LightDirection:Vector3D = new Vector3D(0,0,1);
		protected var _facePlanes:Vector.<Sprite > ;
		protected var _faceColor:uint = 0x9900FF;
		protected var _vertices:Vector.<Vector3D>;
		protected var _painter:Painter;

		public function AbstractPolygon (container:DisplayObjectContainer,vanishingPoint:Point=null)
		{
			super(container,vanishingPoint);
		}

		override protected function init ():void
		{
			_painter = new Painter();
			_vertices = new Vector.<Vector3D>();
			makePolygon();
		}

		public function makePolygon ():void
		{
			doMakePolygon ();
		}

		protected function createPolygonVertices ():int
		{
			throw new IllegalOperationError('createPolygonVertices must be overridden');
			return 0;
		}

		protected function drawingPolygon ():void
		{
			throw new IllegalOperationError('drawingPolygon must be overridden');
		}

		protected function doMakePolygon ():void
		{
			createPolygonVertices ();
			drawingPolygon ();
		}

		public function get2DPoints (disp:DisplayObject,vertices:Vector.<Vector3D>):Vector.<Point > 
		{
			var points:Vector.<Point> = new Vector.<Point>();
			var point:Point;
			for each (var vector:Vector3D in vertices)
			{
				points.push (Vector3DUtils.spaceToScreen(_container,vector));
			}
			return points;
		}

		public function getFaceColor (vertices:Vector.<Vector3D>):uint
		{
			var angle:Number = Vector3DUtils.angleAgainstLight(vertices,LightDirection);
			var brightness:Number = angle / Math.PI;
			return ColorUtils.darker(_faceColor,brightness);
		}

        public function get container():DisplayObjectContainer
		{
			return _container;
		}

	}

}