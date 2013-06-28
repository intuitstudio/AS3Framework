package com.intuitStudio.kinematics.core 
{
	/**
	 * IK Class
	 * @author vanier peng,2013.4.23
	 * 用來計算翻頁的運動軌跡動態
	 */
	
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.biMotion.core.Point2d;
	import com.intuitStudio.kinematics.core.Segment;
	import com.intuitStudio.utils.ColorUtils;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class IK 
	{
	    private var _segments:Vector.<Segment> = new Vector.<Segment>();
		private var _boxes:Vector.<Shape> = new Vector.<Shape>();
		private var _locusPoints:Vector.<Point2d> = new Vector.<Point2d>();
        private var _range:Number = 0 ;
		private var _numSegments:int = 0;
		
		public function IK(wild:Number,numSegs:int=7) 
		{
		   range = wild;
		   ns = numSegs;
		   makeSegments();
		}
		
		public function get range():Number
		{
			return _range;
		}
		
		public function set range(value:Number):void
		{
			_range = value;
		}
		
		public function get ns():int
		{
			return _numSegments;
		}
		
		public function set ns(value:int):void
		{
			_numSegments = value;
		}
		
		public function get segments():Vector.<Segment>
		{
			return _segments;
		}
		
		public function set segments(segs:Vector.<Segment>):void
		{
			_segments = segs;
		}		
		
		public function get boxes():Vector.<Shape>
		{
			return _boxes;
		}
		
	    public function set boxes(collects:Vector.<Shape>):void
		{
			_boxes = collects;
		}		
		
		public function get locusPoints():Vector.<Point2d>
		{
			return _locusPoints;
		}
		
		public function set locusPoints(collects:Vector.<Point2d>):void
		{
			_locusPoints = collects;
		}
		
		private function makeSegments():void
		{
			segments = new Vector.<Segment>();
			boxes = new Vector.<Shape>();
			locusPoints = new Vector.<Point2d>();
			for (var i:int = 0; i<ns; i++) {
				var seg:Segment = new Segment(range,10,ColorUtils.random());
				segments.push(seg);
				boxes.push(new Shape());
			    locusPoints.push(new Point2d());
			}			 
		}
		
		public function roll(dest:Vector2d, elapsed:Number = 1.0):void
		{
			Segment.rollChain(segments, dest);

			update(elapsed);		
	
		}
		
		public function drag(dest:Vector2d, elapsed:Number=1.0):void
		{
			Segment.dragChain(segments, dest);
		}
		
		public function update(elapsed:Number = 1.0):void
		{  
			 segments.forEach(function(item:Segment, index:int, vector:Vector.<Segment>):void {
			    locusPoints[index].x = item.x;
				locusPoints[index].y = item.y;
			 });
		 
		}
		
		public function rendering(context:DisplayObject):void
		{
			draw(context);			
		}
		
		protected function draw(context:DisplayObject):void
		{
			if (context is Sprite || context is Shape) {
				var container:DisplayObjectContainer = context as DisplayObjectContainer;
			}
			
			boxes.forEach(function(box:Shape, index:int, vector:Vector.<Shape>):void {
				if (!container.contains(box)) {
					container.addChild(box);
				}				
			});
			
			segments.forEach(function(item:Segment, index:int, vector:Vector.<Segment>):void {
			     item.rendering(boxes[index]);				
			});			
		}		
		
	}

}