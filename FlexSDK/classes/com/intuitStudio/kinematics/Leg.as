package com.intuitStudio.kinematics 
{
	/**
	 * Leg Class
	 * @author vanier peng,2013.4.18
	 *  FK運動的單支腳元件，由最簡單的兩個Segment所組成
	 */
	
	import com.intuitStudio.biMotion.core.Point2d;
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.kinematics.core.Segment;
	import com.intuitStudio.utils.MathTools; 
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	
	public class Leg extends Point2d
	{
	    private var _segments:Vector.<Segment> = new Vector.<Segment>();
		private var _cycle:Number = MathTools.TWOPI/3;
		private var _tempo:Number = .4;
		private var _thighRange:Number = 45;
		private var _thighBase:Number = 90;
		private var _calfRange:Number = 45;
		private var _calfOffset:Number = -MathTools.HALFPI; 
		private var _thighSprite:Sprite = new Sprite();
		private var _calfSprite:Sprite = new Sprite();
		private var _thighShape:Shape = new Shape();
		private var _calfShape:Shape = new Shape();
	
		public function Leg(x:Number=0,y:Number=0) 
		{
		   super(x,y);	
		}
		
		public function get segments():Vector.<Segment>
		{
		   return _segments;	
		}
		
		public function get cycle():Number
		{
			return _cycle;
		}
		
		public function set cycle(value:Number):void
		{
			_cycle = value;
		}

		public function get tempo():Number
		{
			return _tempo;
		}
		
		public function set tempo(value:Number):void
		{
			_tempo = value;
		}

		public function get thighRange():Number
		{
			return _thighRange;
		}
		
		public function set thighRange(value:Number):void
		{
			_thighRange = value;
		}

		public function get thighBase():Number
		{
			return _thighBase;
		}
		
		public function set thighBase(value:Number):void
		{
			_thighBase = value;
		}

		public function get calfRange():Number
		{
			return _calfRange;
		}
		
		public function set calfRange(value:Number):void
		{
			_calfRange = value;
		}

		public function get calfOffset():Number
		{
			return _calfOffset;
		}
		
		public function set calfOffset(value:Number):void
		{
			_calfOffset = value;
		}

		public function get thigh():Segment
		{
			return segments[0];
		}
		
		public function get calf():Segment
		{
		   return segments[1];	
		}
		
		public function get footSole():Vector2d
		{
			return calf.getPin().add(new Vector2d(0,calf.height>>1));
		}
		
		public function get location():Vector2d {
			return new Vector2d(x,y);
		}
		
		public function set location(v:Vector2d):void
		{
			x = tx = v.x;
			y = ty = v.y;
		}
		
		public function get velocity():Vector2d
		{
			return calf.velocity;
		}		
		
		public function get legLength():Number
		{
			return thigh.width + (thigh.height >> 1) + calf.width + (calf.height >> 1);
		}
		
		public function get legHieght():Number
		{
		   return footSole.y;	
		}
		
		public function get legWidth():Number
		{
			return Math.abs(footSole.x);
		}
		
		public function get strideWidth():Number
		{
		   return Math.sin(thighRange*MathTools.TORADIAS) * legLength * 2;	
		}
		
		public function outgrow(w:Number, h:Number, color:uint = 0xFFFF00):void
		{
			makeSegment(w, h, color);
			makeSegment(w, h, color);			
		}
		
		public function move(elapsed:Number=1.0):void
		{
			walking(elapsed);
		}
		
		public function walking(elapsed:Number=1.0):void
		{
			thigh.location = location;
			cycle += tempo;
			walkTo(thigh,calf);
		}
		
		protected function walkTo(segA:Segment, segB:Segment):void
		{
			//trace(cycle, tempo);
			var ft:Vector2d = segB.getPin();
			segA.rotation = thighAngle;
			segB.rotation = segA.rotation + calfAngle;
			segB.location = segA.getPin();
			segB.velocity = segB.getPin().subtract(ft);
			 
		}
		
		public function get thighAngle():Number
		{
			return (Math.sin(cycle)*this.thighRange+this.thighBase)*MathTools.TORADIAS;
		}
		
		public function get calfAngle():Number
		{
		    return (Math.sin(cycle+this.calfOffset)*this.calfRange+this.calfRange)*MathTools.TORADIAS;
		}
		
		private function makeSegment(w:Number,h:Number,color:uint=0xFFFF00):Segment {
		   var seg:Segment = new Segment(w,h,color);
		   segments.push(seg); 
	       return seg;
		}		
	
		override protected function draw(context:DisplayObject):void
		{
			if (context is Sprite) {
				//trace('leg pos ' + location.toString());
			 // var gs:Graphics = (context is Sprite) ? Sprite(context).graphics : (context is Shape) ? Shape(context).graphics : null;
              var contanier:Sprite = Sprite(context);
			  //contanier.x = x;
			  //contanier.y = y;
			  if(!contanier.contains(_thighShape)){
			     contanier.addChild(_thighShape);
			  }
			  if(!contanier.contains(_calfShape)){
			     contanier.addChild(_calfShape);
			  }
			  thigh.rendering(_thighShape);
		  	  calf.rendering(_calfShape);
			}
		}
	}

}