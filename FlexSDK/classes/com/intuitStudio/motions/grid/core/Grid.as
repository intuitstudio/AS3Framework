/*
   grid class is used to make a wrold,which is divided by a group of tiles with same size.
*/

package com.intuitStudio.motions.grid.core
{
	import flash.geom.Point;
	import com.intuitStudio.motions.biDimens.tbw.grid.core.Node;

	public class Grid
	{
		private var _gridSize:Point;
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Vector.<Node > ;

		public function Grid (cols:int,rows:int)
		{
			_gridSize = new Point(cols,rows);
			init ();
		}

		private function init ():void
		{
			_nodes = new Vector.<Node>();
			//allocate memory ready to use ,but lazy initialized
			_nodes.length = columns * rows;
		}

		public function getNode (x:int,y:int):Node
		{			
			return _nodes[checkNode(x,y)] as Node;
		}

		public function setEndNode (x:int,y:int):void
		{
			_endNode = _nodes[checkNode(x,y)] as Node;
		}

		public function setStartNode (x:int,y:int):void
		{
			_startNode = _nodes[checkNode(x,y)] as Node;
		}

		public function setWalkable (x:int,y:int,valid:Boolean):void
		{
			_nodes[checkNode(x,y)].walkable = valid;
		}

		public function get startNode ():Node
		{
			return _startNode;
		}

		public function get endNode ():Node
		{
			return _endNode;
		}

		public function get columns ():int
		{
			return _gridSize.x;
		}

		public function get rows ():int
		{
			return _gridSize.y;
		}

		public function getIndex (x:int,y:int):int
		{
			return y*columns+x;
		}

		private function checkNode (x:int,y:int):int
		{
			var index:int = y*columns + x;
			if (_nodes[index] == null)
			{
				_nodes[index] = new Node(x,y);
			}
			return index;
		}
	}
}