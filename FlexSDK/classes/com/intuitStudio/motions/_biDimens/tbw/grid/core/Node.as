package com.intuitStudio.motions.biDimens.tbw.grid.core
{
	import com.intuitStudio.motions.biDimens.core.Vector2D;
	
	public class Node
	{
		private  var _location:Vector2D;
        //cost
		public var f:Number;
		public var g:Number;
		public var h:Number;
		//
		public var walkable:Boolean = true;
		public var parent:Node;
		public var costMultiplier:Number = 1.0;

	    public function Node(x:int,y:int)
		{
			location = new Vector2D(x,y);
		}
		
		public function set location(v2:Vector2D):void
		{
			_location = v2;
		}
		
	    public function get location():Vector2D
		{
			return _location;
		}
	}
}