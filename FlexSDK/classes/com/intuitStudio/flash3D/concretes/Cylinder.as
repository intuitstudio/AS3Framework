package com.intuitStudio.flash3D.concretes
{
	/**
	 * Class Cylinder
	 * @author vanier peng , 2003.4.22
	 * 定義圓柱體物件 :
	 * 	@params: 無
	 *  初始化交由函式makePolygon()負責; 圓柱體由兩個底(可省略)跟多個面所組成
	 */
	
	import com.intuitStudio.flash3D.core.Polygon;
	import com.intuitStudio.triMotion.core.*;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.MathTools;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	public class Cylinder extends Polygon
	{
		private var _numFaces:int = 10;
		private var _radius:Number = 10;
		
		public function Cylinder()
		{
			super();
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		public function get numFaces():Number
		{
			return _numFaces;
		}
		
		public function set numFaces(value:Number):void
		{
			_numFaces = value;
		}
		
		/**
		 * 建立圓柱體的頂點和索引值
		 * 原理 : 以XZ平面當做横切面，沿著Y軸擴展成柱狀
		 * 計算公式 : 角度 = (PI*2)/面數*索引
		 *            X座標 = cos*半徑
		 *            Z座標 = sin*半徑
		 * 頂點編號rule :
		 *  idx, idx + 3, idx + 1
		 *  idx, idx + 2, idx + 3
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
				numFaces = rest[0];
				radius = rest[1];
				size = rest[2];
				tint = rest[3] || 0xFFFF00;
				blend = rest[4] || 1.0;
				var dist:Number = size;
				var idx:int = 0;
				
				//以center為中心點所展開的圓柱體的頂點座標
				for (var i:int = 0; i < numFaces; i++)
				{
					var angle:Number = (MathTools.TWOPI / numFaces) * i;
					var rt:Point = Point.polar(radius, angle);
					destVertices[idx] = new Point3d(center.x+rt.x, center.y+rt.y, center.z - dist);
					destVertices[idx + 1] = new Point3d(center.x+rt.x, center.y+rt.y, center.z + dist);
					idx += 2;
				}
				for each (var pt:Point3d in destVertices)
				{
					pt.perspective = center.perspective;
				}
				
				//{type:面,indices:[頂點的排列索引],clockwise:三角形的繪製先後順序}
				var defines:Array = [];
				idx = 0;
				for (i = 0; i < numFaces - 1; i++)
				{
					defines[idx] = [idx, idx + 3, idx + 1];
					defines[idx + 1] = [idx, idx + 2, idx + 3];
					idx += 2;
				}
				defines[idx] = [idx, 1, idx + 1];
				defines[idx + 1] = [idx, 0, 1];
				//create triangle shapes
				for (i = 0; i < defines.length; i += 2)
				{
					strategy(destVertices, defines[i], tint, blend);
					strategy(destVertices, defines[i + 1], tint, blend);
				}
			}
		}
	
	} //end of class

}