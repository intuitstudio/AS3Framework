package com.intuitStudio.kinematics.core
{
	/**
	 * Segment Class
	 * @author vanier peng,2013.4.17
	 * Kinematics 運動學的基礎關節零件，用來計算關節的運動軌跡和位置
	 *
	 */
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Point;
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.biMotion.core.BaseParticle;
	import com.intuitStudio.utils.MathTools;
	import com.intuitStudio.utils.VectorUtils;
	
	public class Segment extends BaseParticle
	{
		private var _color:uint;
		private var _instance:Sprite;
		
		public function Segment(w:Number, h:Number = 20, color:uint = 0x000000, x:Number = 0, y:Number = 0)
		{
			 super(x,y);
			 width = w;
			 height = h;
			 _color = color;
			 gravity = 0;
		}
		
		public function get instance():Sprite
		{
			if (_instance === null)
			{
				_instance = new Sprite();
			}
			return _instance;
		}		
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}
		
		//---- public interface methods ---------------
		
		override protected function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
				var gs:Graphics;
				var h:Number = height;
				var d:Number = width + h;
				var cr:Number = height >> 1;
				
				if (context is Sprite)
				{
					Sprite(context).x = x;
					Sprite(context).y = y;
 				    Sprite(context).rotation = rotation*MathTools.TODEGREE;				 
					gs = Sprite(context).graphics;
				}
				if (context is Shape)
				{
					Shape(context).rotation = rotation*MathTools.TODEGREE;
					Shape(context).x = x;
					Shape(context).y = y;
					gs = Shape(context).graphics;
				}
				
				with (gs)
				{
					clear();
					// 繪製關節
					lineStyle(0);
					beginFill(color);
					drawRoundRect(-cr, -cr, d, h, h, h);
					endFill();
					// 繪製兩個"樞軸"
					beginFill(0x000000);
					drawCircle(0, 0, 2);
					endFill();
					drawCircle(width, 0, 2);
				}				
			}
		
		}
		
		public function getPin():Vector2d
		{
			var point:Point = Point.polar(width, rotation);
			var diff:Vector2d = new Vector2d(point.x,point.y);
			return location.add(diff);
		}
		
		//----  Static Class methods  -----------
		public static function reach(seg:Segment, dest:Vector2d):Vector2d
		{
			var diff:Vector2d = dest.subtract(seg.location);
			//var diff:Vector2d = dest.subtract(seg.location).multiply(2);			
			seg.rotation = diff.angle;
			var size:Vector2d = seg.getPin().subtract(seg.location);
			return dest.subtract(size);
		}
		
		public static function position(segA:Segment, segB:Segment):void
		{
			var sensitive:int = -6;
			if (segB.getPin().y < -sensitive) {
				segA.location = segB.getPin();
			}else {
				//trace( 'position >> over sensitive');
				segA.x = segB.x + segA.width * (segB.getPin().x > 0?1: -1);
				segA.y += segA.y * -.5;
			}
			
			
			//segA.location = segB.getPin();		 
		}		

		/** 
		 * 拖動兩端自由的chain結構
		 * @param	{Vector.<Segment>} ,chain向量陣列結構
		 * @param	{Vector2d} ,dest 輸入的起始點以及用來暫存各節座標位置用的變數
		 *  計算各節的運動位置時，將reach動作與position動作分開處理，可以減少快速動作時關節脫節的小問題
		 */		
		public static function dragChain(chains:Vector.<Segment>, dest:Vector2d):void
		{		
			chains.forEach(function(item:Segment, index:int, vector:Vector.<Segment>):void {
				dest = Segment.reach(item, dest);				
				item.location = dest;				
			});
		}
		
		/** 
		 * 搖動一端固定另端自由的chain結構
		 * @param	{Vector.<Segment>} ,chain向量陣列結構
		 * @param	{Vector2d} ,dest 輸入的起始點以及用來暫存各節座標位置用的變數
		 *  計算各節的運動位置時，將reach動作與position動作分開處理，可以減少快速動作時關節脫節的小問題
		 */
		public static function rollChain(chains:Vector.<Segment>,dest:Vector2d):void
        {  			
			dest = Segment.reach(chains[0],dest);
			chains.forEach(function(item:Segment, index:int, vector:Vector.<Segment>):void {
				if (index!== 0)
				{
				   dest = Segment.reach(item, dest);	
				}
			});
		
			for (var i:int = chains.length - 1; i >0; --i)
			{
  			   Segment.position(chains[i - 1], chains[i]);
			}	
			 
	    }
		
		/**
		 * 由兩個segments所組成的Arm結構，彼此以IK的物理運動連結，其中IK的計算方式採用餘弦定理
		 * @param {Segment,Segment,Vecor2d,Boolean} , segA為基地端，segB為自由端 , dest為欲到達的目標位置向量,antiClockwise 表示是否逆時針方向彎曲
		 */
		public static function reachArm(chains:Vector.<Segment>, dest:Vector2d, antiClockwise:Boolean):Vector2d
		{
			var diff:Vector2d = dest.subtract(chains[1].location);
			var a:Number = chains[0].width;
			var b:Number = chains[1].width;
			var c:Number = Math.min(diff.length, a + b);
			var angleB:Number = Math.acos((a * a + c * c - b * b) / (2 * a * c));
			var angleC:Number = Math.acos((a * a + b * b - c * c) / (2 * a * b));
			var angleD:Number = diff.angle;
			var angleE:Number = 0;
			
			if (!antiClockwise)
			{
				angleE = angleD - angleB + Math.PI - angleC;
				chains[1].rotation = angleD - angleB;
			}
			else
			{
				angleE = angleD + angleB + Math.PI + angleC;
				chains[1].rotation = angleD + angleB;
			}
			
			chains[0].location = chains[1].getPin();
			chains[0].rotation = angleE;
			return chains[0].location;
		}
	
	} //end of class

}