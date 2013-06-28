package com.intuitStudio.flash3D.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.errors.IllegalOperationError;
	
	import com.intuitStudio.utils.Vector3DUtils;
	
	public class Mesh3D 
    { 
	    protected var _vertices:Vector.<Number>;
		protected var _container3D:DisplayObject;
		protected var _vectors:Vector.<Vector3D>;
		protected var _sides:Vector.<int>;
		protected var _uvtData:Vector.<Number>;
		
		public function Mesh3D(container:DisplayObject)
		{
			_container3D = container;
			createMesh();
		}
		
		public function createMesh():void
		{
			doCreateMesh();
		}
		
		protected function doCreateMesh():void
		{
			throw new IllegalOperationError('doCreateMesh must be overridden!');
		}
		
		public function applyTransform(matrix:Matrix3D):void
		{
			_vertices = new Vector.<Number>();
			var vertex:Point;
			var transformedVector:Vector3D;
			for each(var vector:Vector3D in _vectors)
			{
				transformedVector = matrix.deltaTransformVector(vector);
				vertex = Vector3DUtils.spaceToScreen(_container3D as DisplayObjectContainer,transformedVector);
				_vertices.push(vertex.x,vertex.y);
			}
		}
		
		public function get vertices():Vector.<Number>
		{
			return _vertices;
		}
		
		public function get sides():Vector.<int>
		{
			return _sides;
		}
		
		public function get uvtData():Vector.<Number>
		{
			return _uvtData;
		}
		
		
	}
	
	
}