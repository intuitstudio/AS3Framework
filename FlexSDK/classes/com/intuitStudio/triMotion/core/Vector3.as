package com.intuitStudio.triMotion.core 
{
  /**
  * Class Vector3
  * @author vanier peng ,2013.4.21
  * 3D空間向量，提供3D向量的基本運算
  * 
  */
  
	import flash.geom.Vector3D;
	
	public class Vector3  extends Vector3D
	{
		
		public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0) 
		{
			super(x, y, z);
		}		
		
		public function zero():void
		{
			setTo(0,0,0);
		}
		
		public function get isZero():Boolean
		{
			return (x === 0 && y === 0 && z === 0);
		}
		
		public function setLength(len:Number):void
		{
			this.normalize();
			this.scaleBy(len);
		}
		
		public function get isNormalized():Boolean
		{
			return ( this.length === 1 );
		}
		
		public function truncate(max:Number):Vector3
		{
			setLength(Math.min(length, max));
			return this;
		}		
		
		public function multiply(value:Number):Vector3
		{
			var v:Vector3 = new Vector3(x,y,z);
			v.scaleBy(value);
			return v;
		}
		
		public function divide(value:Number):Vector3
		{
			return new Vector3(x/value,y/value,z/value);
		}
		
		public function dotProd(v:Vector3):Number
		{
			return this.dotProduct(v);
		}
		
		public function crossProd(v:Vector3):Vector3
		{
			var result:Vector3D = this.crossProduct(v);
			return new Vector3(result.x, result.y, result.z);
			
			//return new Vector3(-z * v.y + y * v.z, z * v.x - x * v.z, -y * v.x + x * v.y);		

		}
		
		override public function toString():String
		{
			return 'Vector3 : (' + x + ',' + y + ',' + z + ')';
		}
		
	}

}