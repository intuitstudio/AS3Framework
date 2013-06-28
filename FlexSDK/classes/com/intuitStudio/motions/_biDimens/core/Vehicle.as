package com.intuitStudio.motions.biDimens.core
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class Vehicle extends Sprite
	{
		public static const WRAP:String = "wrap";
		public static const BOUNCE:String = "bounce";
		//
		protected var _stage:Stage;
		protected var _area:Rectangle;
		protected var _location:Vector2D;
		protected var _velocity:Vector2D;
		protected var _mass:Number = 1.0;
		public var maxSpeed:Number = 100;
		public var edgeBehavior:String = BOUNCE;


		public function Vehicle (showMe:Boolean=false)
		{
			_location = new Vector2D();
			_velocity = new Vector2D();
			draw (showMe);
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

		protected function init (e:Event=null):void
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
				_area = new Rectangle(0,0,_stage.stageWidth,_stage.stageHeight);			
			}
		}

		protected function draw (valid:Boolean):void
		{
			if (valid)
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
		}

		public function set location (loc:Vector2D):void
		{
			_location = loc;
		}

		public function get location ():Vector2D
		{
			return _location;
		}

		override public function set x (value:Number):void
		{
			super.x = value;
			location.x = value;
		}

		override public function get x ():Number
		{
			return location.x;
		}

		override public function set y (value:Number):void
		{
			super.y = value;
			location.y = value;
		}

		override public function get y ():Number
		{
			return location.y;
		}

		public function set velocity (speed:Vector2D):void
		{
			_velocity = speed;
		}

		public function get velocity ():Vector2D
		{
			return _velocity;
		}

        public function set mass(value:Number):void
		{
			_mass = value;
		}
		
		public function get mass():Number
		{
			return _mass;
		}
		
		public function get boundary ():Rectangle
		{
			return _area;
		}

		public function update (elapsed:Number=1.0):void
		{
			//1.update position
			velocity.truncate (maxSpeed);
			location = location.add(velocity.multiply(elapsed));
			//2.update rotation
			var angle:Number = velocity.angle;
			var cos:Number = Math.cos(angle);
			var sin:Number = Math.sin(angle);
			this.transform.matrix = new Matrix(cos,sin,-sin,cos,location.x,location.y);			
			//3.call edge behavior function
			this[edgeBehavior]();
		}

		public function render ():void
		{
			this.x = location.x;
			this.y = location.y;
		}

		private function wrap ():void
		{
			if (boundary)
			{
				if (location.x > boundary.right)
				{
					location.x = boundary.left;
				}
				if (location.x < boundary.left)
				{
					location.x = boundary.right;
				}
				if (location.y > boundary.bottom)
				{
					location.y = boundary.top;
				}
				if (location.y < boundary.top)
				{
					location.y = boundary.bottom;
				}
			}
		}

		private function bounce ():void
		{
            if(boundary)
			{
				if(location.x > boundary.right-width)
				{
					location.x = boundary.right-width;
					velocity.x *=-1;
				}
				if(location.x < boundary.left+width)
				{
					location.x = boundary.left+width;
					velocity.x *=-1;
				}
				if(location.y > boundary.bottom-height)
				{
					location.y = boundary.bottom-height;
					velocity.y *=-1;
				}
				if(location.y < boundary.top+height)
				{
					location.y = boundary.top+height;
					velocity.y *=-1;
				}
			}
		}

	}
}