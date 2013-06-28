package com.intuitStudio.motions.triDimens.core
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;

	import com.intuitStudio.motions.triDimens.core.Point3D;

	public class Vehicle3D extends Point3D
	{
		public static const WRAP:String = "wrap";
		public static const BOUNCE:String = "bounce";
		public static const NONE:String = "doNothing";
		//
		protected var _stage:Stage;

		public var fore:Number = 0;
		public var back:Number = 0;
		public var left:Number = 0;
		public var right:Number = 0;
		public var top:Number = 0;
		public var bottom:Number = 0;

		protected var _velocity:Vector3D;
		protected var _mass:Number = 1.0;
		public var maxSpeed:Number = 100;
		public var edgeBehavior:String = NONE;
		public var hasSteered:Boolean = true;

		public function Vehicle3D (x:Number=0,y:Number=0,z:Number=0)
		{
			super (x,y,z);
			_velocity = new Vector3D();
			draw ();
			//
			if (stage)
			{
				_stage = stage;
				init ();
			}
			else
			{
				addEventListener (Event.ADDED_TO_STAGE,init);
			}
		}

		override protected function init (e:Event=null):void
		{
			if (e)
			{
				removeEventListener (Event.ADDED_TO_STAGE,init);
				var container:DisplayObjectContainer = e.target.parent as DisplayObjectContainer;
				if (container is Stage)
				{
					_stage = container as Stage;
				}
			}
			//
			if (_stage)
			{
				fore = 1000;
				back = -1000;
				left = 0;
				right = _stage.stageWidth;
				top = 0;
				bottom = _stage.stageHeight;
			}

		}

		protected function draw ():void
		{
			var commands:Vector.<int> = new Vector.<int>();
			commands.push (GraphicsPathCommand.MOVE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);

			var data:Vector.<Number> = new Vector.<Number>();
			data.push (10,0);
			data.push (-10,5);
			data.push (-10,-5);
			data.push (10,0);

			var g:Graphics = this.graphics;
			g.clear ();
			g.lineStyle ( 1,0xFFFFFF);
			g.drawPath (commands,data);
		}

		public function truncateV3 (v3:Vector3D,value:Number):Vector3D
		{
			var len:Number = Math.min(v3.length,value);
			v3.normalize ();
			v3.scaleBy (len);
			return v3;
		}

		public function set velocity (speed:Vector3D):void
		{
			_velocity = speed.clone();
		}

		public function get velocity ():Vector3D
		{
			return _velocity;
		}

		public function set mass (value:Number):void
		{
			_mass = value;
		}

		public function get mass ():Number
		{
			return _mass;
		}

		public function update (elapsed:Number=1.0):void
		{
			//1.update position
			//truncateV3 (velocity,maxSpeed);
			var desireVel:Vector3D = velocity.clone();
			desireVel.scaleBy (elapsed);
			location = location.add(desireVel);
			//2.update rotation
			if (hasSteered)
			{
				var angle:Number = Math.atan2(velocity.y,velocity.x);
				var cos:Number = Math.cos(angle);
				var sin:Number = Math.sin(angle);
				this.transform.matrix = new Matrix(cos,sin, -  sin,cos,x,y);
			}
			//3.call edge behavior function
			if (edgeBehavior != NONE)
			{
				this[edgeBehavior]();
			}
		}

		override public function render ():void
		{
			super.render ();
		}

		private function wrap ():void
		{
			if (location.x > right)
			{
				location.x = left;
			}
			if (location.x < left)
			{
				location.x = right;
			}
			if (location.y > bottom)
			{
				location.y = top;
			}
			if (location.y < top)
			{
				location.y = bottom;
			}
			if (location.z > fore)
			{
				location.z = back;
			}
			if (location.z < back)
			{
				location.z = fore;
			}
		}

		private function bounce ():void
		{
			if (location.x > right - width)
			{
				location.x = right - width;
				velocity.x *=  -1;
			}
			if (location.x < left + width)
			{
				location.x = left + width;
				velocity.x *=  -1;
			}
			if (location.y > bottom - height)
			{
				location.y = bottom - height;
				velocity.y *=  -1;
			}
			if (location.y < top + height)
			{
				location.y = top + height;
				velocity.y *=  -1;
			}
			if (location.z > fore)
			{
				location.z = fore;
				velocity.z *=  -1;
			}
			if (location.z < back)
			{
				location.z = back;
				velocity.z *=  -1;
			}

		}

		override public function toString ():String
		{
			return '[Vehicle3D]  x: '+location.x+" y: "+location.y+" z: "+location.z;
		}

	}
}