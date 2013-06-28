/*
    GridTriangleBimap class is define a filled Bitmap whose structure is composed by square in pair of little triangles.
	Every triangle has the same width and height.

*/

package com.intuitStudio.drawAPIs.concretes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	import com.intuitStudio.drawAPIs.abstracts.ImageDrawingObject;
	import com.intuitStudio.drawAPIs.grid.TriangleGrid;

	public class GridTriangleBitmap extends ImageDrawingObject
	{
		public function GridTriangleBitmap (image:Bitmap,grid:TriangleGrid=null,showTriangle:Boolean=false)
		{
			super(image,grid,showTriangle);
		}
		
		override public function defaultGrid ():TriangleGrid
		{
			var gridObj:TriangleGrid = new TriangleGrid();
			_defalutGridSize = 200;
			return doDefaultGrid(gridObj);
		}

	}
}