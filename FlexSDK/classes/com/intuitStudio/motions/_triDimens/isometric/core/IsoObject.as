package com.intuitStudio.motions.triDimens.isometric.core
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;

	import com.intuitStudio.motions.triDimens.isometric.IsoUtils;
	import com.intuitStudio.motions.triDimens.interfaces.IVehicle3D;
	import com.intuitStudio.motions.biDimens.core.Vector2D;
	import com.intuitStudio.motions.triDimens.isometric.core.DrawnIsoTile;
	import com.intuitStudio.motions.triDimens.isometric.concretes.IsoWorld;
	import com.intuitStudio.motions.triDimens.isometric.concretes.DrawnIsoBox;
	import com.intuitStudio.motions.triDimens.isometric.concretes.SteeredDrawnIsoBox;
	import com.intuitStudio.motions.triDimens.isometric.concretes.DrawnIsoCircle;
	import com.intuitStudio.motions.triDimens.isometric.concretes.GraphicTile;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.triDimens.core.Velocity3D;

	public class IsoObject extends Sprite implements IVehicle3D
	{
		public static const DRAWNISOTILE:int = 0;
		public static const DRAWNISOCIRCLE:int = 1;
		public static const DRAWNISOBOX:int = 2;
		public static const STEEREDDRAWNISOBOX:int = 3;
		public static const GRAPHICTILE:int = 4;

		public static const WRAP:String = "wrap";
		public static const BOUNCE:String = "bounce";
		public static const NONE:String = "doNothing";
		//use foot unit replace the pixel unit to calculate the location and velocity 
		private var _location:Vector3D;
		private var _velocity:Velocity3D;
		private var _sqareSize:Number;
		private var _floor:Number = 0;//0 is floor ,1 is obstacle
		private var _mass:Number = 1.0;
		public var canWalk:Boolean = false;
		protected var drawCount:uint = 0;
		public var edgeBehavior:String = BOUNCE;

		public static var TileClassBook:Dictionary;
		public static var TileClassIndex:Dictionary;

		public function IsoObject (size:Number)
		{
			_sqareSize = size;
			init ();
		}

		protected function init ():void
		{
			location = new Vector3D();
			_velocity = new Velocity3D();
			_velocity.integrateWay = Velocity3D.VELOCITY_RK2;
			registerTileClasses ();
			draw ();
		}

		protected function registerTileClasses ():void
		{
			TileClassBook = new Dictionary();
			TileClassIndex = new Dictionary();
			//
			registerTile (IsoObject.DRAWNISOTILE,'DrawnIsoTile',DrawnIsoTile);
			registerTile (IsoObject.DRAWNISOCIRCLE,'DrawnIsoCircle',DrawnIsoCircle);
			registerTile (IsoObject.DRAWNISOBOX,'DrawnIsoBox',DrawnIsoBox);
			registerTile (IsoObject.STEEREDDRAWNISOBOX,'SteeredDrawnIsoBox',SteeredDrawnIsoBox);
			registerTile (IsoObject.GRAPHICTILE,'GraphicTile',GraphicTile);
		}

		public static function registerTile (key:int,className:String,classSymbol:Class):void
		{
			for (var index:String in TileClassIndex)
			{
				if (key.toString() == index)
				{
					return;
				}
			}
			TileClassIndex[key] = className;
			TileClassBook[className] = classSymbol;
		}

		public static function getTileTableIndex (name:String):int
		{
			for (var key:String in TileClassIndex)
			{
				if (name == TileClassIndex[key])
				{
					return parseInt(key);
				}
			}
			return -1;
		}

		public function draw ():void
		{
			if (drawCount > 0)
			{
				render ();
				drawCount = 0;
			}
		}

		public function update (elapsed:Number=1.0):void
		{
			location = getVelocity().calculate(location,elapsed);
		}

		public function render ():void
		{
			var pos:Point = IsoUtils.isoToScreen(location);
			var loc:Vector2D = new Vector2D(pos.x,pos.y);
			loc = loc.multiply(IsoWorld.pixelsScale);
			super.x = loc.x;
			super.y = loc.y;
		}

		public function set floor (value:Number):void
		{
			_floor = value;
		}

		public function get floor ():Number
		{
			return _floor;
		}

		public function set location (point:Vector3D):void
		{
			_location = point.clone();	
			drawCount++;
		}

		public function get location ():Vector3D
		{
			return _location;
		}

		public function getVelocity ():Velocity3D
		{
			return _velocity;
		}

		public function set velocity (vel:Vector3D):void
		{
			_velocity.velocity = vel;
		}

		public function get velocity ():Vector3D
		{
			return _velocity.velocity;
		}

		override public function set x (value:Number):void
		{
			location.x = value;
			drawCount++;
		}

		override public function get x ():Number
		{
			return location.x;
		}

		override public function set y (value:Number):void
		{
			location.y = value;
			drawCount++;
		}

		override public function get y ():Number
		{
			return location.y;
		}

		override public function set z (value:Number):void
		{
			location.z = value;
			drawCount++;
		}

		override public function get z ():Number
		{
			return location.z;
		}

		public function set vx (value:Number):void
		{
			velocity.x = value;
		}

		public function get vx ():Number
		{
			return velocity.x;
		}

		public function set vy (value:Number):void
		{
			velocity.y = value;
		}

		public function get vy ():Number
		{
			return velocity.y;
		}

		public function set vz (value:Number):void
		{
			velocity.z = value;
		}

		public function get vz ():Number
		{
			return velocity.z;
		}

		override public function toString ():String
		{
			return "[IsoObject( x: "+ x +" , y: "+ y + " , z: " + z +" )]";
		}

		public function get depth ():Number
		{			
			return (x+z)*.866-y*.707+floor;
		}

		public function get size ():Number
		{
			return _sqareSize;
		}

		public function get rect ():Rectangle
		{
			//return new Rectangle(x-size*.5,z-size*.5,size,size);

			var pos:Vector2D = Vector2D.pointToVector(IsoUtils.isoToScreen(location));
			pos = pos.multiply(IsoWorld.pixelsScale);
			return new Rectangle(pos.x-size*.5,pos.y-size*.5,size,size);
			//return new Rectangle(x*IsoWorld.pixelsScale-size*.5,z*IsoWorld.pixelsScale-size*.5,size,size);
		}

		public function set mass (value:Number):void
		{
			_mass = value;
		}

		public function get mass ():Number
		{
			return _mass;
		}

		public function clear ():void
		{
			location = null;
			velocity = null;
		}

	}
}