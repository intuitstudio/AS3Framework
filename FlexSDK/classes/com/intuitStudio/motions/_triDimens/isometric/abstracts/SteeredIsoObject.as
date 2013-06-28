package com.intuitStudio.motions.triDimens.isometric.abstracts
{
	import flash.geom.Vector3D;

	import com.intuitStudio.motions.triDimens.isometric.core.IsoObject;
	import com.intuitStudio.motions.triDimens.interfaces.ISteeredVehicle3D;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.triDimens.core.Velocity3D;

	public class SteeredIsoObject extends IsoObject implements ISteeredVehicle3D
	{	
		public var maxSpeed:Number = 10;
		public var maxForce:Number = 10.0;
		private var _arrivalThreshold:Number = 50;
		//wander
		private var _wanderAngle:Number = 0;
		private var _wanderDist:Number = 1;
		private var _wanderRadius:Number = .5;
		private var _wanderRange:Number = 1;		
		//
		private var _pathIndex:int = 0;
		private var _pathThreshold:Number = 20;
		
		protected var _steeringForce:Vector3D;

		public function SteeredIsoObject (size:Number)
		{
			_steeringForce = new Vector3D();
			super (size);
		}

		override protected function init ():void
		{
			super.init ();

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

		public function set wanderDist (value:Number):void
		{
			_wanderDist = value;
		}

		public function get wanderDist ():Number
		{
			return _wanderDist;
		}

		public function set wanderRadius (value:Number):void
		{
			_wanderRadius = value;
		}

		public function get wanderRadius ():Number
		{
			return _wanderRadius;
		}

		public function set wanderRange (value:Number):void
		{
			_wanderRange = value;
		}

		public function get wanderRange ():Number
		{
			return _wanderRange;
		}

		public function set wanderAngle (value:Number):void
		{
			_wanderAngle = value;
		}

		public function get wanderAngle ():Number
		{
			return _wanderAngle;
		}

		public function set pathIndex (value:int):void
		{
			_pathIndex = value;
		}

		public function get pathIndex ():int
		{
			return _pathIndex;
		}

		public function set pathThreshold (value:Number):void
		{
			_pathThreshold = value;
		}

		public function get pathThreshold ():Number
		{
			return _pathThreshold;
		}

		override public function update (elapsed:Number = 1.0):void
		{
			Vector3DUtils.truncateV3 (steeringForce,maxForce);
			steeringForce.scaleBy (1/mass);
			velocity = velocity.add(steeringForce);
			steeringForce = new Vector3D();
			super.update (elapsed);
		}

		public function seek (dest:Vector3D):void
		{
			var desiredVel:Vector3D = Vector3DUtils.expand(dest.subtract(location),maxSpeed);
			updateSteeringForce (desiredVel.subtract(velocity));
		}

		private function updateSteeringForce (force:Vector3D,way:int=1):void
		{
			steeringForce = (way==1)?steeringForce.add(force):steeringForce.subtract(force);
		}

		public function flee (dest:Vector3D):void
		{
			var desiredVel:Vector3D = Vector3DUtils.expand(dest.subtract(location),maxSpeed);
			updateSteeringForce (desiredVel.subtract(velocity),-1);
		}

		public function arrive (dest:Vector3D):void
		{
			var dist:Number = Vector3D.distance(location,dest);
			var speed:Number = (dist > arrivalThreshold)?maxSpeed:maxSpeed*(dist/arrivalThreshold);
			var desiredVel:Vector3D = Vector3DUtils.expand(dest.subtract(location),speed);
			updateSteeringForce (desiredVel.subtract(velocity));
		}

		public function pursue (dest:Vector3D):void
		{
			var lookAheadTime:Number = Vector3D.distance(location,dest) / maxSpeed;
			dest = getVelocity().calculate(dest,lookAheadTime);
			seek(dest);
		}

		public function evade (dest:Vector3D):void
		{
			var lookAheadTime:Number = Vector3D.distance(location,dest) / maxSpeed;
			dest = getVelocity().calculate(dest,lookAheadTime);
			flee(dest);
		}

		public function wander ():void
		{
			var cent:Vector3D = Vector3DUtils.expand(velocity.clone(),wanderDist);
			var turn:Vector3D = Vector3DUtils.makeXZVector3D(wanderRadius,wanderAngle);
			wanderAngle +=  Math.random() * wanderRange - wanderRange * .5;
			updateSteeringForce (cent.add(turn));
		}
		
		public function followPath (path:Vector.<Vector3D>,loop:Boolean=true):void
		{
			if (path.length == 0)
			{
				return;
			}

			var wayPoint:Vector3D = path[pathIndex] as Vector3D;
			if (wayPoint == null)
			{
				return;
			}

			if (Vector3D.distance(location,wayPoint) < pathThreshold)
			{
				if (pathIndex >= path.length - 1)
				{
					if (loop)
					{
						pathIndex = 0;
					}
				}
				else
				{
					pathIndex++;
				}
			}

			if (pathIndex >= path.length - 1 && ! loop)
			{
				arrive (wayPoint);
			}
			else
			{
				seek (wayPoint);
			}
		}
		
	}

}