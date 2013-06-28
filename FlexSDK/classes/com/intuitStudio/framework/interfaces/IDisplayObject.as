package com.intuitStudio.framework.interfaces
{
	import flash.geom.Vector3D;
	
	public interface IDisplayObject
	{
		function set location():void;
		function get location():Vector3D;
		function set x(value:Number):void;
		function get x():Number;
		function set y(value:Number):void;
		function get y():Number;
		function set z(value:Number):void;
		function get z():Number;
		
		function set vx(value:Number):void;
		function get vx():Number;
		function set vy(value:Number):void;
		function get vy():Number;
		function set vz(value:Number):void;
		function get vz():Number;

		function update(elapsed:Number = 1.0):void;
		function render():void;		
	}
	
}