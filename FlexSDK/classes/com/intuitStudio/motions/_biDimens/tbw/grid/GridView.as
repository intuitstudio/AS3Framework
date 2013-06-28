package com.intuitStudio.motions.biDimens.tbw.grid
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import com.intuitStudio.motions.biDimens.tbw.grid.core.Grid;
	import com.intuitStudio.motions.pathFind.AStar;

	public class GridView extends Sprite
	{
		private var cellSize:Number = 20;
		protected var gridData:Grid;
		protected var path:Vector.<Node>;

		public function GridView (value:Grid)
		{
			gridData = value;
			init ();
		}

		protected function init ():void
		{
			search ();
			addEventListener (MouseEvent.CLICK,onGridClick);
		}

		public function search ():void
		{
			path = new Vector.<Node>();
			draw ();
			findPath ();
		}

		protected function draw ():void
		{
			graphics.clear ();
			for (var i:int=0; i<grid.cols; i++)
			{
				for (var j:int=0; j<grid.rows; j++)
				{
					var node:Node = grid.getNode(i,j);
					var color:int = getColor(node);
					drawNode (node,color);
				}
			}
		}

		private function drawNode (node:Node,color:int,shape:String='square'):void
		{
			graphics.lineStyle (0);
			graphics.beginFill (color);
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

		public function findPath ():void
		{
			var astar:AStar = new AStar();
			if (astar.findPath(grid))
			{
				showVisited (astar);
				showPath (astar);
			}
		}

		protected function showVisited (value:AStar):void
		{
			var visited:Vector.<Node> = value.visited;
			for (var i:int=0; i<visited.length; i++)
			{
				var node:Node = visited[i];
				var color:int = 0xffcc00;
				drawNode (node,color);
			}
		}

		protected function showPath (value:AStar):void
		{
			var path:Vector.<Node> = value.route;
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
			if (node == grid.startOne)
			{
				return 0x006666;
			}
			if (node == grid.endOne)
			{
				return 0x666600;
			}
			return 0xcccccc;
		}

		protected function onGridClick (e:MouseEvent):void
		{
			var px:Number = Math.floor(e.localX / size);
			var py:Number = Math.floor(e.localY / size);

			grid.setWalkable (px,py,!grid.getNode(px,py).walkable);
			search ();
		}
		
		public function set size(value:Number):void
		{
			cellSize = value;
		}
		
		
		public function get size():Number
		{
			return cellSize;
		}
        
		public function get grid():Grid
		{
			return gridData;
		}


	}

}