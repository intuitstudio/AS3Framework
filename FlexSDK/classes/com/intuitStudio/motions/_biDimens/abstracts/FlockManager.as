package com.intuitStudio.motions.biDimens.abstracts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	import com.intuitStudio.motions.biDimens.core.*;
	import com.intuitStudio.motions.biDimens.abstracts.SteeredVehicle;
	import com.intuitStudio.motions.biDimens.concretes.ColorSteeredVehicle;
	import com.intuitStudio.motions.collision.abstracts.CollisionGrid;
	import com.intuitStudio.utils.VectorUtils;

	public class FlockManager
	{
		private var _inSightDist:Number = 200;
		private var _flock:Vector.<DisplayObject > ;
		private var _checker:CollisionGrid;
		private var _checks:Vector.<DisplayObject > ;

		public function FlockManager ()
		{

		}

		public function makeGrid (area:Rectangle,size:Number):void
		{
			_inSightDist = size;
			_checker = new CollisionGrid(area.width,area.height,size);
		}

		public function makeFlock (vt:Vector.<DisplayObject>):void
		{
			_flock = vt;
			for (var i:uint=0; i<_flock.length; i++)
			{
				var vehicle:SteeredVehicle = _flock[i] as SteeredVehicle;
				//vehicle.inSightDist = _inSightDist;
			}

			_checker.check (_flock);
			_checks = _checker.checks;
		}

		public function search (vehicle:Vehicle):Vector.<Vehicle > 
		{
			var targets:Vector.<Vehicle> = new Vector.<Vehicle>();

			for (var i:uint=0; i<_checks.length; i+=2)
			{

				if (_checks[i] == vehicle)
				{
					targets.push (_checks[i+1] );
				}

				if (_checks[i + 1] == vehicle)
				{
					targets.push (_checks[i]);
				}
			}

			return targets;
		}

		public function flock2 (vehicles:Vector.<Vehicle>):void
		{

			for (var i:uint=0; i<vehicles.length; i++)
			{
				var vehicleA:Vehicle = vehicles[i] as Vehicle;
				var averageVel:Vector2D = vehicleA.velocity.clone();
				var averageLoc:Vector2D = new Vector2D();
				//check number of vehicles saw
				var saw:int = 0;

				for (var j:uint=i+1; j<vehicles.length; j++)
				{
					var vehicleB:Vehicle = vehicles[j] as Vehicle;
					if (SteeredVehicle(vehicleA).inSight(vehicleB))
					{
						averageVel = averageVel.add(vehicleB.velocity);
						averageLoc = averageLoc.add(vehicleB.location);
						if (SteeredVehicle(vehicleA).tooClose(vehicleB))
						{
							SteeredVehicle(vehicleA).flee (vehicleB.location);
						}
						saw++;
					}
				}
				if (saw > 0)
				{
					averageVel = averageVel.divide(saw);
					averageLoc = averageLoc.divide(saw);
					SteeredVehicle(vehicleA).seek (averageLoc);
					SteeredVehicle(vehicleA).steeringForce = SteeredVehicle(vehicleA).steeringForce.add(averageVel.subtract(vehicleA.velocity));
				}
			}
		}


		public function flock (vehicle:SteeredVehicle):void
		{
			_checker.check (_flock);
			_checks = _checker.checks;

			var targets:Vector.<Vehicle >  = search(vehicle);
			//trace('targets ',targets.length);

			var averageVel:Vector2D = vehicle.velocity.clone();
			var averageLoc:Vector2D = new Vector2D();
			//check number of vehicles saw
			var saw:int = 0;
			for (var i:uint=0; i<targets.length; i++)
			{
				var checked:Vehicle = targets[i] as Vehicle;
				if (vehicle.inSight(checked))
				{
					averageVel = averageVel.add(checked.velocity);
					averageLoc = averageLoc.add(checked.location);
					if (vehicle.tooClose(checked))
					{
						vehicle.flee (checked.location);
					}
					saw++;
				}
			}
			//
			if (saw > 0)
			{
				averageVel = averageVel.divide(saw);
				averageLoc = averageLoc.divide(saw);
				vehicle.seek (averageLoc);
				vehicle.steeringForce = vehicle.steeringForce.add(averageVel.subtract(vehicle.velocity));
			}
		}
	}
}