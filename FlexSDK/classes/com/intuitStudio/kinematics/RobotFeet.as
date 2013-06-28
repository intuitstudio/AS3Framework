package com.intuitStudio.kinematics 
{
	/**
	 * RobotFeet Class
	 * @author vanier peng,2013.4.18
	 * 模擬雙腳的運動，由最簡單的兩個Legs所組成
	 */
	import com.intuitStudio.biMotion.core.Point2d;
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.kinematics.core.Segment;
	import com.intuitStudio.utils.MathTools; 
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	 
	public class RobotFeet extends Point2d
	{
		private var _legs:Vector.<Leg> = new Vector.<Leg>();
		
		public function RobotFeet(x:Number=0,y:Number=0) 
		{
			super(x,y);
		}

		public function get legs():Vector.<Leg>
		{
		   return _legs;	
		}
		
		public function get leftLeg():Leg {
			return legs[0];
		}
		
		public function get rightLeg():Leg {
			return legs[1];
		}
		
		public function get location():Vector2d
		{
			return new Vector2d(x,y);
		}
		
		public function set location(v:Vector2d):void
		{
		    x = v.x;
			y = v.y;
		    leftLeg.location = v;
			rightLeg.location = v;
		}
		
		public function outgrow(w:Number,h:Number,color:uint=0xFFFF00):void
		{
			makeLeg(w,h,color);
			makeLeg(w,h,color);
		}
		
		private function makeLeg(w:Number, h:Number, color:uint = 0xFFFF00):Leg
		{
			var leg:Leg = new Leg();
			leg.outgrow(w, h, color);
			legs.push(leg);
			return leg;
		}
		
		public function move(elapsed:Number = 1.0):void
		{
			walking(elapsed);
		}
		
		public function walking(elapsed:Number = 1.0):void
		{
		   rightLeg.cycle = leftLeg.cycle + MathTools.PI;
		   leftLeg.walking(elapsed);
		   rightLeg.walking(elapsed);
		}
		
		public function makeWalkStage(temp:Number, tRange:Number, tBase:Number, cRange:Number, cOffset:Number):void
		{
		   leftLeg.tempo = rightLeg.tempo = temp;
		   leftLeg.thighRange = rightLeg.thighRange = tRange;
		   leftLeg.thighBase = rightLeg.thighBase = tBase;
		   leftLeg.calfRange = rightLeg.calfRange = cRange;
		   leftLeg.calfOffset = rightLeg.calfOffset = cOffset;
		}
		
		override protected function draw(context:DisplayObject):void
		{
			//context.x = x;
			//context.y = y;
			if (context is Sprite) {
				
			}
			//leftLeg.location = location;
			//rightLeg.location = location;
			trace('feet pos ' + location.toString());
			
			leftLeg.rendering(context);
			rightLeg.rendering(context);			
		}
		
	}//end of class

}