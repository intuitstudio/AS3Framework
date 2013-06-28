package com.intuitStudio.flash3D.concretes
{
	
	/**
	 * Class Cube
	 * @author vanier peng , 2003.4.22
	 * 定義立方體物件 :
	 * 	@params: 無
	 *  初始化交由函式makePolygon()負責; 立方體由六個正方形(12個三角形)所組成
	 *
	 */
	
	import adobe.utils.CustomActions;
	import com.intuitStudio.flash3D.core.Polygon;
	import com.intuitStudio.triMotion.core.*;
	import com.intuitStudio.utils.ColorUtils;
	import flash.errors.IllegalOperationError;
	
	public class Cube extends Polygon
	{
		public static const FRONT:int = 0;
		public static const TOP:int = 1;
		public static const BACK:int = 2;
		public static const BOTTOM:int = 3;
		public static const RIGHT:int = 4;
		public static const LEFT:int = 5;
		
		private var isOnePiece:Boolean = false;
		
		public function Cube(isOne:Boolean=false)
		{
			super();
			isOnePiece = isOne;
		}
		
		/**
		 * 立方體頂點 V.S 面繪製索引值
		 * 立方體共有6個點以及六個面組成(12個三角形)；
		 * 頂點排列順序:以觀者角度決定，前四點為0,1,2,3,後四點為4,5,6,7，組成平面結構如下：
		 * Front: [0,1,2,3] -> 三角形 [0,1,2],[0,2,3] -> clockwise
		 * Top: [0,4,5,1] -> 三角形 [0,4,5],[0,5,1] -> clockwise
		 * Back: [4,5,6,7] -> 三角形 [4,6,5],[4,7,6] -> counterclock
		 * Bottom :[3,2,6,7] -> 三角形 [3,2,6],[3,6,7]-> counterclock
		 * Right: [1,5,6,4] -> 三角形 [1,5,6],[1,6,4]-> clockwise
		 * Left: [0,3,7,4] -> 三角形 [0,3,7],[0,7,4]-> counterclock
		 * 註:實際上頂點可以有不同的排列組合，上述的排列方式的優點是符合backface culling的原則
		 */
		override public function makePolygon(geo:String, point:Point3d, ... rest):void
		{
			center = point || new Point3d();
			
			var strategy:Function = null, destVertices:Array = [], destIndices:Array = [], tint:uint, blend:Number;
			
			if ( geo === '2d')
			{
			    throw new IllegalOperationError('Cube is a kind of 3d mesh.');				
			}
			
			if (geo === '3d')
			{
				strategy = create3d;
				size = rest[0];
				tint = rest[1] || 0xFFFF00;
				blend = rest[2] || 1.0;
				//
				var dist:Number = size >> 1;
				//以center為中心點所展開的立方體的8個頂點座標
				//front points
				destVertices[0] = new Point3d(center.x - dist, center.y - dist, center.z - dist);
				destVertices[1] = new Point3d(center.x + dist, center.y - dist, center.z - dist);
				destVertices[2] = new Point3d(center.x + dist, center.y + dist, center.z - dist);
				destVertices[3] = new Point3d(center.x - dist, center.y + dist, center.z - dist);
				//back points
				destVertices[4] = new Point3d(center.x - dist, center.y - dist, center.z + dist);
				destVertices[5] = new Point3d(center.x + dist, center.y - dist, center.z + dist);
				destVertices[6] = new Point3d(center.x + dist, center.y + dist, center.z + dist);
				destVertices[7] = new Point3d(center.x - dist, center.y + dist, center.z + dist);
				
			    for each(var pt:Point3d in destVertices) {
				   pt.perspective = center.perspective;				   
			    }
				
                //{type:面,indices:[頂點的排列索引],clockwise:三角形的繪製先後順序}
		        var defines:Array = [{type:Cube.FRONT,indices:[0,1,2,3],clockwise:true},
		                       {type:Cube.TOP,indices:[0,4,5,1],clockwise:false},
					           {type:Cube.BACK,indices:[4,7,6,5],clockwise:false},
			                   {type:Cube.BOTTOM,indices:[3,2,6,7],clockwise:true},
						       {type:Cube.RIGHT,indices:[1,5,6,2],clockwise:true},
						       {type:Cube.LEFT,indices:[4,0,3,7],clockwise:true}];	
				
				
				if (isOnePiece)
				{					
			       for each(var data:Object in defines) {
				       destIndices = destIndices.concat(makeIndices(data.indices,data.clockwise));
			       }
				   strategy(destVertices, destIndices, tint, blend);
				}else {	
					for each(data in defines) {
					   destIndices = makeIndices(data.indices,data.clockwise);
					   strategy(destVertices, destIndices, tint, blend);
					   tint = ColorUtils.random();
				   }				
				}				
			}
		}
	
		private function  makeIndices(list:Array,clockwise:Boolean):Array
		{
			var collects:Array = (clockwise === true)
			                     ?[list[0], list[1], list[2], list[0], list[2], list[3]]
						         :[list[0], list[2], list[3], list[0], list[1], list[2]];
            return collects;
		}
		
	} //end of class

}