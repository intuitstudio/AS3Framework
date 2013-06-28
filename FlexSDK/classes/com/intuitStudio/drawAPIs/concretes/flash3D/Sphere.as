package com.intuitStudio.drawAPIs.concretes.flash3D
{
	import flash.display.Bitmap;
	import com.intuitStudio.drawAPIs.grid.TriangleGrid;
	import com.intuitStudio.drawAPIs.concretes.flash3D.Cylinder;
    import com.intuitStudio.drawAPIs.concretes.flash3D.SphereGrid;
  
	public class Sphere extends Cylinder
	{		
		public function Sphere (image:Bitmap,grid:SphereGrid=null,showTriangle:Boolean=false)
		{
		    super(image,grid,showTriangle);
		}
		
		override public function defaultGrid ():TriangleGrid
		{
			var gridObj:TriangleGrid = new SphereGrid();			
			return doDefaultGrid(gridObj);
		}

	}

}