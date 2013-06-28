package com.intuitStudio.drawAPIs.grid
{
	import flash.geom.Vector3D;
	import com.intuitStudio.utils.VectorUtils;

	public class TriNode
	{
		protected var _vertices:Vector.<Number > ;//optional
		protected var _uvtData:Vector.<Number > ;//opional
		protected var _indices:Vector.<int > ;
		protected var _location:Vector3D;//node index
		protected var _grid:TriangleGrid;

		public function TriNode (loc:Vector3D,gridObj:TriangleGrid)
		{
			_location = loc;
			_grid = gridObj;
			init ();
		}

		protected function init ():void
		{
			_vertices = new Vector.<Number>();
			_indices = new Vector.<int > ();
			_uvtData = new Vector.<Number>();
			setTriangle (_location,_grid);
		}

		private function resetVertices ():void
		{
			_vertices.length = 0;
			_indices.length = 0;
			_uvtData.length = 0;
		}

		//point(x,y,z) -> (row,col,up/down)
		protected function setTriangle (point:Vector3D,grid:TriangleGrid):void
		{
			resetVertices ();
			
			_vertices.push (point.y*grid.size,point.x*grid.size);
			_uvtData.push (point.y/(grid.columns-1),point.x/(grid.rows-1));
	
			if (point.z == 0)
			{
				_indices.push (point.x*grid.verticesH+point.y,point.x*grid.verticesH+point.y+1,(point.x+1)*grid.verticesH+point.y);
			}
			if (point.z == 1)
			{
				_indices.push (point.x*grid.verticesH+point.y+1,(point.x+1)*grid.verticesH+point.y+1,(point.x+1)*grid.verticesH+point.y);
			}
		}

		//---------- getter / setter ------------;

		public function get x ():int
		{
			return _location.x;
		}

		public function get y ():int
		{
			return _location.y;
		}

		public function get z ():int
		{
			return _location.z;
		}

		public function get vertices ():Vector.<Number > 
		{
			return _vertices;
		}

		public function setIndices (points:Array):void
		{
			_indices = Vector.<int > (VectorUtils.vector2Array(_indices).concat(points));
		}

		public function get indices ():Vector.<int > 
		{
			return _indices;
		}

		public function get uvtData ():Vector.<Number > 
		{
			return _uvtData;
		}

	}

}