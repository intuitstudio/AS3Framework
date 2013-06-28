package com.intuitStudio.flash3D.concretes 
{
   /**
   * Class Square
   * @author vanier peng , 2003.4.22
   * 定義矩形物件 :
   * 	@params: 無
   *  初始化交由函式build()負責; 矩形由兩個三角形組成 
   */
   
	import com.intuitStudio.flash3D.core.Polygon;
    import com.intuitStudio.triMotion.core.*;
   
	public class Square extends Polygon 
	{
		public function Square() 
		{
			super();
		}		

		override public function makePolygon(geo:String,point:Point3d,...rest):void
		{
			center  = point || new Point3d();
	   		
			var strategy:Function=null,destVertices:Array=[],destIndices:Array=[], tint:uint, blend:Number;
     		
			if (geo === '2d') {
			   strategy = create2d;
               destVertices = rest[0];
			   destIndices = rest[1];
			   tint = rest[2] || 0xFFFF00;
			   blend = rest[3] || 1.0;
			}
			
			if (geo === '3d') {
			   strategy = create3d;
			   size = rest[0];
			   tint = rest[1] || 0xFFFF00;
			   blend = rest[2] || 1.0;	
			   //
			   var dist:Number = size >> 1;
		       destVertices[0] = new Point3d( center.x-dist, center.y-dist, center.z);
		       destVertices[1] = new Point3d( center.x+dist, center.y-dist, center.z);
		       destVertices[2] = new Point3d( center.x+dist, center.y+dist, center.z);
		       destVertices[3] = new Point3d( center.x - dist, center.y + dist, center.z);
			   destIndices = [0, 1, 2, 0, 2, 3];	
			   
			   for each(var pt:Point3d in destVertices) {
				   pt.perspective = center.perspective;	
			   }
			   
			   
			}
			
			if (strategy!==null)
			{
				trace('create square 3d');
			   strategy(destVertices, destIndices, tint, blend);
			}
		}

		
	}//end of class

}