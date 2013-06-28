package com.intuitStudio.drawAPIs.concretes
{
    import flash.display.Graphics;
	import flash.display.IGraphicsData;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsPath;
	import flash.geom.Point;

	import com.intuitStudio.drawAPIs.abstracts.AbstractGraphicsDraw;
	import com.intuitStudio.drawAPIs.core.Stroker;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.VectorUtils;

	public class Painter extends AbstractGraphicsDraw
	{
		protected var _color:uint;
		protected var _thickness:Number=1;
		
		public function Painter(size:Number=1,color:uint=0)
		{
			_thickness = size;
			_color = color;
			super();
		}
		
		override protected function doMakeStroke (size:Number,color:Number,type:int):IGraphicsData
		{
			var stroker:Stroker = new Stroker(size,color,type);
			return stroker.stroke as IGraphicsData;
		}
		
		public function makeNewStroke():void
		{
			//var stroke:IGraphicsData = makeStroke(Math.random() * 10,ColorUtils.random(),Stroker.STROKE_LINE) as IGraphicsData;
			var stroke:IGraphicsData = makeStroke(_thickness,_color,Stroker.STROKE_LINE) as IGraphicsData;
			//addToBuffer (stroke);
		}
		
		public function makeNewDraw(command:int,points:Array):void
		{
			trace('pen color ,command ' ,  _color , command);
            pen.reset();
			//addToBuffer(makeStroke(Math.random() * 10,ColorUtils.random(),Stroker.STROKE_LINE));
			
			
			addToBuffer(makeStroke(_thickness,_color,Stroker.STROKE_LINE));
		    
			makeNextDraw(command,points);
		}

		public function makeNextDraw(command:int,points:Array):void
		{
		    pen.addCommand(command);
			pen.addPoints(points);
		}

		public function stopDraw():void
		{
			addToBuffer (pen.makeDrawPath());
			incrementBuffer ();
		}
		
		override protected function doNavigateNext ():int
		{
			_index = super.doNavigateNext();
			return _index;
		}		
		
		override protected function doNavigatePrev ():int
		{
			_index = super.doNavigatePrev();
			return _index;
		}		
		
		override protected function doDraw (g:Graphics):void
		{			
			_graphicsData.length = 0;

			for (var i:uint=0; i<_index; i++)
			{
				_graphicsData[i] = _graphicsDataBuffer[i];
			}
			
			//
			if (_graphicsData.length > 0)
			{
				g.clear();
				g.drawGraphicsData (_graphicsData);
			}
		}		
		
		public function set color(value:uint):void
		{
			trace('set color ', value);
			_color = value;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set penSize(value:Number):void
		{
			_thickness = value;
		}
	    
		public function get penSize():Number
		{
			return _thickness;
		}
	
		public function skipStep():void
		{
			_index = Math.max(0,_index-3);
		}	
	
	}

}