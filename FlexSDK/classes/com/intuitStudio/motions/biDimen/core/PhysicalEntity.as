package com.intuitStudio.motions.biDimen.core
{
	/**
	 * Class MoveEntity
	 * @author vanier peng , 2013.03.02	 *
	 * Purpose : 具有物理性質實體的抽象類別，模擬基本的物理運動、碰撞、彈跳...等操作行為
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.errors.IllegalOperationError;
	
	import com.intuitStudio.motions.biDimen.IF.IMovable;
	
	public class PhysicalEntity extends BaseParticle implements IMovable
	{
		public static const NONE:int = 0;
		public static const BOUNCE:int = 1;
		public static const WRAP:int = 2;
		public static const MOVE_NORMAL:int = 100;
		public static const MOVE_EASING:int = 101;
		public static const MOVE_SPRING:int = 102;
		public static const MOVE_OFFSETSPRING:int = 103;
		
		private var _edgeBehavior:int = BOUNCE;
		private var _margin:Rectangle;
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		public function PhysicalEntity(x:Number = 0, y:Number = 0, w:Number = -1, h:Number = -1)
		{
			super(x, y);
			_width = w;
			_height = h;
		}
		
		public function clone():MoveEntity
		{
			var copy:MoveEntity = new MoveEntity();
			copy.location = this.location;
			copy.velocity = this.velocity;
			copy.accelation = this.accelation;
			copy.maxSpeed = this.maxSpeed;
			copy.margin = this.margin;
			copy.friction = this.friction;
			copy.gravity = this.gravity;
			copy.mass = this.mass;
			
			if (this.content)
			{
				var body:Sprite = new Sprite();
				this.content.parent.addChild(body);
				copy.content = body;
			}
			return copy;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function get margin():Rectangle
		{
			return _margin;
		}
		
		public function set margin(rect:Rectangle):void
		{
			_margin = rect;
		}
		
		public function set boundary(rect:Rectangle):void
		{
			margin = checkMargin(rect);
		}
		
		public function get edgeAct():int
		{
			return _edgeBehavior;
		}
		
		public function set edgeAct(typeId:int):void
		{
			_edgeBehavior = typeId;
		}
		
		public function applyBounce():void
		{
			if (margin)
			{
				if (x > margin.right)
				{
					x = margin.right;
					velocity.x *= bounce;
				}
				else if (x < margin.left)
				{
					x = margin.left;
					velocity.x *= bounce;
				}
				if (y > margin.bottom)
				{
					y = margin.bottom;
					velocity.y *= bounce;
				}
				else if (y < margin.top)
				{
					y = margin.top;
					velocity.y *= bounce;
				}
			}
		}
		
		public function applyWrap():void
		{
			if (margin)
			{
				if (x > margin.right)
				{
					x = margin.left;
				}
				else if (x < margin.left)
				{
					x = margin.right;
				}
				if (y > margin.bottom)
				{
					y = margin.top;
				}
				else if (y < margin.top)
				{
					y = margin.bottom;
				}
			}
		}
		
		protected function applyEasing(point:Point):void
		{
			var dx:Number = point.x - x;
			var dy:Number = point.y - y;
			if (Math.abs(dx) < 1)
			{
				velocity.x = 0
			}
			else
			{
				velocity.x = dx * easing;
			}
			
			if (Math.abs(dy) < 1)
			{
				velocity.y = 0
			}
			else
			{
				velocity.y = dy * easing;
			}
		}
		
		protected function applySpring(point:Point):void
		{
			var dx:Number = point.x - x;
			var dy:Number = point.y - y;
			
			if (Math.abs(dx) < 1)
			{
				accelation.x = 0
			}
			else
			{
				accelation.x = dx * spring;
			}
			
			if (Math.abs(dy) < 1)
			{
				accelation.y = 0
			}
			else
			{
				accelation.y = dy * spring;
			}
		}
		
		protected function applyOffsetSpring(point:Point):void
		{
			var dx:Number = x - point.x;
			var dy:Number = y - point.y;
			var angle:Number = Math.atan2(dy, dx); //in radial
			var destX:Number = point.x + Math.cos(angle) * springLength;
			var destY:Number = point.y + Math.sin(angle) * springLength;
			accelation.x = (destX - x) * spring;
			accelation.y = (destY - y) * spring;
		}
		
		/**
		 * calcute object's velocity which is never over maxSpeed,and move object position
		 * @param	{elapsed} duration
		 */
		override public function update(elapsed:Number = 1.0):void
		{
			//_rotation += _vr * Math.PI / 180;
			//checkVelocity(elapsed);
			//location = location.add(velocity);
			super.update(elapsed);
			checkEdge();
		
		}
		

		
		/**
		 * 基本的速度變化，僅考慮加速度、時間、最大速度等條件，不考慮摩擦力、重力等外力影響
		 * @param	{elapsed} , time duration
		 */
		override protected function checkVelocity(elapsed:Number):void
		{
			super.checkVelocity(elapsed);
			
			//計算摩擦力
			if (friction > 0)
			{
				applyRub(friction);
			}
			//計算重力
			if (gravity > 0)
			{
				velocity.y += gravity;
			}
		}
		
		private function checkEdge():void
		{
			margin ||= checkMargin();
			
			switch (edgeAct)
			{
				case BOUNCE: 
					applyBounce();
					break;
				case WRAP: 
					applyWrap();
					break;
				default: 
					break;
			}
		}
		
		/**
		 * 計算物體運動的邊界值範圍，通常是由實際邊界值減去物體的寬高度
		 * @return {Rectangle}
		 */
		protected function checkMargin(rect:Rectangle = null):Rectangle
		{
			var bound:Rectangle;
			// when boundary is not defined , try to use stage 
			if (null == rect && null == margin && content.stage)
			{
				bound = new Rectangle(0, 0, content.stage.stageWidth, content.stage.stageHeight);
			}
			else
			{
				bound = rect.clone();
			}
			
			//TODO : object moving margin
			if (bound)
			{
				var w:Number = content.width;
				var h:Number = content.height;
				bound.left += (w >> 1);
				bound.top += (h >> 1);
				bound.right -= (w >> 1);
				bound.bottom -= (h >> 1);
			}
			
			//trace('邊界值 ' + bound.toString());
			return bound;
		}
		
		override protected function doDraw(context:DisplayObject):void
		{
			
			super.doDraw(context);
			if (width === -1 || height === -1)
			{
				width = content.width;
				height = content.height;
			}
		}
	
	}

}