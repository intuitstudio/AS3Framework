package com.intuitStudio.drawAPIs.concretes.flash3D
{
	import flash.display.Bitmap;
	import com.intuitStudio.drawAPIs.abstracts.ImageDrawingObject;
	import com.intuitStudio.drawAPIs.grid.TriangleGrid;
    import com.intuitStudio.drawAPIs.concretes.flash3D.CylinderGrid;
  
	public class Cylinder extends ImageDrawingObject
	{		
		protected var _rollingSpeed:Number = .10;
		
		public function Cylinder (image:Bitmap,grid:CylinderGrid=null,showTriangle:Boolean=false)
		{
		    super(image,grid,showTriangle);
		}
		
		override protected function init():void
		{
			_rollingSpeed = .05;
			super.init();
		}
		
		override public function defaultGrid ():TriangleGrid
		{
			var gridObj:TriangleGrid = new CylinderGrid();			
			return doDefaultGrid(gridObj);
		}
		
        public function set rolling(value:Number):void
		{
			_rollingSpeed = value;
		}
		
		public function get rolling():Number
		{
			return _rollingSpeed;
		}
		 
		override public function update (elapsed:Number=1.0):void
		{
             CylinderGrid(_grid).rotateNodes(rolling*elapsed);
			 makeTriangles();
			 _updateView++;			 
		}		

	}

}