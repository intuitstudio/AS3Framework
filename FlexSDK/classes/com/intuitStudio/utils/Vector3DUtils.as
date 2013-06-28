package com.intuitStudio.utils
{
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public class Vector3DUtils
	{	
	    public static function arrayToVector(array:Array):Vector3D
		{
			return new Vector3D(array[0],array[1],array[2]);
		}
		
		public static function vectorToArray(vector:Vector3D):Array
		{
			return [vector.x,vector.y,vector.z];
		}
	
		public static function truncateV3 (v3:Vector3D,value:Number):Vector3D
		{
			var len:Number = Math.min(v3.length,value);
			v3.normalize ();
			v3.scaleBy (len);
			return v3;
		}
		
		//create new vector3D which is multiplied 
		public static function expandTo(v3:Vector3D,value:Number):Vector3D
		{
			var newV3:Vector3D = v3.clone();
			var long:Number = v3.length*value;
			newV3.normalize();
			newV3.scaleBy (long);
			return newV3;
		}
		
		//y position is 0
		public static function makeXZVector3D(len:Number,angle:Number):Vector3D
		{
			var x:Number = len*Math.sin(angle);
			var z:Number = len*Math.cos(angle);
			return new Vector3D(x,0,z);
		}
		
		//
		public static function localToGlobal(container:DisplayObject,obj:DisplayObject):Vector3D
		{
			var loc:Vector3D = obj.transform.matrix3D.position;
			
			if(loc)
			{
				loc = container.transform.matrix3D.deltaTransformVector(loc);
				return loc;
			}
			trace('object is not in 3D');
			return null;
		}

        //obj must be a 3D object
        public static function spaceToScreen(container:DisplayObjectContainer,loc:Vector3D):Point
		{   
			var pos:Point = container.local3DToGlobal(loc);
			return container.globalToLocal(pos);	
		}
		
        public static function screenToSpace(container:DisplayObjectContainer,point:Point):Vector3D
		{		   
		  //  point = container.localToGlobal(point);
			var loc:Vector3D = container.globalToLocal3D(point);
			return loc;			
		}   
		
		public static function perpendicular(vertices:Vector.<Vector3D>):Vector3D
		{
			var U:Vector3D = getEdge(vertices[1],vertices[0]);
			var V:Vector3D = getEdge(vertices[1],vertices[2]);
			return U.crossProduct(V);
		}
		
		public static function angleAgainstLight(vertices:Vector.<Vector3D>,lightDirection:Vector3D):Number
		{
			var crossProduct:Vector3D = perpendicular(vertices);
			return Vector3D.angleBetween(crossProduct,lightDirection);
		}
		
		public static function getEdge(v1:Vector3D,v2:Vector3D):Vector3D
		{
			var diff:Vector3D = v1.subtract(v2);			
			diff.normalize();
			return diff;
		}
		
	}	
	
}