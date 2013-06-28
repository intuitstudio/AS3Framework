package com.intuitStudio.triMotion.core 
{

   /**
   * Class Ray3
   * @author vanier peng , 2003.4.21
   * 定義光線物件 :
   * 	@params: (Point3d,vector3) 實際畫在螢幕上的座標
   */
   
	import com.intuitStudio.utils.MathTools;
	import flash.geom.Vector3D;
	
	public class Ray3 
	{
		private var _oriPoint:Point3d;
		private var _brightness:Number = 1.0;
		private var _direction:Vector3;
		
		public function Ray3(origin:Point3d=null,blend:Number=1.0,direction:Vector3=null) 
		{
			_oriPoint = (origin === null)?new Point3d( -100, -100, -100):origin;
			_direction = (direction === null)? new Vector3(1, 1, 1):direction;			
			brightness = blend;
		}
		
		public function getpoint(distance:Number):Point3d
		{
			var dest:Vector3D = origin.add(direction.multiply(distance))
		    return new Point3d(dest.x,dest.y,dest.z);	
		}
		
		public function get origin():Vector3D
		{
			return new Vector3D(_oriPoint.x,_oriPoint.y,_oriPoint.z);
		}
		
		public function get direction():Vector3
		{
			return _direction;
		}
		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		public function set brightness(value:Number):void
		{
			_brightness = MathTools.clamp(value, 0, 1);
		}
		
		
	}//end of class

}