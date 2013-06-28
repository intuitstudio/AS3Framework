package com.intuitStudio.motions.biDimens.abstracts
{
	import flash.events.Event;

	import com.intuitStudio.motions.biDimens.core.*;
	import com.intuitStudio.motions.biDimens.shapes.Circle;

	public class SteeredVehicle extends Vehicle
	{
		public var maxForce:Number = 1.0;
		private var _arrivalThreshold:Number = 100;
		//wander
		private var _wanderAngle:Number = 0;
		private var _wanderDist:Number = 10;
		private var _wanderRadius:Number = 5;
		private var _wanderRange:Number = 1;
		//
		private var _avoidDist:Number = 300;
		private var _avoidBuffer:Number = 20;
		//
		private var _pathIndex:int = 0;
		private var _pathThreshold:Number = 20;
		//
		private var _inSightDist:Number = 200;
		private var _tooCloseDist:Number = 30;
		private var _sightRange:Number = Math.PI * 1.5;

		protected var _steeringForce:Vector2D;

		public function SteeredVehicle (showMe:Boolean=false)
		{
			super (showMe);
		}

		override protected function init (e:Event=null):void
		{
			_steeringForce = new Vector2D();
			super.init (e);
		}

		public function set steeringForce (value:Vector2D):void
		{
			_steeringForce = value;
		}

		public function get steeringForce ():Vector2D
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

		public function set avoidDist (value:Number):void
		{
			_avoidDist = value;
		}

		public function get avoidDist ():Number
		{
			return _avoidDist;
		}

		public function set avoidBuffer (value:Number):void
		{
			_avoidBuffer = value;
		}

		public function get avoidBuffer ():Number
		{
			return _avoidBuffer;
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

		public function set inSightDist (value:Number):void
		{
			_inSightDist = value;
		}

		public function get inSightDist ():Number
		{
			return _inSightDist;
		}

		public function set tooCloseDist (value:Number):void
		{
			_tooCloseDist = value;
		}

		public function get tooCloseDist ():Number
		{
			return _tooCloseDist;
		}

		public function set sightRange (value:Number):void
		{
			_sightRange = value;
		}

		public function get sightRange ():Number
		{
			return _sightRange;
		}

		//sub-class can override the update function in need 
		override public function update (elapsed:Number = 1.0):void
		{
			steeringForce.truncate (maxForce);
			steeringForce = steeringForce.divide(mass);
			velocity = velocity.add(steeringForce);
			steeringForce = new Vector2D();
			super.update (elapsed);
		}

		//------------- different steered behaviors' function

		public function seek (dest:Vector2D):void
		{
			var desiredVel:Vector2D = dest.subtract(location);
			desiredVel.normalize ();
			desiredVel = desiredVel.multiply(maxSpeed);
			var force:Vector2D = desiredVel.subtract(velocity);
			steeringForce = steeringForce.add(force);
		}

		public function flee (dest:Vector2D):void
		{
			var desiredVel:Vector2D = dest.subtract(location);
			desiredVel.normalize ();
			desiredVel = desiredVel.multiply(maxSpeed);
			var force:Vector2D = desiredVel.subtract(velocity);
			steeringForce = steeringForce.subtract(force);
		}

		public function arrive (dest:Vector2D):void
		{
			var desiredVel:Vector2D = dest.subtract(location);
			desiredVel.normalize ();

			var dist:Number = location.distance(dest);
			if (dist > arrivalThreshold)
			{
				desiredVel = desiredVel.multiply(maxSpeed);
			}
			else
			{
				desiredVel = desiredVel.multiply(maxSpeed * dist / arrivalThreshold);
			}

			var force:Vector2D = desiredVel.subtract(velocity);
			steeringForce = steeringForce.add(force);
		}

		public function pursue (dest:Vector2D):void
		{
			var lookAheadTime:Number = location.distance(dest) / maxSpeed;
			var predictDest:Vector2D = dest.add(velocity.multiply(lookAheadTime));
			seek (predictDest);
		}

		public function evade (dest:Vector2D):void
		{
			var lookAheadTime:Number = location.distance(dest) / maxSpeed;
			var predictDest:Vector2D = dest.add(velocity.multiply(lookAheadTime));
			flee (predictDest);
		}

		public function wander ():void
		{
			var center:Vector2D = velocity.clone().normalize().multiply(wanderDist);
			var offset:Vector2D = new Vector2D();
			offset.length = wanderRadius;
			offset.angle = wanderAngle;
			wanderAngle +=  Math.random() * wanderRange - wanderRange * .5;
			var force:Vector2D = center.add(offset);
			steeringForce = steeringForce.add(force);
		}

		public function avoid (circles:Vector.<Circle>):void
		{
			for (var i:int=0; i<circles.length; i++)
			{
				var circle:Circle = circles[i] as Circle;
				var heading:Vector2D = velocity.clone().normalize();
				var difference:Vector2D = circle.location.subtract(location);
				var dotProd:Number = difference.dotProd(heading);

				if (dotProd > 0)
				{
					var fleer:Vector2D = heading.multiply(avoidDist);
					var projection:Vector2D = heading.multiply(dotProd);
					var dist:Number = projection.subtract(difference).length;
					if (dist<(circle.radius+avoidBuffer) && projection.length<fleer.length)
					{
						var force:Vector2D = heading.multiply(maxSpeed);
						force.angle +=  difference.sign(velocity) * Math.PI * .5;
						force = force.multiply(1.0 - projection.length / fleer.length);
						steeringForce = steeringForce.add(force);
						velocity = velocity.multiply(projection.length / fleer.length);
					}
				}
			}
		}

		public function followPath (path:Vector.<Vector2D>,loop:Boolean=true):void
		{
			if (path.length == 0)
			{
				return;
			}

			var wayPoint:Vector2D = path[pathIndex] as Vector2D;
			if (wayPoint == null)
			{
				return;
			}

			if (location.distance(wayPoint) < pathThreshold)
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

		public function flock (vehicles:Vector.<Vehicle>):void
		{
			var averageVel:Vector2D = velocity.clone();
			var averageLoc:Vector2D = new Vector2D();
			//check number of vehicles saw
			var saw:int = 0;
			for (var i:uint=0; i<vehicles.length; i++)
			{
				var vehicle:Vehicle = vehicles[i] as Vehicle;
				if (vehicle != this && inSight(vehicle))
				{
					averageVel = averageVel.add(vehicle.velocity);
					averageLoc = averageLoc.add(vehicle.location);
					if (tooClose(vehicle))
					{
						flee (vehicle.location);
					}
					saw++;
				}
			}
			//
			if (saw > 0)
			{
				averageVel = averageVel.divide(saw);
				averageLoc = averageLoc.divide(saw);
				seek (averageLoc);
				steeringForce = steeringForce.add(averageVel.subtract(velocity));
				//steeringForce.add (averageVel.subtract(velocity));
				//trace(steeringForce.x,steeringForce.y)
			}
		}

		public function inSight (vehicle:Vehicle):Boolean
		{
			if (location.distance(vehicle.location) > inSightDist)
			{
				return false;
			}

			var heading:Vector2D = velocity.clone().normalize();
			var difference:Vector2D = vehicle.location.subtract(location);
			//var dotProd:Number = difference.dotProd(heading);
			//return (dotProd>0);

			//view range
			var unitDiff:Vector2D = difference.clone().normalize();
			var dotProd:Number = unitDiff.dotProd(heading);
			var angle:Number = Math.acos(dotProd);

			if (unitDiff.perp.sign(heading) > 0)
			{
				if (angle <= sightRange * .5)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				if (angle >= -(sightRange*.5))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		public function tooClose (vehicle:Vehicle):Boolean
		{
			return location.distance(vehicle.location)<tooCloseDist;
		}
	}
}