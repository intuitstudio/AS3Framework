package com.intuitStudio.motions.biDimen.core
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	
	/**
	 * Class BaseParticle
	 * @author vanier peng
	 * purpose: 基礎的粒子物件，具有一般的物理運動特性和方法
	 */
	
	public class BaseParticle extends Spot2D
	{
		private var _mass:Number = 1;
		private var _vel:Vector2D = new Vector2D(0, 0);
		private var _acc:Vector2D = new Vector2D(0, 0);
		private var _vr:Number = 0;
		private var _rotation:Number = 0;
		private var _maxSpeed:Number = 20;
		private var _thrust:Number = 0; //所受的推力		
		//基本物理運動屬性
		private var _gravity:Number = 2;
		private var _friction:Number = 0.95;
		private var _bounce:Number = -1.0;
		private var _easing:Number = 0.1;
		private var _spring:Number = 0.03;
		private var _springLength:Number = 0;
		//視覺呈現
		protected var _canvas:DisplayObject;
		
		public function BaseParticle(xLoc:Number = 0, yLoc:Number = 0)
		{
			super(xLoc, yLoc);
		}
		
		public function get content():DisplayObject
		{
			return _canvas;
		}
		
		public function set content(context:DisplayObject):void
		{
			_canvas = context;
		}
		
		public function get mass():Number
		{
			return _mass;
		}
		
		public function set mass(value:Number):void
		{
			_mass = value;
		}
		
		public function get gravity():Number
		{
			return _gravity;
		}
		
		public function set gravity(value:Number):void
		{
			_gravity = value;
		}
		
		public function get friction():Number
		{
			return _friction;
		}
		
		public function set friction(value:Number):void
		{
			_friction = value;
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
		
		public function get springLength():Number
		{
			return _springLength;
		}
		
		public function set springLength(value:Number):void
		{
			_springLength = value;
		}
		
		public function get location():Vector2D
		{
			return new Vector2D(x, y);
		}
		
		public function set location(v2:Vector2D):void
		{
			x = v2.x;
			y = v2.y;
		}
		
		public function get velocity():Vector2D
		{
			return _vel;
		}
		
		public function set velocity(v2:Vector2D):void
		{
			_vel = v2.clone();
		}
		
		public function set rotateSpeed(value:Number):void
		{
			_vr = value;
		}
		
		public function get rotateSpeed():Number
		{
			return _vr;
		}
		
		public function get accelation():Vector2D
		{
			return _acc;
		}
		
		public function set accelation(v2:Vector2D):void
		{
			_acc = v2.clone();
		}
		
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		public function set maxSpeed(value:Number):void
		{
			_maxSpeed = value;
			_vel = _vel.truncate(_maxSpeed).clone();
		}
		
		/**
		 * 外部推力
		 * @param	{value} 純量
		 */
		public function pushForce(value:Number):void
		{
			_thrust = value;
			accelation = (_thrust == 0) ? new Vector2D() : makeThrust();
		}
		
		private function makeThrust():Vector2D
		{
			var acc:Vector2D = new Vector2D();
			
			acc.x = Math.cos(_rotation) * _thrust;
			acc.y = Math.sin(_rotation) * _thrust;
			return acc;
		}
		
		public function steer(value:Number):void
		{
			_vr = value;
		}
		
		public function stopSteer():void
		{
			_vr = 0;
		}
		
		/**
		 * 引用摩摖力公式來計算速度的變化，有simple(預設),real兩種計算方式
		 * @param	{value} friction Number
		 * @param	{type} 'simle' or 'real'
		 */
		public function applyRub(value:Number, type:String = 'simple'):void
		{
			if ('simple' == type)
			{
				velocity = velocity.multiply(value);
			}
			else
			{
				var speed:Number = velocity.length;
				var angle:Number = velocity.angle;
				speed = (speed > value) ? (speed - value) : 0;
				velocity.x = Math.cos(angle) * speed;
				velocity.y = Math.sin(angle) * speed;
			}
		}
		
		/**
		 * 基本的速度變化，僅考慮加速度、時間、最大速度等條件，不考慮摩擦力、重力等外力影響
		 * @param	{elapsed} , time duration
		 */
		protected function checkVelocity(elapsed:Number):void
		{					
			if (!accelation.isZero())
			{
				velocity = velocity.add(accelation);
			}
			if (elapsed != 1)
			{
				velocity = velocity.multiply(elapsed);
			}
             
			if (friction != 0)
			{
			    velocity = velocity.multiply(friction);	
			}
			
			if (gravity != 0) {
				velocity.y += gravity;
			}	

		}
		
		/**
		 * calcute particle's velocity which is never over maxSpeed,and move particle position
		 * @param	{elapsed} duration
		 */
		public function update(elapsed:Number = 1.0):void
		{
			_rotation += _vr * Math.PI / 180;
			checkVelocity(elapsed);
			if (maxSpeed > 0)
			{
				velocity.truncate(maxSpeed);
			}	
			location = location.add(velocity);
		}
		
		public function rendering():void
		{
			if (_canvas)
			{
				_canvas.x = x;
				_canvas.y = y;
				_canvas.rotation = _rotation * 180 / Math.PI; //in degree
			}
		}
		
		override public function draw(context:DisplayObject = null):void
		{
            content = context;	
			super.draw(context);
		}
	
	}

}