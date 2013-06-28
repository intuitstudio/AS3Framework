package com.intuitStudio.flash3D.concretes
{
	/**
	 * Class LetterA
	 * @author vanier peng , 2003.4.22
	 * 大寫英文字母 A 的3D物件
	 */
	
	import com.intuitStudio.flash3D.core.Polygon;
	import com.intuitStudio.triMotion.core.*;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.MathTools;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	public class LetterA extends Polygon
	{
		public function LetterA()
		{
			super();
		}
		
		/**
		 * 大寫字母 A 的頂點 v.x 平面的索引值陣列
		 *  由兩組頂點集合包含21個頂點，組成43個三角形平面所構成
		 *
		 */
		override public function makePolygon(geo:String, point:Point3d, ... rest):void
		{
			center = point || new Point3d();
			var strategy:Function = null, destVertices:Array = [], destIndices:Array = [], tint:uint, blend:Number;
			
			if (geo === '2d')
			{
				throw new IllegalOperationError('Cube is a kind of 3d mesh.');
			}
			
			if (geo === '3d')
			{
				strategy = create3d;
				size = rest[0];
				tint = rest[1] || 0xFFFF00;
				blend = rest[2] || 1.0;
				var zfront:Number = center.z - size;
				var zback:Number = center.z + size;
				var idx:int = 0;
				
				//create vertices
				//first set
				destVertices[0] = new Point3d(center.x - size, center.y - size * 5, zfront);
				destVertices[1] = new Point3d(center.x + size, center.y - size * 5, zfront);
				destVertices[2] = new Point3d(center.x + size * 4, center.y + size * 5, zfront);
				destVertices[3] = new Point3d(center.x + size * 2, center.y + size * 5, zfront);
				destVertices[4] = new Point3d(center.x + size, center.y + size * 2, zfront);
				destVertices[5] = new Point3d(center.x - size, center.y + size * 2, zfront);
				destVertices[6] = new Point3d(center.x - size * 2, center.y + size * 5, zfront);
				destVertices[7] = new Point3d(center.x - size * 4, center.y + size * 5, zfront);
				destVertices[8] = new Point3d(center.x, center.y - size * 3, zfront);
				destVertices[9] = new Point3d(center.x + size, center.y, zfront);
				destVertices[10] = new Point3d(center.x - size, center.y, zfront);
				//second set
				destVertices[11] = new Point3d(center.x - size, center.y - size * 5, zback);
				destVertices[12] = new Point3d(center.x + size, center.y - size * 5, zback);
				destVertices[13] = new Point3d(center.x + size * 4, center.y + size * 5, zback);
				destVertices[14] = new Point3d(center.x + size * 2, center.y + size * 5, zback);
				destVertices[15] = new Point3d(center.x + size, center.y + size * 2, zback);
				destVertices[16] = new Point3d(center.x - size, center.y + size * 2, zback);
				destVertices[17] = new Point3d(center.x - size * 2, center.y + size * 5, zback);
				destVertices[18] = new Point3d(center.x - size * 4, center.y + size * 5, zback);
				destVertices[19] = new Point3d(center.x, center.y - size * 3, zback);
				destVertices[20] = new Point3d(center.x + size, center.y, zback);
				destVertices[21] = new Point3d(center.x - size, center.y, zback);
				
				for each (var pt:Point3d in destVertices)
				{
					pt.perspective = center.perspective;
				}
				
				var defines:Array = [[0, 1, 8], 
				                    [1, 9, 8], 
							        [1, 2, 9], 
							        [2, 4, 9], 
							        [2, 3, 4], 
							        [4, 5, 9], 
							        [9, 5, 10], 
							        [5, 6, 7], 
							        [5, 7, 10], 
							        [0, 10, 7], 
							        [0, 8, 10], 
							        [11, 19, 12], 
							        [12, 19, 20], 
							        [12, 20, 13], 
							        [13, 20, 15], 
							        [13, 15, 14], 
							        [15, 20, 16], 
							        [20, 21, 16], 
							        [16, 18, 17], 
							        [16, 21, 18], 
							        [11, 18, 21], 
							        [11, 21, 19], 
							        [0, 11, 1], 
							        [11, 12, 1], 
							        [1, 12, 2], 
							        [12, 13, 2], 
							        [3, 2, 14], 
							        [2, 13, 14], 
							        [4, 3, 15], 
							        [3, 14, 15], 
							        [5, 4, 16], 
							        [4, 15, 16], 
							        [6, 5, 17], 
							        [5, 16, 17], 
							        [7, 6, 18], 
							        [6, 17, 18], 
							        [0, 7, 11], 
							        [7, 18, 11], 
							        [8, 9, 19], 
							        [9, 20, 19], 
							        [9, 10, 20], 
							        [10, 21, 20], 
							        [10, 8, 21], 
							        [8, 19, 21]];
				
				//create triangle shapes
				for (var i:int = 0; i < defines.length; i ++)
				{
					//idx = (i<11)?0:(i<22)?1:2;
					strategy(destVertices, defines[i], tint, blend);
				}
			}
		}
	
	} //end of class

}