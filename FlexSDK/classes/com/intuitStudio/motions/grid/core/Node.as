package com.intuitStudio.motions.grid.core
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import com.intuitStudio.motions.biDimens.core.Vector2D;
	import com.intuitStudio.motions.biDimens.tbw.grid.core.Node;

	public class Node
	{
		private var _location:Point;
		private var _evaluate:Vector3D;
		//
		private var _parent:Node;
		private var _walkable:Boolean = true;
		public var costMultiplier:Number = 1.0;

		public function Node (x:int,y:int)
		{
			location = new Point(x,y);
			evaluteCost = new Vector3D();
		}

        public function clone():Node
		{
			var node:Node = new Node(x,y);
			node.parent = _parent;
			node.walkable = _walkable;
			node.costMultiplier = costMultiplier;
			return node;
		}
		
		public function set location (pt:Point):void
		{
			_location = pt;
		}

		public function get location ():Point
		{
			return _location;
		}
		
		public function get x():Number
		{
			return _location.x;
		}
		
		public function get y():Number
		{
			return _location.y;
		}

		public function set evaluteCost (v3:Vector3D):void
		{
			_evaluate = v3;
		}

		public function get evaluteCost ():Vector3D
		{
			return _evaluate;
		}

		public function set f (value:Number):void
		{
			evaluteCost.x = value;
		}

		public function get f ():Number
		{
			return evaluteCost.x;
		}

		public function set g (value:Number):void
		{
			evaluteCost.y = value;
		}

		public function get g ():Number
		{
			return evaluteCost.y;
		}

		public function set h (value:Number):void
		{
			evaluteCost.z = value;
		}

		public function get h ():Number
		{
			return evaluteCost.z;
		}
		
		public function set parent(node:Node):void
		{
			_parent = node;
		}
		
		public function get parent():Node
		{
			return _parent;
		}
		
		public function set walkable(valid:Boolean):void
		{
			_walkable = valid;
		}
		
		public function get walkable():Boolean
		{
			return _walkable;
		}

	}
}