package com.intuitStudio.drawAPIs.concretes.flash3D
{
	import flash.utils.Dictionary;
	import com.intuitStudio.drawAPIs.grid.TriangleGrid;
	import com.intuitStudio.motions.flash3D.core.Point3D;

	public class CylinderGrid extends TriangleGrid
	{
		protected var _radius:Number;
		protected var _perspective:Point3D;//reference 3D point to catch focalLength,center...

		public function CylinderGrid (radius:Number=100,cols:int=1,rows:int=1,size:Number=1)
		{
			_radius = radius;
			super (cols,rows,size);
		}

		override protected function init ():void
		{
			makePerspective ();
			super.init ();
		}

		private function makePerspective ():void
		{
			_perspective = new Point3D();
			_perspective.fl = 250;
			_perspective.center.z = 200;
		}

		protected function getScale (z:Number):Number
		{
			return _perspective.fl / (_perspective.fl+z+_perspective.center.z);
		}

		override public function makeNodes ():void
		{
			rotation = 0;
			rotateNodes(0);
		}
		
		public function rotateNodes(speed:Number):int
		{
			resetVertices();
			rotation += speed;
			for (var i:uint=0; i<=_gridSize.y; i++)
			{
				for (var j:uint=0; j<=_gridSize.x; j++)
				{
					var angle:Number = (Math.PI*2)/ (_gridSize.x)*j + rotation;
                    makeVertices(i,j,[angle]);
				}
			}
			return 0;
		}

		protected function makeVertices (i:int,j:int,angles:Array):void
		{
			var angle:Number = angles[0];
			var xpos:Number = Math.cos(angle) * _radius;
			var ypos:Number = (i-_gridSize.y*.5) * _gridSize.z;
			var zpos:Number = Math.sin(angle) * _radius;

			var scale:Number = getScale(zpos);

			_vertices.push (xpos*scale,ypos*scale);
			_uvtData.push (j/_gridSize.x,i/_gridSize.y);
			_uvtData.push (scale);
		}
		
		//------- interface function  call by external drawin objects ------------ 

		public function setPerspective (data:Dictionary):void
		{
			_perspective.perspective (data);
		}
		
		//---------- getter / setter -------------

		public function get perspective ():Point3D
		{
			return _perspective;
		}

		public function set radius (value:Number):void
		{
			_radius = value;
			_updateView++;
		}

		public function get radius ():Number
		{
			return _radius;
		}	

		
	}
}//add t value of uvtData
