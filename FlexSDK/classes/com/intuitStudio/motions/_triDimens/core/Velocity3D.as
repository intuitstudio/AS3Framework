package com.intuitStudio.motions.triDimens.core
{
	import flash.geom.Vector3D;
	import com.intuitStudio.motions.biDimens.core.Vector2D;
	import com.intuitStudio.utils.Vector3DUtils;

	public class Velocity3D
	{
		private static const PLANE_XY:int = 0;
		private static const PLANE_XZ:int = 1;
		private static const PLANE_YZ:int = 3;

		public static const VELOCITY_EULER:int = 0;
		public static const VELOCITY_RK2:int = 1;
		public static const VELOCITY_RK4:int = 2;

		private var _velocity:Vector3D;
		private var _acceleration:Vector3D;
		private var _friction:Number = .98;
		private var _gravity:Number = 32;
		private var _bounce:Number = -.6;
		private var _easing:Number = .1;
		private var _integrateWay:int = VELOCITY_RK2; 

		public function Velocity3D (x:Number=0,y:Number=0,z:Number=0,integrate:int=0)
		{
			_velocity = new Vector3D(x,y,z);
			_acceleration = new Vector3D(0,gravity,0);
			_integrateWay = integrate;
			init ();
		}

		protected function init ():void
		{

		}

        public function set integrateWay(value:int):void
		{
			_integrateWay = value;
		}

        public function get integrateWay():int
		{
			return _integrateWay;
		}
		
		public function get speed ():Number
		{
			return _velocity.length;
		}

		public function getPlaneAngle (plane:int):Number
		{
			switch (plane)
			{
				case Velocity3D.PLANE_XY :
					Math.atan2 (vy,vx);
					break;
				case Velocity3D.PLANE_XZ :
					Math.atan2 (vz,vx);
					break;
				case Velocity3D.PLANE_YZ :
					Math.atan2 (vz,vy);
					break;
			}
			return 0;
		}

		public function getPlaneVelocity (plane:int):Vector2D
		{
			switch (plane)
			{
				case Velocity3D.PLANE_XY :
					new Vector2D(vx,vy);
					break;
				case Velocity3D.PLANE_XZ :
					new Vector2D(vx,vz);
					break;
				case Velocity3D.PLANE_YZ :
					new Vector2D(vy,vz);
					break;
			}
			return new Vector2D();
		}

		public function set velocity (vel:Vector3D):void
		{
			_velocity = vel;
		}
		
		public function get velocity ():Vector3D
		{
			return _velocity;
		}
		
		public function zero():void
		{
			_velocity = new Vector3D();
		}
		
		public function normalize():void
		{
			if(_velocity.length==0)
			{
				_velocity = new Vector3D(1,0,0);
			}
			 _velocity.normalize();
		}

		public function set vx (value:Number):void
		{
			_velocity.x = value;
		}

		public function get vx ():Number
		{
			return _velocity.x;
		}

		public function set vy (value:Number):void
		{
			_velocity.y = value;
		}

		public function get vy ():Number
		{
			return _velocity.y;
		}

		public function set vz (value:Number):void
		{
			_velocity.z = value;
		}

		public function get vz ():Number
		{
			return _velocity.z;
		}

    	public function set friction (value:Number):void
		{
			_friction = value;
		}

		public function get friction ():Number
		{
			return _friction;
		}

		public function set gravity (value:Number):void
		{
			_gravity = value;
		}

		public function get gravity ():Number
		{
			return _gravity;
		}

		public function set bounce (value:Number):void
		{
			_bounce = value;
		}

		public function get bounce ():Number
		{
			return _bounce;
		}

		public function set earsing (value:Number):void
		{
			_easing = value;
		}

		public function get earsing ():Number
		{
			return _easing;
		}

        // feedback the velocity and new location
		public function calculate (loc:Vector3D,elapsed:Number=1.0):Vector3D
		{			
			switch (_integrateWay)
			{
				case Velocity3D.VELOCITY_EULER :
					return getEuler(loc,elapsed);
					break;
				case Velocity3D.VELOCITY_RK2 :
					return getRK2(loc,elapsed);
					break;
				case Velocity3D.VELOCITY_RK4 :
					return getRK4(loc,elapsed);
					break;
			}

			return  getEuler(loc,elapsed);
		}

		private function getEuler (loc:Vector3D,elapsed:Number):Vector3D
		{
			var vel:Vector3D = velocity.clone();
			var accel:Vector3D = getAcceleration(loc,vel);
			var nextLoc:Vector3D = loc.add(Vector3DUtils.expandTo(vel,elapsed));
			velocity = vel.add(Vector3DUtils.expandTo(accel,elapsed));
			return nextLoc;
		}

		private function getRK2 (loc:Vector3D,elapsed:Number):Vector3D
		{
			var vel:Vector3D = velocity.clone();
			var accel1:Vector3D = getAcceleration(loc,vel);
			
			var loc2:Vector3D = loc.add(Vector3DUtils.expandTo(vel,elapsed));
			var vel2:Vector3D = vel.add(Vector3DUtils.expandTo(accel1,elapsed));
			var accel2:Vector3D = getAcceleration(loc2,vel2);
			
		    var averageVel:Vector3D = Vector3DUtils.expandTo(vel.add(vel2),.5);
			var averageAccel:Vector3D = Vector3DUtils.expandTo(accel1.add(accel2),.5);
			var nextLoc:Vector3D = loc.add(Vector3DUtils.expandTo(averageVel,elapsed));
			velocity = vel.add(Vector3DUtils.expandTo(averageAccel,elapsed));
			
			return nextLoc;
		}

		private function getRK4 (loc:Vector3D,elapsed:Number):Vector3D
		{
			var vel:Vector3D = velocity.clone();
			var accel1:Vector3D = getAcceleration(loc,vel);
			
			var loc2:Vector3D = loc.add(Vector3DUtils.expandTo(vel,0.5*elapsed));
			var vel2:Vector3D = vel.add(Vector3DUtils.expandTo(accel1,0.5*elapsed));
			var accel2:Vector3D = getAcceleration(loc2,vel2);
			
			var loc3:Vector3D = loc.add(Vector3DUtils.expandTo(vel2,0.5*elapsed));
			var vel3:Vector3D = vel.add(Vector3DUtils.expandTo(accel2,0.5*elapsed));
			var accel3:Vector3D = getAcceleration(loc3,vel3);
			
			var loc4:Vector3D = loc.add(Vector3DUtils.expandTo(vel3,elapsed));
			var vel4:Vector3D = vel.add(Vector3DUtils.expandTo(accel3,elapsed));
			var accel4:Vector3D = getAcceleration(loc4,vel4);
			
			//caculate averate velocity and acceleration to get new postion and velocity
		    var averageVel:Vector3D = vel.add(Vector3DUtils.expandTo(vel2,2));
			averageVel = averageVel.add(Vector3DUtils.expandTo(vel3,2));
			averageVel = averageVel.add(vel4);
			averageVel = Vector3DUtils.expandTo(averageVel,1/6);
			var nextLoc:Vector3D = loc.add(Vector3DUtils.expandTo(averageVel,elapsed));
			
			var averageAccel:Vector3D =  accel1.add(Vector3DUtils.expandTo(accel2,2));
			averageAccel = averageAccel.add(Vector3DUtils.expandTo(accel3,2));
			averageAccel = averageAccel.add(accel4);
			averageAccel = Vector3DUtils.expandTo(averageAccel,1/6);
			velocity = vel.add(Vector3DUtils.expandTo(averageAccel,elapsed));
			
			return nextLoc;
		}

		public function getAcceleration (loc:Vector3D,vel:Vector3D):Vector3D
		{
			return velocity;
		}


		public function set acceleration (accel:Vector3D):void
		{
			_acceleration = accel;
		}

		public function get acceleration ():Vector3D
		{
			return _acceleration;
		}

		public function set ax (value:Number):void
		{
			acceleration.x = value;
		}

		public function get ax ():Number
		{
			return acceleration.x;
		}

		public function set ay (value:Number):void
		{
			acceleration.y = value;
		}

		public function get ay ():Number
		{
			return acceleration.y;
		}

		public function set az (value:Number):void
		{
			acceleration.z = value;
		}

		public function get az ():Number
		{
			return acceleration.z;
		}


	}
}