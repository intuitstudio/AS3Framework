/*
    
*/
package com.intuitStudio.motions.triDimens.isometric.concretes
{
	import com.intuitStudio.motions.triDimens.isometric.IsoUtils;
	import com.intuitStudio.motions.triDimens.isometric.core.DrawnIsoTile;
	import com.intuitStudio.motions.triDimens.interfaces.ISteeredVehicle3D;
	import com.intuitStudio.motions.biDimens.core.Vector2D;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.Vector3DUtils;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;


	public class SteeredDrawnIsoBox extends DrawnIsoBox implements ISteeredVehicle3D
	{
		public var maxSpeed:Number = 20;//foot unit
		public var maxForce:Number = 10.0;
		private var _arrivalThreshold:Number = 2;
		private var _arrivalSpeed:Number = 0;
		//wander
		private var _wanderAngle:Number = 0;
		private var _wanderDist:Number = 1;
		private var _wanderRadius:Number = .5;
		private var _wanderRange:Number = 1;
		private var _pathIndex:int = 0;
		private var _pathThreshold:Number = 2;
		protected var _steeringForce:Vector3D;
		
		
		public function SteeredDrawnIsoBox (size:Number,col:uint,h:Number=0)
		{
			_steeringForce = new Vector3D();
			super (size,col,h);
		}

		public function set steeringForce (value:Vector3D):void
		{
			_steeringForce = value;
		}

		public function get steeringForce ():Vector3D
		{
			return _steeringForce;
		}

		public function set arrivalThreshold (foot:Number):void
		{
			_arrivalThreshold = foot;
		}

		public function get arrivalThreshold ():Number
		{
			return _arrivalThreshold*IsoWorld.pixelsScale;
		}

		public function set wanderDist (foot:Number):void
		{
			_wanderDist = foot;
		}

		public function get wanderDist ():Number
		{
			return _wanderDist*IsoWorld.pixelsScale;
		}

		public function set wanderRadius (value:Number):void
		{
			_wanderRadius = value;
		}
		//return pixels value
		public function get wanderRadius ():Number
		{
			return _wanderRadius*IsoWorld.pixelsScale;
		}

		public function set wanderRange (foot:Number):void
		{
			_wanderRange = foot;
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

		public function set pathThreshold (foot:Number):void
		{
			_pathThreshold = foot;
		}

		public function get pathThreshold ():Number
		{
			return _pathThreshold*IsoWorld.pixelsScale;
		}
		//sub-class can override the update function in need 
		override public function update (elapsed:Number = 1.0):void
		{
			Vector3DUtils.truncateV3 (steeringForce,maxForce);
			velocity = velocity.add(Vector3DUtils.expandTo(steeringForce,1 / mass));
			Vector3DUtils.truncateV3 (velocity,maxSpeed);
			steeringForce = new Vector3D();
			super.update (elapsed);
		}

		public function seek (dest:Vector3D):void
		{
			var desiredVel:Vector3D = Vector3DUtils.expandTo(dest.subtract(location),maxSpeed);
			updateSteeringForce (desiredVel.subtract(velocity));
		}

		private function updateSteeringForce (force:Vector3D,way:int=1):void
		{
			steeringForce = (way==1)?steeringForce.add(force):steeringForce.subtract(force);
		}

		public function flee (dest:Vector3D):void
		{
			var desiredVel:Vector3D = Vector3DUtils.expandTo(dest.subtract(location),maxSpeed);
			updateSteeringForce (desiredVel.subtract(velocity),-1);
		}

		public function arrive (dest:Vector3D):void
		{
			var diff:Vector3D = Vector3DUtils.expandTo(dest.subtract(location),IsoWorld.pixelsScale);			
			var dist:Number = diff.length;
			var desiredVel:Vector3D;
			if (dist > arrivalThreshold)
			{
				_arrivalSpeed = maxSpeed;
				updateSteeringForce (Vector3DUtils.expandTo(diff,_arrivalSpeed).subtract(velocity));
			}
			else
			{
				_arrivalSpeed = Math.min(maxSpeed,Math.max(2*size/IsoWorld.pixelsScale,1));
				if (dist <=1)
				{
                    location = dest; 
					getVelocity().zero();
				}
				else
				{
					_arrivalSpeed = _arrivalSpeed*(dist/arrivalThreshold);
					updateSteeringForce (Vector3DUtils.expandTo(diff,_arrivalSpeed).subtract(velocity));
				}
			}
		}

		public function pursue (dest:Vector3D):void
		{
			var lookAheadTime:Number = (Vector3D.distance(location,dest)) / maxSpeed;
			dest = getVelocity().calculate(dest,lookAheadTime);
			seek (dest);
		}

		public function evade (dest:Vector3D):void
		{
			var lookAheadTime:Number = Vector3D.distance(location,dest) / maxSpeed;
			dest = getVelocity().calculate(dest,lookAheadTime);
			flee (dest);
		}

		public function wander ():void
		{
			var cent:Vector3D = Vector3DUtils.expandTo(velocity.clone(),wanderDist);
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

			var pos:Vector3D = Vector3DUtils.expandTo(location,IsoWorld.pixelsScale);
			var dest:Vector3D = Vector3DUtils.expandTo(wayPoint,IsoWorld.pixelsScale);
			if (Vector3D.distance(pos,dest) < pathThreshold)
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

			//trace('current index ' , pathIndex , '   ' , wayPoint.toString());
		}

	}
}