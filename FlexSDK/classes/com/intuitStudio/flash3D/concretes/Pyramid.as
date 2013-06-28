package com.intuitStudio.flash3D.concretes 
{
  /**
  * Class Pyramid
  * @author vanier peng , 2003.4.22
  * 定義金字塔物件 :
  * 	@params: 無
  *  初始化交由函式makePolygon()負責；金字塔由四個三角形及一個正方形所組成(6個三角形)
  */
  
	import com.intuitStudio.flash3D.core.Polygon;
	import com.intuitStudio.triMotion.core.*;
	import com.intuitStudio.utils.ColorUtils;
	import flash.errors.IllegalOperationError;
	
	public class Pyramid extends Polygon
	{
        private var isOnePiece:Boolean = false;	
		public function Pyramid(isOne:Boolean=false) 
		{
			super();
			isOnePiece = isOne;
		}

		
	   /**
	  * 金字塔頂點 v.s 平面的索引值陣列 ; 金字塔的高度與底的寬高相同
	  * 金字塔共有五個點以及五個面組成，包括塔身的四個三角形以及底部的矩形，共有6個三角形
	  * 按照順時針方向排列各個頂點順序(以面朝自己的順時針方向)，以及指定不同面的組成頂點陣列(順時針方向繪製的三角形為面朝上，逆時針繪製則為面朝下)
  	  * points [0,1,2,3,4]
	  * face 0: [0,1,2] -> clockwise
	  * face 1: [0,2,3] -> clockwise
	  * face 2: [0,3,4] -> clockwise
	  * face 3: [0,4,1] -> clockwise
	  * face 4: [1,2,3,4] -> [1,3,2,1,4,3] -> counterclock
	  */	
	  
		override public function makePolygon(geo:String, point:Point3d, ... rest):void
		{
			center = point || new Point3d();
			var strategy:Function = null, destVertices:Array = [], destIndices:Array = [], tint:uint, blend:Number;

			if ( geo === '2d')
			{
			    throw new IllegalOperationError('Pyramid is a kind of 3d mesh.');				
			}
			
			if (geo === '3d')
			{
				strategy = create3d;
				size = rest[0];
				tint = rest[1] || 0xFFFF00;
				blend = rest[2] || 1.0;
				var dist:Number = size;
				destVertices[0] = new Point3d(center.x, center.y, center.z - dist);
				destVertices[1] = new Point3d(center.x + dist, center.y + dist, center.z + dist);
				destVertices[2] = new Point3d(center.x - dist, center.y + dist, center.z + dist);
				destVertices[3] = new Point3d(center.x - dist, center.y - dist, center.z + dist);
				destVertices[4] = new Point3d(center.x + dist, center.y - dist, center.z + dist);
			    for each(var pt:Point3d in destVertices) {
				   pt.perspective = center.perspective;				   
			    }
				
                //{type:面,indices:[頂點的排列索引],clockwise:三角形的繪製先後順序}
		        var defines:Array = [ [0,1,2],
		                              [0,2,3],
						              [0,3,4],
						              [0,4,1],
						              [1,4,3,2] ];

				if (isOnePiece)
				{					
			       for each(var data:Array in defines) {
				       destIndices = (data.length === 3)
					                 ?destIndices.concat(data) 
									 :destIndices.concat(makeIndices(data,true));
			       }
				   strategy(destVertices, destIndices, tint, blend);
				}else {	
				   for each(data in defines) {
					   destIndices = (data.length===3)?data:makeIndices(data,false);
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
		
	}//end of class

}