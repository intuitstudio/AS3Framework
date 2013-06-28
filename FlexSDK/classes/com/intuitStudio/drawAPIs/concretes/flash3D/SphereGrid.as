package com.intuitStudio.drawAPIs.concretes.flash3D
{
	import flash.utils.Dictionary;
	import com.intuitStudio.drawAPIs.grid.TriangleGrid;
	import com.intuitStudio.drawAPIs.concretes.flash3D.CylinderGrid;
	import com.intuitStudio.motions.flash3D.core.Point3D;

	public class SphereGrid extends CylinderGrid
	{
		public function SphereGrid (radius:Number=100,cols:int=1,rows:int=1,size:Number=1)
		{
			super (radius,cols,rows,size);
		}

		override public function rotateNodes (speed:Number):int
		{
			resetVertices ();
			rotation +=  speed;
			//(i,j) -> (row,col)
			for (var i:uint=0; i<=_gridSize.y; i++)
			{
				for (var j:uint=0; j<=_gridSize.x; j++)
				{
					var angle:Number = ( (Math.PI*2) / (_gridSize.x) )*j;
					var angle2:Number = (Math.PI*i) / (_gridSize.y) - Math.PI*.5;
					makeVertices (i,j,[angle,angle2]);
				}
			}
			return 0;
		}

		override protected function makeVertices (i:int,j:int,angles:Array):void
		{
			var angle:Number = angles[0];
			var angle2:Number = angles[1];
			var xpos:Number = Math.cos(angle + rotation) * radius * Math.cos(angle2);
			var ypos:Number = Math.sin(angle2) * radius;
			var zpos:Number = Math.sin(angle + rotation) * radius * Math.cos(angle2);

			var scale:Number = getScale(zpos);

			_vertices.push (xpos*scale,ypos*scale);
			_uvtData.push (j/_gridSize.x,i/_gridSize.y);
			_uvtData.push (scale);
		}

	}
}//add t value of uvtData