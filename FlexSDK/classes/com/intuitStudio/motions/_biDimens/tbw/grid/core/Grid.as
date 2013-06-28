package com.intuitStudio.motions.biDimens.tbw.grid.core
{
	public class Grid
	{
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Vector.<Node>;
		private var _numCols:int;
		private var _numRows:int;
		
		public function Grid(cols:int,rows:int)
		{
			_numCols = cols;
			_numRows = rows;
			init();
		}
		
		private function init():void
		{
			_nodes = new Vector.<Node>();
			
			for(var i:int=0;i<_numCols;i++)
			{
				for(var j:int=0;j<_numRows;j++)
				{
					_nodes[getIndex(i,j)] = new Node(i,j);					
				}				
			}
		}
		
		public function getNode(x:int,y:int):Node
		{
			return _nodes[getIndex(x,y)] as Node;
		}
		
		public function setEndOne(x:int,y:int):void
		{	
			_endNode = _nodes[getIndex(x,y)] as Node;
		}
		
		public function setStartOne(x:int,y:int):void
		{			
			_startNode = _nodes[getIndex(x,y)] as Node;
		}
		
		public function setWalkable(x:int,y:int,valid:Boolean):void
		{
			_nodes[getIndex(x,y)].walkable = valid;
		}
		
		public function get startOne():Node
		{
			return _startNode;
		}
		
		public function get endOne():Node
		{
			return _endNode;
		}
		
		public function get cols():int
		{
			return _numCols;
		}
	    
		public function get rows():int
		{
			return _numRows;
		}
		
		public function getIndex(x:int,y:int):int
		{
			return y*cols+x;
		}	  
		
	}	
}