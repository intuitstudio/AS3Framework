/*
  Class AbstractDrawnPen is define a virtual pen , which has strok , fill,location,size....
  It is used to simulate the behavior of taking pen to draw something , and works with AbsractGraphicDraw in usually.
  Or it can be use to draw separately , with  drawPath command or old-style drawing APIs such as lineTo(),curveTo()....
  
*/

package com.intuitStudio.drawAPIs.abstracts
{
	import flash.display.GraphicsPathCommand;
	import flash.display.IGraphicsData;
	import flash.display.GraphicsPath;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.intuitStudio.utils.VectorUtils;

	public class AbstractDrawnPen
	{
		//drawing commands
		public static var COMMAND_MOVETO:int = GraphicsPathCommand.MOVE_TO;
		public static var COMMAND_DRAWTO:int = 100;
		public static var COMMAND_NOOP:int = GraphicsPathCommand.NO_OP;
		public static var COMMAND_WIDEMOVETO:int = GraphicsPathCommand.WIDE_MOVE_TO;
		public static var COMMAND_WIDEDRAWTO:int = 101;
		//drawn line 
		public static var PEN_LINE:String = 'penDrawLine';
		public static var PEN_CURVE:String = 'penDrawCurve';
		public static var PEN_SQUARE:String = 'penWithSquareHead';
		public static var PEN_ROUND:String = 'penWithRoundHead';
		public static var PEN_BRUSH:String = 'penDrawBruh';
		public static var PEN_STAMP:String = 'penDrawStampPattern';
		public static var PEN_FILLED:String = 'penDrawFill';
		public static var PEN_GRIDIENT_LINE:String = 'penDrawGridientLine';
		public static var PEN_GRIDIENT_FILL:String = 'penDrawGridientFill';

		protected var _commands:Vector.<int > ;
		protected var _data:Vector.<Number > ;
		protected var _size:Number;
		protected var _color:uint;
		protected var _location:Point;
		protected var _lineStyled:Boolean;

		public function AbstractDrawnPen (size:Number=1,color:uint=0)
		{
			_size = size;
			_color = color;
			init ();
		}

		protected function init ():void
		{
			_commands = new Vector.<int >   ;
			_data = new Vector.<Number >   ;
			_location = new Point  ;
			_lineStyled = false;
		}

		public function reset ():void
		{
			_commands = new Vector.<int >   ;
			_data = new Vector.<Number >   ;
			_lineStyled = false;
		}

		public function set size (thickness:Number):void
		{
			_size = thickness;
		}

		public function get size ():Number
		{
			return _size;
		}

		public function set color (coloring:int):void
		{
			_color = coloring;
		}

		public function get color ():int
		{
			return _color;
		}

		public function addCommand (command:int):void
		{
			doAddCommand (command);
		}

		protected function doAddCommand (command:int):void
		{
			if (command == COMMAND_DRAWTO)
			{
				command = GraphicsPathCommand.LINE_TO;
			}
			if (command == COMMAND_WIDEDRAWTO)
			{
				command = GraphicsPathCommand.WIDE_LINE_TO;
			}
			_commands.push (command);
		}

		public function addPoints (points:Array):void
		{
			doAddPoints (points);
		}

		protected function doAddPoints (points:Array):void
		{
			_data = Vector.<Number > (VectorUtils.vector2Array(_data).concat(points));
			_location.x = points[0];
			_location.y = points[1];
		}

		public function get commands ():Vector.<int > 
		{
			return _commands;
		}

		public function get data ():Vector.<Number > 
		{
			return _data;
		}

		public function makeDrawPath ():IGraphicsData
		{
			return new GraphicsPath(_commands,_data);
		}

		public function draw (g:Graphics,command:int=NaN,data:Array=null):void
		{
			doDraw (g,command,data);
		}

		protected function doDraw (g:Graphics,command:int=NaN,data:Array=null):void
		{
			g.clear ();
			g.lineStyle (_size,_color);
			if (isNaN(command))
			{
				g.drawPath (_commands,_data);
			}
			else
			{
                if(command==GraphicsPathCommand.MOVE_TO)
				{
					g.moveTo(data[0],data[1]);
				}
                if(command==GraphicsPathCommand.LINE_TO)
				{
					g.lineTo(data[0],data[1]);
				}				
			}
		}

		public function get rect ():Rectangle
		{
			return new Rectangle(_location.x - size * .5,_location.y - size * .5,size,size);
		}

		public function set location (point:Point):void
		{
			_location = point;
		}

		public function get location ():Point
		{
			return _location;
		}

	}

}