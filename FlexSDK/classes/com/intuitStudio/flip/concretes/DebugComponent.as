package com.intuitStudio.flip.concretes 
{
	/**
	 * DebugComponent Class
	 * @author vanier peng,2013.4.24
	 * 測試用的元件，用來檢視翻頁的運動軌跡路徑
	 */
	
	import com.intuitStudio.flip.abstracts.FlipPageComponent;
	import com.intuitStudio.patterns.Observer.interfaces.IObserver;
	import com.intuitStudio.biMotion.core.BaseParticle;
	import com.intuitStudio.biMotion.core.Vector2d;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class DebugComponent extends FlipPageComponent
	{
		
		public function DebugComponent(w:Number,h:Number) 
		{
		   super(w,h);	
		}
		
		override protected function init():void
		{
			super.init();
			
		}
		
		
		override public function change(...arg):void
		{
			
			
		}
		
		override public function update(elapsed:Number = 1.0):void
		{
			
			
		}
		
		override protected function draw(context:DisplayObject):void
		{
			var container:DisplayObjectContainer = (context is DisplayObjectContainer)?context:null;
			
			if (container === null) return;
			
	        with (drawingBuffer.graphics)
			{
				clear();
				lineStyle(0,0xffffff);
				moveTo(tracker.x,tracker.y);
				for (var i=0; i<locus.length; i++) {
					lineTo(locus[i].x,locus[i].y);
				}
			} 
			
			bufferData.fillRect(bufferData.rect, 0);
			bufferData.draw(drawingBuffer);
            bitmapData = bufferData;
			if (!container.contains(bitmap)) {
				container.addChild(bitmap);
			}
		}
		
	}

}