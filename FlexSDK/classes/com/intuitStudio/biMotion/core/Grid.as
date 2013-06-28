package com.intuitStudio.biMotion.core 
{
	import flash.display.DisplayObject;
	/**
	 * Grid Class 
	 * @author vanier peng,2013.4.18
	 * Grid object with column and row make up a map 
	 */
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.utils.Dictionary;
	import flash.display.Graphics;
	
	public class Grid 
	{
	    private var _size:Number = 32;
		private var _row:uint =0;
		private var _column:uint=0;
		
		public function Grid(row:int,col:int,size:Number) 
		{
			row = row;
			column = col;
			gridSize = size;			
		}
		
		public function get width():Number
		{
			return column * gridSize;
		}
		
		public function set width(value:Number):void
		{
			gridSize = value / column;		
		}
		
		public function get height():Number
		{
			return row * gridSize;
		}
		
		public function set height(value:Number):void
		{
			gridSize = value / row;			
		}			
				
		public function get row():uint {
			return _row;
		}
		
		public function set row(value:uint):void
		{
			_row = value;
		}
		
		public function get column():uint {
			return _column;
		}
		
		public function set column(value:uint):void
		{
			_column = value;
		}
		
		public function get gridSize():Number {
			return _size;
		}
		
		public function set gridSize(value:Number):void
		{
			_size = value;
		}	
		
		public function rendering(context:DisplayObject):void
		{
			draw(context);
		}
		
		protected function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
               var gs:Graphics = (context is Sprite)?Sprite(context).graphics:
				                 (context is Shape)?Shape(context).graphics:null;
				 
				with (gs)
				{
					//clear();
					lineStyle(.1,0xFF0000);
					 
					for (var x = .5; x < width; x += gridSize) {
						moveTo(x, 0);
						lineTo(x,height);						
					}
					for (var y = .5; y < width; y += gridSize) {
						moveTo(0, y);
						lineTo(width,y);						
					}					 
				}
			}
		}
		
		
	}//end of class

}