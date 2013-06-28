package com.intuitStudio.motions.triDimens.interfaces
{
	import flash.geom.Vector3D;
	
	public interface IVehicle3D
	{
		function set velocity (speed:Vector3D):void
		function get velocity ():Vector3D
		function set mass (value:Number):void;
		function get mass ():Number;
		function update (elapsed:Number=1.0):void;
		function render ():void;
	}	
}