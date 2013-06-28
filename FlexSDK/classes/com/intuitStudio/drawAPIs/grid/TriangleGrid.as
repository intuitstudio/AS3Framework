package com.intuitStudio.drawAPIs.grid
{
	import flash.geom.Vector3D;
	import com.intuitStudio.drawAPIs.grid.TriNode;
	import com.intuitStudio.utils.VectorUtils;

	public class TriangleGrid
	{
		protected var _gridSize:Vector3D;
		protected var _nodes:Vector.<TriNode > ;
		protected var _vertices:Vector.<Number > ;
		protected var _indices:Vector.<int > ;
		protected var _uvtData:Vector.<Number > ;
		protected var _updateSize:int = 0;//chande the grid structure (columns or rows) to recalculate new triangles 
		protected var _updateView:int = 0;//just change the grid size to recalculate vertices,uvtData,the indices are same.
		protected var _rotation:Number = 0;
		protected var _autoScale:Boolean = false;

		public function TriangleGrid (cols:int=1,rows:int=1,size:Number=1,autoScale:Boolean=true)
		{
			_gridSize = new Vector3D(cols,rows,size);
			_autoScale = autoScale;
			init ();
		}

		protected function init ():void
		{
			_vertices = new Vector.<Number>();
			_indices = new Vector.<int>();
			_uvtData = new Vector.<Number >   ;
			_nodes = new Vector.<TriNode>();
			_updateSize = 0;
			_updateView = 0;
		}

		protected function resetVertices ():void
		{
			_vertices.length = 0;
			_uvtData.length = 0;
		}

		public function makeNodes ():void
		{
			resetVertices ();
			//(i,j) -> (row ,col) 
			for (var i:uint=0; i<=_gridSize.y; i++)
			{
				for (var j:uint=0; j<=_gridSize.x; j++)
				{
					_vertices.push (j*_gridSize.z,i*_gridSize.z);
					_uvtData.push (j/_gridSize.x,i/_gridSize.y);
				}
			}
		}

		// if grid is no changed , then there is only done once.
		protected function makeIndices ():void
		{
			for (var i:uint=0; i<=_gridSize.y; i++)
			{
				for (var j:uint=0; j<=_gridSize.x; j++)
				{
					if (i < _gridSize.y && j < _gridSize.x)
					{
						_nodes[getNodeIndex(i,j,0)] = makeTriNode(i,j,0);
						_nodes[getNodeIndex(i,j,1)] = makeTriNode(i,j,1);
					}
				}
			}
		}

		// verticesH and verticesV is used to calculate the correct indices of grid vertices. 
		public function get verticesH ():int
		{
			return _gridSize.x+1;

		}
		public function get verticesV ():int
		{
			return _gridSize.y+1;
		}

		protected function getIndex (x:int,y:int):int
		{
			return x*columns+y;
		}

		protected function getNodeIndex (x:int,y:int,z:int):int
		{
			return 2*(x*columns+y)+z;
		}

		private function checkNode (x:int,y:int,z:int):int
		{
			var index:int = getNodeIndex(x,y,z);
			if (_nodes[index] == null)
			{
				_nodes[index] = makeTriNode(x,y,z);
			}
			return index;
		}

		protected function makeTriNode (x:int,y:int,z:int):TriNode
		{
			var loc:Vector3D = new Vector3D(x,y,z);
			var node:TriNode = new TriNode(loc,this);
			return node;
		}

		//------- interface function  call by external drawin objects ------------ 
		// interface call by drawing objects
		public function calculateTriangles ():void
		{
			makeNodes ();
			makeIndices ();
		}

		public function getNode (x:int,y:int,z:int):TriNode
		{
			return _nodes[checkNode(x,y,z)] as TriNode;
		}

		public function update ():void
		{
			if (_updateSize > 0)
			{
				_indices.length = 0;
				calculateTriangles ();
				_updateSize = 0;
			}
			if (_updateView > 0)
			{
				makeNodes ();
				_updateView = 0;
			}
		}

		public function clone ():TriangleGrid
		{
			var copy:TriangleGrid = new TriangleGrid(columns,rows,size);
			copy._vertices = vertices;
			copy._indices = indices;
			copy._uvtData = uvtData;
			return copy;
		}

		public function toString ():String
		{
			return "[ TriangleGrid : " + " columns (" + columns + "), rows ("+ rows + "), size (" + size +") ]";
		}

		//-------- getter / setter  ----------------------
		public function get vertices ():Vector.<Number > 
		{
			return _vertices;
		}

		public function get indices ():Vector.<int > 
		{
			if (_indices.length == 0)
			{
				for (var i:uint=0; i<_nodes.length; i++)
				{
					var node:TriNode = _nodes[i] as TriNode;
					_indices = Vector.<int > (VectorUtils.vector2Array(_indices).concat(VectorUtils.vector2Array(node.indices)));
				}
			}
			return _indices;
		}

		public function get uvtData ():Vector.<Number > 
		{
			return _uvtData;
		}

		public function set size (value:Number):void
		{
			_gridSize.z = value;
			_updateView++;
		}

		public function get size ():Number
		{
			return _gridSize.z;
		}

		public function set columns (value:int):void
		{
			_gridSize.x = value;
			_updateSize++;
		}

		public function get columns ():int
		{
			return _gridSize.x;
		}

		public function set rows (value:int):void
		{
			_gridSize.y = value;
			_updateSize++;
		}

		public function get rows ():int
		{
			return _gridSize.y;
		}
		
		public function set rotation(value:Number):void
		{
			_rotation = value;
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function get autoScale():Boolean
		{
			return _autoScale;
		}

	}

}