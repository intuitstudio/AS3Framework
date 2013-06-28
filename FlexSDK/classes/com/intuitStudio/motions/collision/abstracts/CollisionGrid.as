package com.intuitStudio.motions.collision.abstracts
{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.display.Graphics;

	public class CollisionGrid extends EventDispatcher
	{
		private var _checks:Vector.<DisplayObject> ;
		private var _grid:Vector.<Vector.<DisplayObject > > ;
		private var _gridSize:Number;
		private var _tall:Number;
		private var _wild:Number;
		private var _numCells:int;
		private var _numCols:int;
		private var _numRows:int;

		public function CollisionGrid (wild:Number,tall:Number,gridsize:Number)
		{
			_wild = wild;
			_tall = tall;
			_gridSize = gridsize;
			
			init ();
		}

		private function init ():void
		{
			_numCols = Math.ceil(_wild / _gridSize);
			_numRows = Math.ceil(_tall / _gridSize);
			_numCells = _numCols * _numRows;
		}
		
		public function get checks():Vector.<DisplayObject>
		{
			return _checks;
		}

		public function drawGrid (graphics:Graphics):void
		{
			graphics.lineStyle (0,.5);
			for (var i:uint=0; i<_wild; i+=_gridSize)
			{
				graphics.moveTo (i,0);
				graphics.lineTo (i,_tall);
			}
			for (i=0; i<_tall; i+=_gridSize)
			{
				graphics.moveTo (0,i);
				graphics.lineTo (_wild,i);
			}
		}

		public function check (objects:Vector.<DisplayObject>):void
		{
			var numObjects:int = objects.length;
			_grid = new Vector.<Vector.<DisplayObject > > (_numCells);
			_checks = new Vector.<DisplayObject>();
			//
			
			for (var i:uint=0; i<numObjects; i++)
			{
				var object:DisplayObject = objects[i];
				//use one dimenstion numbe to replace to two dimenstion array
				var index:int = Math.floor(object.y / _gridSize) * _numCols + Math.floor(object.x / _gridSize);

				if (_grid[index] == null)
				{
					_grid[index] = new Vector.<DisplayObject>();
				}
				_grid[index].push (object);
			}
			//
			checkGrid ();
		}

		private function checkGrid ():void
		{
			for (var i:uint=0; i<_numCols; i++)
			{
				for (var j:uint=0; j<_numRows; j++)
				{
					checkOneCell (i,j);
					checkTwoCells (i,j,i+1,j);
					checkTwoCells (i,j,i-1,j+1);
					checkTwoCells (i,j,i,j+1);
					checkTwoCells (i,j,i+1,j+1);
				}
			}
		}

		private function checkOneCell (col:Number,row:Number):void
		{
			var cell:Vector.<DisplayObject >  = _grid[row * _numCols + col];
			if (cell == null)
			{
				return;
			}

			var cellLength:int = cell.length;
			for (var i:uint=0; i<cellLength-1; i++)
			{
				var obj0:DisplayObject = cell[i] as DisplayObject;
				for (var j:uint=i+1; j<cellLength; j++)
				{
					var obj1:DisplayObject = cell[j] as DisplayObject;
					_checks.push (obj0,obj1);
				}
			}
		}

		private function checkTwoCells (col0:int,row0:int,col1:int,row1:int):void
		{
			if (col1 >= _numCols || row1 < 0 || row1 >= _numRows)
			{
				return;
			}
			var cellA:Vector.<DisplayObject >  = _grid[row0 * _numCols + col0];
			var cellB:Vector.<DisplayObject >  = _grid[row1 * _numCols + col1];
			if (cellA == null || cellB == null)
			{
				return;
			}
			var cellLengthA:int = cellA.length;
			var cellLengthB:int = cellB.length;
			for(var i:uint=0;i<cellLengthA;i++)
			{
				var objA:DisplayObject  = cellA[i];
				for(var j:uint=0;j<cellLengthB;j++)
				{
					var objB:DisplayObject = cellB[j];
					_checks.push(objA,objB);
				}
			}
		}

	}
}