package com.intuitStudio.flip.core 
{
	/**
	 * BlankPage Class
	 * @author vanier peng,2013.4.23
	 * 空白頁面,本身
	 */
	

	import com.intuitStudio.flip.abstracts.FlipPageContainer;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import com.intuitStudio.utils.ColorUtils;
	
	public class BlankPage extends FlipPageContainer
	{
				
		public function BlankPage(w:Number,h:Number,shadowed:Boolean=true) 
		{
	        super(w<<1,h,shadowed);
		}
		
		
		public function rendering(context:DisplayObject=null):void
		{
           drawShadows();
		   draw(context);
		}
		
		private function drawShadows():void
		{
		   var destX :Number = x + (width >> 1);
		   if (_shadowL) {
			   _shadowL.locate(destX, y);
			   _shadowL.rendering();			  
		   }
		   if (_shadowR) {
			    _shadowR.locate(destX, y);
			   _shadowR.rendering();
		   }
		}
		
		protected function draw(context:DisplayObject):void
		{
			
			if (context.hasOwnProperty('graphics'))
			{
			   
				
			}

			 
			with (drawingBuffer.graphics)
			{
				clear();
				beginFill(_color);
				drawRect(0,0,width, height);
				endFill();
			}
			
            //draw background;
			if (_canvasData == null) {
				_canvasData = new BitmapData(width, height, true, 0);
			}
			_canvasData.draw(context);
			
		}
		
		
		
	}

}