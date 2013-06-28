package com.intuitStudio.kinematics 
{
	/**
	 * Robot Class
	 * @author vanier peng,2013.4.18
     * 軀體用來包裝RobotFeet物件，繼承PhysicalEntry類別，用來模擬實際走路的動作效果
     * @property  feet ,雙腳元件
     *  
     *  模擬機械雙腳走路的物理動作:
     *  - 靠兩隻大腿的轉動帶動小腿的移動	 
     *  - 當腳底接觸地面時產生反作用力，帶動身體向前運動
	*/
	
	import com.intuitStudio.biMotion.core.BaseParticle;
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.kinematics.core.Segment;
	import com.intuitStudio.utils.MathTools;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	public class Robot extends BaseParticle
	{
		private var _feet:RobotFeet;
		private var _hitFloor:int = 0;
		
		public function Robot(w:Number,h:Number,x:Number=0,y:Number=0) 
		{
			super(x, y);
			feet = new RobotFeet();
			feet.outgrow(w, h);
			edgeReaction = 'WRAP';
		}
		
		public function get feet():RobotFeet
		{
			return _feet;
		}
		
		public function set feet(obj:RobotFeet):void
		{
			_feet = obj;
		}
		
		public function get floorTouch():Number
		{
			return _hitFloor;
		}
		
		public function set floorTouch(value:Number):void
		{
			_hitFloor = value;
		}		
		
		override public function getBounds():Rectangle
		{
			var maxW:Number = feet.leftLeg.strideWidth;
			var maxH:Number = feet.leftLeg.legLength;
			return new Rectangle(x-(maxW>>1),y-(maxH>>1),maxW,maxH);
		}		
		
		override public function setMargin(boundW:Number, boundH:Number):void
		{
			var bounds:Rectangle = getBounds();
			margin = new Rectangle(bounds.width>>1,bounds.height>>1,boundW-(bounds.width>>1),boundH-(bounds.height>>1));
		}
		
		public function get leftFoot():Leg {
			return feet.leftLeg;
		}
		
		public function get rightFoot():Leg
		{
			return feet.rightLeg;
		}
		
		public function get leftThigh():Segment
		{
			return leftFoot.thigh;
		}
		
		public function get leftCalf():Segment
		{
			return leftFoot.calf;
		}

		public function get rightThigh():Segment
		{
			return rightFoot.thigh;
		}
		
		public function get rightCalf():Segment
		{
			return rightFoot.calf;
		}
		
		override public function move(elapsed:Number = 1.0):void
		{
			walking(elapsed);
			update(elapsed);
			checkEdge();
		}
		
		/**
		 * 初始機器人動作設定值
		 * @param {} , 
		 * 注意參數中的角度均為degree,其中cOffset須轉換成為徑度值
		 */		 
		public function makeWalkState(temp:Number, tRange:Number, tBase:Number, cRange:Number, cOffset:Number):void
		{
			feet.makeWalkStage(temp,tRange,tBase,cRange,cOffset*MathTools.TORADIAS);
		}
		
		protected function walking(elapsed:Number):void
		{
			feet.move(elapsed);
			checkFloor(leftFoot, elapsed);
			checkFloor(rightFoot, elapsed);
		}
		
		override public function update(elapsed:Number = 1.0):void
		{
			tuneSpeed(elapsed);
			tuneLocation(elapsed);
		}
		
		override protected function draw(context:DisplayObject):void
		{
			if (context is Sprite)
			{
				context.x = x;
				context.y = y;
				 
				leftFoot.rendering(context);
				rightFoot.rendering(context);
				
			}
			
		}
		
		override protected function tuneSpeed(elapsed:Number=1.0):void
		{
			if (!acceleration.isZero) {
				velocity = velocity.add(acceleration.multiply(elapsed));
			}
			
			if (gravity != 0) {
				vy += (gravity*elapsed);
			}
			
			if (velocity.length > maxSpeed) {
				velocity.truncate(maxSpeed);
			}
		}
		
		protected function checkFloor(foot:Leg, elapsed:Number):void
		{
			var bounds:Rectangle = getBounds();
			//var floor:Number = margin.bottom + bounds.height;
			var floor:Number = margin.bottom;
			var dy:Number = y + foot.footSole.y - floor;
			if (dy > 0) {
				var loc:Vector2d = location;
				loc.y -= dy;
				location = loc;
				
				var vel:Vector2d = foot.velocity;
				vel.x += vel.x * friction ;			 
				velocity = vel.multiply(-1);
				floorTouch++;				
			}			
		}
		
		override protected function applyWrap():void
		{
			if (margin) {
			    var bounds:Rectangle = getBounds();
				var right:Number = margin.right;
				var left:Number = margin.left;
				if (tx > right + bounds.width) {
					tx = left - bounds.width;
				}else if (tx < left - bounds.width) {
					tx = right + bounds.width;
				}
			}
		}
 
	}//end of class

}