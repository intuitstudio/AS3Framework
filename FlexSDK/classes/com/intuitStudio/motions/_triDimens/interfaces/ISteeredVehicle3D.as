package com.intuitStudio.motions.triDimens.interfaces
{
	import flash.geom.Vector3D;
	
	public interface ISteeredVehicle3D
	{
		function set steeringForce (value:Vector3D):void;
		function get steeringForce ():Vector3D;
		function set arrivalThreshold (value:Number):void;
		function get arrivalThreshold ():Number;
		function set wanderDist (value:Number):void;
		function get wanderDist ():Number;
		function set wanderRange (value:Number):void;
		function get wanderRadius ():Number;
		function set wanderAngle (value:Number):void;
		function get wanderAngle ():Number;
		function set pathIndex (value:int):void;
		function get pathIndex ():int;
		function set pathThreshold (value:Number):void;
		function get pathThreshold ():Number;
		function update (elapsed:Number = 1.0):void;
		function seek (dest:Vector3D):void;
		function flee (dest:Vector3D):void;
		function arrive (dest:Vector3D):void;
		function pursue (dest:Vector3D):void;
		function evade (dest:Vector3D):void;
		function wander ():void;	
		function followPath (path:Vector.<Vector3D>,loop:Boolean=true):void;
	}
	
}