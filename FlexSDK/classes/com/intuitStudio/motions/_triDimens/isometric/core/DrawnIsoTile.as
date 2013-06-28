package com.intuitStudio.motions.triDimens.isometric.core
{		
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;

	public class DrawnIsoTile extends IsoObject
	{
		protected var _color:uint;
		protected var _tall:Number;
		
		public function DrawnIsoTile(size:Number,col:uint,h:Number=0)
		{
			color = col;
			tall = h;
			super(size);
		}
		
		override public function draw():void
		{
			var commands:Vector.<int> = new Vector.<int>();
			commands.push (GraphicsPathCommand.MOVE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);

			var data:Vector.<Number> = new Vector.<Number>();
			data.push (-size,0);
			data.push (0,-size*.5);
			data.push (size,0);
			data.push (0,size*.5);
			data.push (-size,0);
			
			var g:Graphics = this.graphics;			
			g.clear();
			g.beginFill(color);
			g.lineStyle(0,0,.1);
			g.drawPath (commands,data);
			g.endFill();
		}
		
		public function set tall(value:Number):void
		{
			_tall = value;
			drawCount++;
			//draw();
		}
		
		public function get tall():Number
		{
			return _tall;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
			drawCount++;
			//draw();
		}
		
		public function get color():uint
		{
			return _color;
		}
	}
}