package com.intuitStudio.biMotion.core 
{
	import com.intuitStudio.utils.MathTools;
	import flash.concurrent.Mutex;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	/**
	 * BaseParticle Class
	 * @author vanier peng,2013.4.17
	 * 應用基本的物理特性及運動行為的基本粒子抽象類別，做為平面物體的基礎類別
	 * 
	 */
	public class BaseParticle extends Point2d
	{
		private var _radius:Number = 10;
		private var _lastPoint:Point2d = new Point2d();
		private var _vel:Vector2d = new Vector2d();
		private var _acc:Vector2d = new Vector2d();
		private var _vr:Number = 0;
		private var _rotation:Number = 0;//radian
		private var _maxSpeed:Number = 100;
		private var _force:Vector2d = new Vector2d();
		private var _maxForce:Number = 0;
		private var _gravity:Number = 2;
		private var _friction:Number = .95;
		private var _bounce:Number = -.9;
		private var _easing:Number = .1;
		private var _spring:Number = .03;
		private var _springLength:Number = 0;
		private var _edgeBehavior:String = 'BOUNCE';
		private var _margin:Rectangle;
		private var _minDist:Number = 1;
		private var _perPixels:uint = 1;
		private var _visible:Boolean = true;
		protected var dragging:Boolean = false;
		protected var draggable:Boolean = false;
		private var _strategy:Function;		
		
		public function BaseParticle(x:Number=0,y:Number=0) 
		{
			super(x, y);
			strategy = update;
		}
		
		override public function clone():Point 
		{
		   var particle:BaseParticle = new BaseParticle(x, y);
		   return particle;
		}
		
		public function get pixelUnit():int {
			return _perPixels;
		}
		
		public function set pixelUnit(value:int):void {
			_perPixels = value;
		}
		
		public function get location():Vector2d {
			return new Vector2d(x,y);			
		}
		
		public function set location(v:Vector2d):void
		{
			x = tx = v.x;
			y = ty = v.y;
		}
		
		public function get bufferPoint():Vector2d
		{
			return new Vector2d(tx,ty);
		}
		
		public function set bufferPoint(v:Vector2d):void
		{
			tx = v.x;
			ty = v.y;
		}
		
		public function get lastPoint():Vector2d
		{
			return new Vector2d(_lastPoint.x,_lastPoint.y);
		}
		
		public function set lastPoint(v:Vector2d):void {
			_lastPoint.x = v.x;
			_lastPoint.y = v.y;
		}		
		
		public function get rotation():Number {
			return _rotation;
		}
		
		public function set rotation(degree:Number):void {
			_rotation = degree;
		}
		
		public function get velocity():Vector2d {
			return _vel.clone();
		}
		
		public function set velocity(v:Vector2d):void {
			_vel = v.clone();			
		}
		
		public function get vx():Number
		{
			return _vel.x;
		}
		
		public function set vx(value:Number):void
		{
			_vel.x = value;
		}

		public function get vy():Number
		{
			return _vel.y;
		}
		
		public function set vy(value:Number):void
		{
			_vel.y = value;
		}
		
		public function get vr():Number
		{
			return _vr;
		}
		
		public function set vr(value:Number):void
		{
			_vr = value;
		}
		
		public function get margin():Rectangle
		{
			return _margin;
		}
		
		public function set margin(area:Rectangle):void
		{
			_margin = area;
		}		
		
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		public function set maxSpeed(value:Number):void {
		   _maxSpeed = value;			
		}
		
		public function get maxForce():Number
		{
			return _maxForce;
		}
		
		public function set maxForce(value:Number):void {
		   _maxForce = value;			
		}
		
		public function setAngularSpeed(angle:Number, speed:Number):void
		{
			var pt:Point = Point.polar(speed, angle);
		    velocity = new Vector2d(pt.x,pt.y);	
		}
		
		public function get acceleration():Vector2d {
			return _acc.clone();
		}
		
		public function set acceleration(v:Vector2d):void
		{
		   _acc = v.clone();
		}
		
		public function setAngularAcceleration(angle:Number, thrust:Number):void
		{
			var ft:Point = Point.polar(thrust, thrust);
		    acceleration = new Vector2d(ft.x,ft.y);	
		}		
		
		public function set speedLimit(max:Number):void
		{
			_maxSpeed = max;
			velocity = velocity.truncate(max);
		}
		
		public function setMargin(boundW:Number, boundH:Number):void
		{
			margin = new Rectangle(radius, radius, boundW - radius, boundH - radius);
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
			_radius = value;
		}
		
		public function get strategy():Function
		{
			return _strategy;
		}
		
		public function set strategy(fun:Function):void
		{
			_strategy = fun;
		}
			
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		
		public function get isDragging():Boolean {
			return dragging;
		}
		
		public function set isDragging(value:Boolean):void
		{
			dragging = value;
		}
		
		public function get isDraggable():Boolean
		{
			return draggable;
		}
		
		public function set isDraggable(value:Boolean):void
		{
			draggable = value;
		}
		
		public function get edgeReaction():String {
			return _edgeBehavior;
		}
		
		public function set edgeReaction(value:String):void
		{
			_edgeBehavior = value;
		}
		
		public function get minDist():Number
		{
			return _minDist;
		}
		
		public function set minDist(value:Number):void
		{
			_minDist = value;
		}
		
		public function get friction():Number
		{
			return _friction;
		}
		
		public function set friction(value:Number):void
		{
			_friction = value;
		}
		
		public function get gravity():Number
		{
			return _gravity;
		}
		
		public function set gravity(value:Number):void
		{
			_gravity = value;
		}

		public function get bounce():Number
		{
			return _bounce;
		}
		
		public function set bounce(value:Number):void
		{
			_bounce = value;
		}
		
		public function get easing():Number
		{
			return _easing;
		}

		public function set easing(value:Number):void
		{
			_easing = value;
		}
		
		public function get spring():Number
		{
			return _spring;
		}
		
		public function set spring(value:Number):void
		{
			_spring = value;
		}

		public function get springOff():Number
		{
			return _springLength;
		}
		
		public function set springOff(value:Number):void
		{
			_springLength = value;
		}
		
		public function getBounds():Rectangle {
			return new Rectangle(x-radius,y-radius,radius*2,radius*2);
		}
		
		//------ public interface methods ---------
		public function brownMove():void {
			var diff:Vector2d = new Vector2d(Math.random() * .2 - .1, Math.random() * .2 - .1);
			velocity = velocity.add(diff);
		}
		
		public function move(elapsed:Number = 1.0):void
		{
			
		   strategy(elapsed);
		}
		
		public function update(elapsed:Number = 1.0):void {
		
			tuneRotation();
			tuneSpeed(elapsed);
			tuneLocation(elapsed);
			checkEdge();
			
		}
		
		override public function rendering(context:DisplayObject=null):void
		{
			//	trace('call BaseParticle rendering' ,bufferPoint.toString());
			location = bufferPoint;
			if(visible){draw(context);}
		}
		
		public function steer(degree:Number):void
		{
			vr = degree;
			if (vr != 0) {
				rotation += vr * MathTools.TORADIAS;
			}
		}
		
		/**
		 * 施力,以向量形式
		 * @param	thrust
		 */
		public function setThrust(force:Vector2d):void
		{
			force.truncate(_maxForce);
		    this._force = force;
			acceleration = force.divide(mass);			
		}
		
		public function outspace():void
		{
			friction = 0;
			bounce = -1;
			gravity = 0;			
		}
		
		public function throwOut():void
		{
			velocity = trackVelocity();
			isDragging = false;
		}
		
		public function still():void
		{
			acceleration.zero();
			velocity.zero();
			isDragging = false;
		}
		
		public function trackCursor(point:Point, isrecord:Boolean = false):void
		{
			if (isrecord) { velocity = trackVelocity(); }
			bufferPoint = new Vector2d(point.x,point.y);
		}
		
		private function trackVelocity():Vector2d
		{
		   var tempVel:Vector2d = bufferPoint.subtract(lastPoint);
		   lastPoint = location;
		   return tempVel;
		}
		
		public function moveEasing(point:Point, elapsed:Number=1.0):void
		{
			applyEasing(point);
			update(elapsed);
		}
		
		protected function applyEasing(point:Point):void
		{
		   var dest:Vector2d = new Vector2d(point.x, point.y);
		   var diff:Vector2d = dest.subtract(location);
		   if (diff.length < minDist) {
			   velocity.zero();
			   bufferPoint  = dest;			   
		   }else {
			   velocity = diff.multiply(easing);
		   }
		}
		
		public function moveSpring(point:Point,hasOffset:Boolean = false,elapsed:Number = 1.0):void
		{
			(!hasOffset)?applySpring(point):applyOffsetSpring(point);
			update(elapsed);
		}
		
		public function springTo(point:Point,elapsed:Number = 1.0):void
		{
			var dest:Vector2d = new Vector2d(point.x, point.y);
			var diff:Vector2d = dest.subtract(location);
			var angle:Number = Math.atan2(diff.y,diff.x);
			var offsetPt:Point = Point.polar(springOff, angle);
			diff = dest.subtract(new Vector2d(offsetPt.x, offsetPt.y));
			acceleration = (diff.subtract(bufferPoint)).multiply(spring);
			update(elapsed);
		}
		
		protected function applySpring(point:Point):void
		{
			var dest:Vector2d = new Vector2d(point.x, point.y);
			acceleration = (dest.subtract(bufferPoint)).multiply(spring);
		}
		
		protected function applyOffsetSpring(point:Point):void
		{
			var dest:Vector2d = new Vector2d(point.x, point.y);
			dest = dest.subtract(bufferPoint);
			var angle:Number = Math.atan2(dest.y, dest.x);
			point = point.subtract(Point.polar(springOff, angle));
			applySpring(point);
		}
		
		//---------  protected methods
		override protected function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
               var gs:Graphics;
				if (context is Sprite) {
					gs = Sprite(context).graphics;
					Sprite(context).x = x;
					Sprite(context).y = y;
					Sprite(context).rotation = rotation;
				}
				if (context is Shape) {
					gs = Shape(context).graphics;
					Shape(context).x = x;
					Shape(context).y = y;
					Shape(context).rotation = rotation;
				}							 
								 
								 
				with (gs)
				{
					//clear();
					lineStyle(0);
					beginFill(0xFF0000);
					drawCircle(x - (radius >> 1), y - (radius >> 1), radius);
					endFill();
				}
			}
		}
		
		protected function tuneRotation(elapsed:Number=1.0):void
		{
			rotation += vr * elapsed;	
		}
		
		protected function tuneSpeed(elapsed:Number=1.0):void
		{
		    if (!acceleration.isZero) {
				velocity = velocity.add(acceleration.multiply(elapsed));
			}
			
			if (friction > 0 && friction < 1) {
				applyRub(elapsed);
			}
			
			if (gravity != 0) {
				vy += (gravity*elapsed);
			}
			
			if (velocity.length > _maxSpeed) {
				velocity.truncate(_maxSpeed);
			}
	    }

		protected function tuneLocation(elapsed:Number=1.0):void
		{
			var moment:Vector2d = velocity.multiply(elapsed);
			if ( moment.length * pixelUnit > minDist*.001) {
				 
			    bufferPoint = bufferPoint.add(velocity.multiply(elapsed));	
			}			
		}
		
		protected function checkEdge():void {
			if (margin == null) return;			
			if (edgeReaction === 'BOUNCE') applyBounce();
			if (edgeReaction === 'WRAP') applyWrap();		
		}
		
		protected function applyBounce():void
		{
			if (margin) {
				var left:Number = margin.left;
				var right:Number = margin.right;
				var top:Number = margin.top;
				var bottom:Number = margin.bottom;
		
				if ( bufferPoint.x > right || bufferPoint.x < left) {
					tx = MathTools.clamp(tx, left, right);
					vx *= bounce;				
				}
				
				if ( bufferPoint.y > bottom || bufferPoint.y < top ) {
					ty = MathTools.clamp(ty, top, bottom);
					vy *= bounce;
				}			
			}
		}
		
		protected function applyWrap():void
		{
			if (margin) {
				var left:Number = margin.left;
				var right:Number = margin.right;
				var top:Number = margin.top;
				var bottom:Number = margin.bottom;
				
			    if (bufferPoint.x > right) {
					tx = left;
				} else if (bufferPoint.x < left) {
					tx = left;
				}
				if (bufferPoint.y > bottom) {
					ty = top;
				}else if (bufferPoint.y < top) {
					ty = bottom;
				}
			}
		}

		protected function applyRub(elapsed:Number=1.0,type:String='simple'):void {
			if (type == 'simple') {
			   velocity  = velocity.multiply(friction*elapsed);	
			}
			if (type === 'math') {
				var speed:Number = velocity.length;
				var angle:Number = velocity.angle;
				speed = (speed > friction)?(speed-friction):0;
				var pt:Point = Point.polar(speed, angle);
				velocity = new Vector2d(pt.x, pt.y);
				velocity = velocity.multiply(elapsed);
			}			
		}
		
	}//end of class

}