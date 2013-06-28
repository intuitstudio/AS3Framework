package com.intuitStudio.motions.pathFind
{
	import com.intuitStudio.motions.grid.core.Grid;
	import com.intuitStudio.motions.grid.core.Node;
	import com.intuitStudio.utils.VectorUtils;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.events.Event;

	public class AStar
	{
		public static const DIAGONAL:int = 0;
		public static const EUCLIDAN:int = 1;
		public static const MANHATTAN:int = 2;

		private var _openList:Vector.<Node > ;
		private var _closedList:Vector.<Node > ;
		private var _path:Vector.<Node > ;
		private var _grid:Grid;
		private var _startNode:Node;
		private var _endNode:Node;
		private var _currentNode:Node;

		private var _heuristic:Function = diagonal;
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		private var _checkCorner:Boolean = true;

		public function AStar ()
		{
			_openList = new Vector.<Node>();
			_closedList = new Vector.<Node>();
			_path = new Vector.<Node>();
		}

		public function findPath (map:Grid):Boolean
		{
			_grid = map;
			_openList.length = 0;
			_closedList.length = 0;

			_startNode = _grid.startNode;
			_endNode = _grid.endNode;

			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;

			return search();
		}

		private function getCurrentEdges ():Rectangle
		{
			var edges:Rectangle = new Rectangle();
			edges.left = Math.max(0,_currentNode.x - 1);
			edges.right = Math.min(_grid.columns - 1,_currentNode.x + 1);
			edges.top = Math.max(0,_currentNode.y - 1);
			edges.bottom = Math.min(_grid.rows - 1,_currentNode.y + 1);
			return edges;
		}

		public function search ():Boolean
		{
			//set startNode to be current
			_currentNode = _startNode;
			
			//envaluate looping
			while (_currentNode != _endNode)
			{
				var edgeRect:Rectangle = getCurrentEdges();
				for (var i:int=edgeRect.left; i<=edgeRect.right; i++)
				{
					for (var j:int=edgeRect.top; j<=edgeRect.bottom; j++)
					{
						var node:Node = _grid.getNode(i,j);
						if (! checkEvaluable(node))
						{
							continue;
						}
						else
						{
							if (makeEvaluate(node))
							{
								_openList.push (node);
							}
						}
					}
				}
				//
				_closedList.push (_currentNode);
				if (_openList.length == 0)
				{
					trace ('no path be found!');
					return false;
				}
				//get lowest cost node to be current
				_currentNode = getBestOpenNode();
			}
			//
			bulidPath ();
			return true;
		}

		private function checkEvaluable (node):Boolean
		{
			return !( !canEvaluate(node) || !diagWalkable(node));
		}

		private function canEvaluate (node:Node):Boolean
		{
			return !(node == _currentNode || !node.walkable);
		}

		private function diagWalkable (node:Node):Boolean
		{
			return !(! _grid.getNode(_currentNode.x,node.y).walkable || ! _grid.getNode(node.x,_currentNode.y).walkable);
		}

		private function makeEvaluate (node:Node):Boolean
		{
			var cost:Number = _straightCost;
			if (!((_currentNode.x==node.x)||(_currentNode.y==node.y)))
			{
				cost = _diagCost;
			}
			var evaluator:Vector3D = new Vector3D();
			evaluator.y = _currentNode.g + cost * node.costMultiplier;
			evaluator.z = _heuristic(node);
			evaluator.x = evaluator.y + evaluator.z;

			if (isOpen(node) || isClosed(node))
			{
				if (node.f > evaluator.x)
				{
					node.evaluteCost = evaluator;
					node.parent = _currentNode;
				}
				return false;
			}
			else
			{
				node.evaluteCost = evaluator;
				node.parent = _currentNode;
			}
			return true;
		}

		private function getBestOpenNode ():Node
		{
			_openList = Vector.<Node > (VectorUtils.vector2Array(_openList).sortOn('f',Array.NUMERIC));
			return _openList.shift() as Node;
		}

		private function bulidPath ():void
		{

			_path.length = 0;
			var node:Node = _endNode;
			_path.push (node);
			while (node != _startNode)
			{
				node = node.parent;
				_path.unshift (node);
			}
		}

		public function get path ():Vector.<Node> 
		{
			var clone:Vector.<Node> = new Vector.<Node>();
			if(_path)
			{
			    clone = _path.map(nodeCloner);
			}
			return _path;
		}

		private function isOpen (node:Node):Boolean
		{
			var index:int = VectorUtils.vector2Array(_openList).indexOf(node);
			return !(index==-1);
		}

		private function isClosed (node:Node):Boolean
		{
			var index:int = VectorUtils.vector2Array(_closedList).indexOf(node);
			return !(index==-1);
		}

		private function manhattan (node:Node):Number
		{
			return (Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y + _endNode.y) * _straightCost);
		}

		private function euclidian (node:Node):Number
		{
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return (Math.sqrt(dx * dx + dy * dy) * _straightCost);
		}

		private function diagonal (node:Node):Number
		{
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			var diag:Number = Math.min(dx,dy);
			var straight:Number = dx + dy;
			return (diag*_diagCost + (straight-2*diag)*_straightCost);
		}

		public function get visited ():Vector.<Node > 
		{
			return _closedList.concat(_openList);
		}

		public function setCornerCheck (valid:Boolean):void
		{
			_checkCorner = valid;
		}

		public function setHeuristic (type:int):void
		{
			switch (type)
			{
				case AStar.DIAGONAL :
					_heuristic = diagonal;
					break;
				case AStar.EUCLIDAN :
					_heuristic = euclidian;
					break;
				case AStar.MANHATTAN :
					_heuristic = manhattan;
					break;
				default :
					_heuristic = diagonal;
			}
		}
		
		private function nodeCloner (item:Node, index:int, vector:Vector.<Node>):Node
		{
			return item.clone();
		}		

	}

}