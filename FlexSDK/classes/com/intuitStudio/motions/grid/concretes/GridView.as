package com.intuitStudio.motions.grid.concretes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import com.intuitStudio.motions.grid.core.Grid;
	import com.intuitStudio.motions.grid.core.Node;
	import com.intuitStudio.motions.pathFind.AStar;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.motions.triDimens.isometric.IsoUtils;
	import flash.geom.Vector3D;
	import flash.geom.Point;

	public class GridView extends Sprite
	{
		protected var _size:Number = 20;
		protected var _grid:Grid;
		protected var _path:Vector.<Node > ;
		protected var _hitPoint:Vector3D;

		public function GridView (data:Grid)
		{
			grid = data;
			init ();
		}

		protected function init ():void
		{
			_path = new Vector.<Node>();
			draw ();
			addEventListener (MouseEvent.CLICK,onGridClick);
		}

		public function search ():Boolean
		{
			_path.length = 0;
			draw ();
			return findPath ();
		}

		protected function draw ():void
		{
			graphics.clear ();
			for (var i:int=0; i<grid.columns; i++)
			{
				for (var j:int=0; j<grid.rows; j++)
				{
					var node:Node = grid.getNode(i,j);
					var color:int = getColor(node);
					drawNode (node,color);
				}
			}
		}

		protected function drawNode (node:Node,color:int,shape:String='square'):void
		{
			graphics.lineStyle (0);
			graphics.beginFill (color);
			var size:Number = cellSize;
			if (shape == 'square')
			{
				graphics.drawRect (node.x*size,node.y*size,size,size);
			}
			else
			{
				graphics.drawCircle (node.x*size+size*.5,node.y*size+size*.5,size*.5);
			}
			graphics.endFill ();
		}

		public function set path (route:*):void
		{
			if (route)
			{
				_path = route as Vector.<Node > ;
			}
		}

		public function get path ():Vector.<Node > 
		{
			return _path;
		}


		public function findPath ():Boolean
		{
			var astar:AStar = new AStar();
            var res:Boolean = astar.findPath(grid);
			if (res)
			{
				//path = VectorUtils.clone(astar.path);
				path  = astar.path;				
				showVisited (astar);
				showPath (astar);
			}
			return res;
		}

		protected function showVisited (value:AStar):void
		{
			var visited:Vector.<Node >  = value.visited;
			for (var i:int=0; i<visited.length; i++)
			{
				var node:Node = visited[i];
				var color:int = 0xffcc00;
				drawNode (node,color);
			}
		}

		protected function showPath (value:AStar):void
		{
			for (var i:int=0; i<path.length; i++)
			{
				var node:Node = path[i];
				var color:int = 0x00ffee;
				drawNode (node,color,'circle');
			}
		}

		public function getColor (node:Node):uint
		{
			if (! node.walkable)
			{
				return 0x000000;
			}
			if (node == grid.startNode)
			{
				return 0x006666;
			}
			if (node == grid.endNode)
			{
				return 0x666600;
			}
			return 0xcccccc;
		}

		protected function onGridClick (e:MouseEvent):void
		{
			var loc:Point = IsoUtils.screenToIndex(new Point(e.localX,e.localY),cellSize);
			grid.setWalkable (loc.x,loc.y,!grid.getNode(loc.x,loc.y).walkable);
			search ();
		}

		public function set cellSize (value:Number):void
		{
			_size = value;
		}


		public function get cellSize ():Number
		{
			return _size;
		}

		public function set grid (value:Grid):void
		{
			_grid = value;
		}

		public function get grid ():Grid
		{
			return _grid;
		}

		private function nodeCloner (item:Node, index:int, vector:Vector.<Node>):Node
		{
			return item.clone();
		}

        public function get hitPoint():Vector3D
		{
			return _hitPoint;
		}
		


	}
}