package com.intuitStudio.drawAPIs.core
{
	import flash.display.GraphicsPathCommand;
	import flash.display.IGraphicsData;
	import flash.display.GraphicsPath;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.intuitStudio.utils.VectorUtils;
	
	public class DrawingPen
	{
		public static var MOVETO:int = GraphicsPathCommand.MOVE_TO;
		public static var DRAWTO:int = 100;
		public static var NOOP:int = GraphicsPathCommand.NO_OP;
		public static var WIDEDRAWTO:int = 101;
		public static var WIDEMOVETO:int = GraphicsPathCommand.WIDE_MOVE_TO;
		
		public static var PEN_LINE:String = 'pen';
		public static var PEN_CURVE:String = 'curvePen';
		public static var PEN_SQUARE:String = 'squarePen';
		public static var PEN_ROUND:String = 'roundPen';
		public static var PEN_BRUSH:String = 'brush';
        public static var PEN_STAMP:String = 'stampPen';
        public static var PEN_FILLED:String = 'filledPen';	 
		protected var _commands:Vector.<int>;
		protected var _data:Vector.<Number>;		
		protected var _oriSize:Number;
		protected var _size:Number;
		protected var _color:uint;
		protected var _location:Point;
		
		
		public function DrawingPen(size:Number=1,color:uint=0)
		{
			_oriSize = size;
			_size = size;
			_color = color;
			_commands = new Vector.<int>();
			_data = new Vector.<Number>();
			_location = new Point();
		}
		
		public function reset():void
		{
			_commands.length = 0;
			_data.length = 0;
			_size = _oriSize;
			_color = 0;
		}
		
		public function set size(wide:Number):void
		{
			_size = wide;
		}
		
		public function get size():Number
		{
			return _size;
		}
		
		public function set color(coloring:int):void
		{
			_color = coloring;
		}
		
		public function get color():int
		{
			return _color;
		}
		
		public function addDraw(command:int):void
		{			
			doCommand(command);
		}
		
		protected function doCommand(command:int):void
		{
			if(command==DRAWTO)
			{
				command = GraphicsPathCommand.LINE_TO;
			}
			if(command==WIDEDRAWTO)
			{
				command = GraphicsPathCommand.WIDE_LINE_TO;
			}
			_commands.push(command);
		}
		
		public function addPoint(points:Array,onOff:Boolean=true):void
		{
			_data = Vector.<Number>(VectorUtils.vector2Array(_data).concat(points));
			_location.x = points[0];
			_location.y = points[1];
		}
		
		public function draw(g:Graphics,graphicsData:Vector.<IGraphicsData>=null):void
		{
			doDraw(g,graphicsData);
		}
		
		protected function doDraw(g:Graphics,graphicsData:Vector.<IGraphicsData>):void
		{
			g.clear();
			g.lineStyle(_size,_color);
			g.drawPath(_commands,_data);						
		}
		
		public function get rect():Rectangle
		{
			return new Rectangle(_location.x-size*.5,_location.y-size*.5,size,size);
		}
		
		public function equalTo(pen:DrawingPen):Boolean
		{
			return false;
		}
	}
	
}
