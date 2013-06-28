package com.intuitStudio.motions.triDimens.abstracts
{
	import flash.events.Event;
	import flash.geom.Vector3D;

	import com.intuitStudio.motions.triDimens.core.*;

	public class SteeredVehicle3D extends Vehicle3D
	{
		public var maxForce:Number = 1.0;
		private var _arrivalThreshold:Number = 100;
		protected var _steeringForce:Vector3D;

		public function SteeredVehicle3D (x:Number,y:Number,z:Number)
		{
			_steeringForce = new Vector3D();
			super (x,y,z);			
		}

		public function set steeringForce (value:Vector3D):void
		{
			_steeringForce = value;
		}

		public function get steeringForce ():Vector3D
		{
			return _steeringForce;
		}

		public function set arrivalThreshold (value:Number):void
		{
			_arrivalThreshold = value;
		}

		public function get arrivalThreshold ():Number
		{
			return _arrivalThreshold;
		}

		//sub-class can override the update function in need 
		override public function update (elapsed:Number = 1.0):void
		{
			truncateV3 (steeringForce,maxForce);			
			steeringForce.scaleBy(1/mass);
			velocity = velocity.add(steeringForce);
			steeringForce = new Vector3D();
			super.update (elapsed);
		}

		//------------- different steered behaviors' function

		public function seek (dest:Vector3D):void
		{
			var desiredVel:Vector3D = dest.subtract(location);
			desiredVel.normalize ();
			desiredVel.scaleBy(maxSpeed);
			var force:Vector3D = desiredVel.subtract(velocity);
			steeringForce = steeringForce.add(force);
		}

		public function flee (dest:Vector3D):void
		{
			var desiredVel:Vector3D = dest.subtract(location);
			desiredVel.normalize ();
			desiredVel.scaleBy(maxSpeed);
			var force:Vector3D = desiredVel.subtract(velocity);
			steeringForce = steeringForce.subtract(force);
		}

		public function arrive (dest:Vector3D):void
		{
			var desiredVel:Vector3D = dest.subtract(location);
			desiredVel.normalize ();

			var dist:Number = location.distance(dest);
			if (dist > arrivalThreshold)
			{
				desiredVel.scaleBy(maxSpeed);
			}
			else
			{
				desiredVel.scaleBy(maxSpeed * dist / arrivalThreshold);
			}

			var force:Vector3D = desiredVel.subtract(velocity);
			steeringForce = steeringForce.add(force);
		}

		public function pursue (dest:Vector3D):void
		{
			var lookAheadTime:Number = location.distance(dest) / maxSpeed;
			var desireVel:Vector3D = velocity.clone();
			desireVel.scaleBy(lookAheadTime);
			var predictDest:Vector3D = dest.add(desireVel);
			seek (predictDest);
		}

		public function evade (dest:Vector3D):void
		{
			var lookAheadTime:Number = location.distance(dest) / maxSpeed;
			var desireVel:Vector3D = velocity.clone();
			desireVel.scaleBy(lookAheadTime);
			var predictDest:Vector3D = dest.add(desireVel);
			flee (predictDest);
		}

	}
}