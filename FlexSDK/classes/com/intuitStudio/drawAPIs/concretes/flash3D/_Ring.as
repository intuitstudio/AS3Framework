package com.intuitStudio.drawAPIs.concretes.flash3D
{
	import flash.display.Bitmap;
	import com.intuitStudio.drawAPIs.grid.TriangleGrid;
	import com.intuitStudio.drawAPIs.concretes.flash3D.Cylinder;
    import com.intuitStudio.drawAPIs.concretes.flash3D.RingGrid;
  
	public class Ring extends Cylinder
	{		
		public function Ring (image:Bitmap,grid:SphereGrid=null,showTriangle:Boolean=false)
		{
		    super(image,grid,showTriangle);
		}
		
		override public function defaultGrid ():TriangleGrid
		{
			var gridObj:TriangleGrid = new RingGrid();			
			return doDefaultGrid(gridObj);
		}

	}

}