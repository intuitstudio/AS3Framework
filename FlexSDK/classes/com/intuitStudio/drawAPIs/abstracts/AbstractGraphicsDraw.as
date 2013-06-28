/*
   Class AbstractGraphicsDraw integrate the new Fash 10 drawingAPIs function,draw with graphicsData ; it is more like the data manage
   of drawing , including strok,fill,shader,pathes,triangles,drawingcommands,vertices...,and so on. The real drawings are implemented
   by sub class , which define different properties and methods in need.
*/
package com.intuitStudio.drawAPIs.abstracts
{
	import flash.display.Graphics;
	import flash.display.IGraphicsData;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsTrianglePath;
	import flash.display.GraphicsStroke;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsBitmapFill;
	import flash.display.GraphicsEndFill;
	import flash.display.TriangleCulling;

	import flash.errors.IllegalOperationError;	
	import com.intuitStudio.utils.VectorUtils;
    import com.intuitStudio.drawAPIs.abstracts.AbstractDrawnPen;

	public class AbstractGraphicsDraw
	{
		protected var _graphicsData:Vector.<IGraphicsData > ;
		protected var _graphicsDataBuffer:Vector.<IGraphicsData > ;
		protected var _commands:Vector.<int > ;
		protected var _data:Vector.<Number > ;
		protected var _index:int = 0;
		protected var _pen:AbstractDrawnPen;

		public function AbstractGraphicsDraw ()
		{
			init ();
		}

		protected function init ():void
		{
			_graphicsData = new Vector.<IGraphicsData>();
			_graphicsDataBuffer = new Vector.<IGraphicsData>();
			_commands = new Vector.<int>();
			_data = new Vector.<Number>();
			_pen = new AbstractDrawnPen();
		}

		//------- interface functions called by outside world

		public function makeStroke (size:Number,color:Number,type:int=0):IGraphicsData
		{
			return doMakeStroke(size,color,type);
		}

		public function makeFill (fillObj:Object):IGraphicsData
		{
			return doMakeFill(fillObj);
		}

		public function endFill ():void
		{
			var fill:IGraphicsData = new GraphicsEndFill();
			addToBuffer (fill);
		}

		public function makePath (commands:Vector.<int>,data:Vector.<Number>):IGraphicsData
		{
			return doMakePath(commands,data);
		}

		public function makeRect (x:Number,y:Number,w:Number,h:Number):IGraphicsData
		{
			var commands:Vector.<int> = new Vector.<int>();
			commands.push (GraphicsPathCommand.MOVE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);
			commands.push (GraphicsPathCommand.LINE_TO);

			var data:Vector.<Number >  = new Vector.<Number >   ;
			data.push (x,y);
			data.push (x+w,y);
			data.push (x+w,y+h);
			data.push (x,y+h);
			data.push (x,y);

			return makePath(commands,data);
		}

		public function addToBuffer (data:IGraphicsData):void
		{
			incrementBuffer ();
			trace('add buffer ' , data);
			_graphicsDataBuffer.push (data);
		}

		public function removeFromBufferByIndex (index:int):void
		{
			if (index < 0 || index > _graphicsDataBuffer.length - 1)
			{
				return;
			}
			var data:IGraphicsData = _graphicsDataBuffer[index];
			_graphicsDataBuffer.splice (index,1);
			data = null;
			//
			decreaseBuffer ();
		}

		public function clearBuffer ():void
		{
			//_graphicsDataBuffer.length = 0;
			_graphicsDataBuffer = new Vector.<IGraphicsData>();
			_index = 0;
		}

		public function navigateNext ():int
		{
			return doNavigateNext();
		}

		public function navigatePrev ():int
		{
			return doNavigatePrev();
		}

        public function addNewCommand(command:int):void
		{
			_commands = new Vector.<int>();
			_commands.push (command);
		}
		
		public function appendCommand(command:int):void
		{
			_commands.push(command);
		}

		public function addNewData (data:Array):void
		{
			_data = new Vector.<Number>();
			_data = Vector.<Number > (VectorUtils.vector2Array(_data).concat(data));
		}

		public function appendData (data:Array):void
		{
			_data = Vector.<Number > (VectorUtils.vector2Array(_data).concat(data));
		}

		public function draw (g:Graphics):void
		{
			doDraw (g);
		}

        public function set pen (obj:AbstractDrawnPen):void
		{
			_pen = obj;
		}

		public function get pen ():AbstractDrawnPen
		{
			return _pen;
		}		

		//--------- abstract functions can be overridden by interited classes

		//override by inherited class
		protected function doMakeStroke (size:Number,color:Number,type:int):IGraphicsData
		{
			throw new IllegalOperationError('doMakeStroke must overridden by inherited classes !');
			return null;
		}

		protected function doMakeFill (fillObj:Object):IGraphicsData
		{
			throw new IllegalOperationError('doMakeFill must overridden by inherited classes !');
			return null;
		}

		protected function doMakePath (commands:Vector.<int>,data:Vector.<Number>):IGraphicsData
		{
			return new GraphicsPath(commands,data);
		}

		//only show GraphicsStroke objects
		protected function doNavigateNext ():int
		{
			var navIndex:int = _index + 2;
			if (navIndex > _graphicsDataBuffer.length)
			{
				navIndex -=  2;
			}else{

				while (navIndex<_graphicsDataBuffer.length)
				{
					navIndex = checkMargins(navIndex);
					trace('navigate Next ',_graphicsDataBuffer[navIndex]);
					if (_graphicsDataBuffer[navIndex] is GraphicsStroke||
					    _graphicsDataBuffer[navIndex] is GraphicsPath)
						
					{
						break;
					}
					else
					{
						navIndex++;
					}
				}
			}
			return navIndex;
		}

		//only show GraphicsStroke objects
		protected function doNavigatePrev ():int
		{			
			var navIndex:int = _index - 2;

			while (navIndex> 0)
			{
				navIndex = checkMargins(navIndex);
                trace('Navigate prev ', _graphicsDataBuffer[navIndex]);
				if (_graphicsDataBuffer[navIndex] is GraphicsStroke||
					_graphicsDataBuffer[navIndex] is GraphicsPath)
				{
					break;
				}
				else
				{
					navIndex--;
				}
			}

			return checkMargins(navIndex);
		}

		protected function doDraw (g:Graphics):void
		{
			_graphicsData.length = 0;

			for (var i:uint=0; i<_index; i++)
			{
				_graphicsData[i] = _graphicsDataBuffer[i];
			}
			//
			if (_graphicsData.length > 0)
			{
				g.drawGraphicsData (_graphicsData);
			}
		}

		//--------- class internal functions

		public function incrementBuffer ():void
		{
			_index++;
			_graphicsDataBuffer.length = _index;
		}

		public function decreaseBuffer ():void
		{
			_index--;
			_graphicsDataBuffer.length = _index;
		}

        public function get bufferLength():int
		{
			return _graphicsDataBuffer.length;
		}
		
		protected function checkMargins (index:int):int
		{
			index = Math.max(0,index);
			index = Math.min(_graphicsDataBuffer.length - 1,index);
			return index;
		}

	}

}