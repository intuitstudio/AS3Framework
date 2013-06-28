package com.intuitStudio.motions._biDimens.core
{
	import flash.display.Graphics;
	import flash.geom.Point;

	public class Vector2D
	{
		private var _x:Number;
		private var _y:Number;

		public function Vector2D (x:Number=0,y:Number=0)
		{
			_x = x;
			_y = y;
		}

		public function set x (value:Number):void
		{
			_x = value;
		}

		public function get x ():Number
		{
			return _x;
		}

		public function set y (value:Number):void
		{
			_y = value;
		}

		public function get y ():Number
		{
			return _y;
		}

		//-----------------------------------------
		public function draw (graphics:Graphics,color:uint):void
		{
			graphics.clear ();
			graphics.lineStyle (0,color);
			graphics.moveTo (0,0);
			graphics.lineTo (x,y);
		}

		public function clone ():Vector2D
		{
			return new Vector2D(x,y);
		}

		public function zero ():Vector2D
		{
			x = 0;
			y = 0;
			return this;
		}

		public function isZero ():Boolean
		{
			return x==0 && y==0;
		}

		public function get length ():Number
		{
			return Math.sqrt(lengthSQ);
		}

		//magnitude change does not alter vector's angle
		public function set length (value:Number):void
		{
			var a:Number = angle;
			x = Math.cos(a) * value;
			y = Math.sin(a) * value;
		}

		public function get lengthSQ ():Number
		{
			return x*x+y*y;
		}

		//change angle will change vector's direction,but does not alter vector's magnitude
		public function set angle (radian:Number):void
		{
			var magnitude:Number = length;
			x = Math.cos(radian) * magnitude;
			y = Math.sin(radian) * magnitude;
		}

		public function get angle ():Number
		{
			return Math.atan2(y,x);
		}

		public function normalize ():Vector2D
		{
			if (length == 0)
			{
				x = 1;
			}
			else
			{
				var magnitude:Number = length;
				x /=  magnitude;
				y /=  magnitude;
			}
			return this;
		}

		public function isNormalized ():Boolean
		{
			return length==1.0;
		}

		public function truncate (max:Number):Vector2D
		{
			length = Math.min(max,length);
			return this;
		}

		public function reverse ():Vector2D
		{
			x =  -  x;
			y =  -  y;
			return this;
		}

		public function dotProd (v2:Vector2D):Number
		{
			return x*v2.x+y*v2.y;
		}

		public function crossProd (v2:Vector2D):Number
		{
			return x*v2.y-y*v2.x;
		}

		public static function angleBetween (v1:Vector2D,v2:Vector2D):Number
		{
			if (! v1.isNormalized())
			{
				v1 = v1.clone().normalize();
			}
			if (! v2.isNormalized())
			{
				v2 = v2.clone().normalize();
			}
			return Math.acos(v1.dotProd(v2));
		}

		public function sign (v2:Vector2D):int
		{
			return perp.dotProd(v2)<0?-1:1;
		}

		public function get perp ():Vector2D
		{
			return new Vector2D(-y,x);
		}

		public function distance (v2:Vector2D):Number
		{
			return Math.sqrt(distanceSQ(v2));
		}

		public function distanceSQ (v2:Vector2D):Number
		{
			var dx:Number = v2.x - x;
			var dy:Number = v2.y - y;
			return dx*dx+dy*dy;
		}

		public function add (v2:Vector2D):Vector2D
		{
			return new Vector2D(x+v2.x,y+v2.y);
		}

		public function subtract (v2:Vector2D):Vector2D
		{
			return new Vector2D(x-v2.x,y-v2.y);
		}

		public function multiply (value:Number):Vector2D
		{
			return new Vector2D(x*value,y*value);
		}

		public function divide (value:Number):Vector2D
		{
			return new Vector2D(x/value,y/value);
		}

		public function equals (v2:Vector2D):Boolean
		{
			return (x==v2.x && y==v2.y);
		}
		
		public static function pointToVector(point:Point):Vector2D
		{
			return new Vector2D(point.x,point.y);
		}

		public function toString ():String
		{
			return "[ Vector2D : x: "+x+" y: "+y+" ]";
		}

	}

}