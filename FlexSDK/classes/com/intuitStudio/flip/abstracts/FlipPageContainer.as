package com.intuitStudio.flip.abstracts 
{
	/**
	 * FlipPageContainer Class
	 * @author vanier peng,2012,4,23
	 * 頁面內容的容器的抽象類別 , 用來包裝整個翻頁的內容和動態表現，
	 * 頁面容器擁有登錄者的界面，可以註冊或移除元件，元件則擁有觀察者的界面，能夠主動接收登錄者的通知
	 */

	import com.intuitStudio.biMotion.core.BaseParticle;
	import com.intuitStudio.biMotion.core.Vector2d;	
	import com.intuitStudio.kinematics.core.IK;
	import com.intuitStudio.patterns.Observer.interfaces.*;
	import com.intuitStudio.flip.core.*;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.MathTools;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;	

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.errors.IllegalOperationError;	 
	import flash.events.Event;
	
	public class  FlipPageContainer extends BaseParticle implements ISubject
	{
		private var _bufferData:BitmapData;
		private var _canvasData:BitmapData;
		private var _canvas:Bitmap;
		private var _drawingShape:Shape;
		private var _locus:Vector.<Point>;
		private var _tracker:BaseParticle;
		
		private const maxShadowWidth:int = 100;		
		private var _smoothing:Boolean = true;		
		private var _sliceNum:uint = 7;
		private var _components:Vector.<FlipPageComponent>;
		private var _ik:IK;
		private var _shadowR:PageShadow;
		private var _shadowL:PageShadow;
		private var _color:uint = 0xFFFFFF;
		
		public function FlipPageContainer(w:Number,h:Number,sliceNum:uint=7) 
		{
			super();
			width = w;
			height = h;
			slices = sliceNum;
			init();
		}
		
		protected function init():void
		{
		   _bufferData = new BitmapData(width, height);	
		   _canvasData = _bufferData.clone();
		   _canvas = new Bitmap(_canvasData);
		   _drawingShape = new Shape();
		   _locus = new Vector.<Point>();
		   _tracker = new BaseParticle();
			
			_components = new Vector.<FlipPageComponent>();
			_ik = new IK(width);	
		}	
		//------  getter/setter() ......
		
		//暫存影像資料
		public function get bufferData():BitmapData
		{
			return _bufferData;
		}
		
		public function set bufferData(source:BitmapData):void
		{
			_bufferData = source.clone();
		}
		
		public function get bitmapData():BitmapData
		{
			return _canvasData;
		}
		
		public function set bitmapData(source:BitmapData):void
		{
			_canvasData = source.clone();
		}
		
		public function get bitmap():Bitmap
		{
			return _canvas;
		}
		
		public function set bitmap(source:Bitmap):void
		{
			_canvas = new Bitmap(source.bitmapData.clone());
		}
		
		public function get drawingBuffer():Shape
		{
			return _drawingShape;
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}
		
		public function get slices():uint
		{
			return _sliceNum;
		}
		
		public function set slices(value:uint):void
		{
			_sliceNum = value;
		}
		
		public function get components():Vector.<FlipPageComponent>
		{
			return _components;
		}
		
		//------------------------------
		
		//Observer pattern to regist and unregist components ,and notiy them when something happen
		
		public function subscribe (target:IObserver):void
		{
			for (var ob:int = 0; ob < components.length; ob++)
			{
				if (components[ob] == target)
				{
					trace ('target has subscribed in Subject allready!');					
					return;
				}
			}
			components.push (target as FlipPageComponent);
		}
		
		public function unsubscribe (target:IObserver):void
		{
			for (var ob:int = 0; ob < components.length; ob++)
			{
				if (components[ob] == target)
				{
					trace('remove observer ' + ob);
					components.splice (ob,1);
					break;
				}
			}
		}
		
		/**
		 * 通知所有被觀察對象 
		 * @param	...rest
		 */
		public function notify(...rest):void{
			for(var symbol:String in components)
			{				
				var argment:Array = rest||[];
				components[symbol].change.apply(argment);
			}			
		}
		
		public function setColor(tint:uint,amount:Number=1.0):void
		{
			amount = Math.min(1.0, amount);
			var cTrans:ColorTransform = ColorUtils.colorTransform(tint,amount);
		//	cTrans.redMultiplier = cTrans.greenMultiplier = amount;
			_color = cTrans.color;
			if (_shadowL)
			{
				_shadowL.setColor(tint);
			}
			if (_shadowR)
			{
				_shadowR.setColor(tint);
			}		
		}
		
		public function setSize(w:Number,h:Number):void
		{
		   width = (w << 1);
		   height = h;
		   var sWide:Number = Math.min(maxShadowWidth,width * 2 / 3);

		   if (_shadowL) {
   			   _shadowL.setSize(sWide, height);
		   }
		   if (_shadowR) {
			   _shadowR.setSize(sWide, height);
		   }
		}
		
		override public function rendering(context:DisplayObject=null):void
		{
           drawShadows();
		   draw(context);
		}
				
		override protected function draw(context:DisplayObject):void
		{
            //draw background;
			if (_canvasData == null) {
				_canvasData = new BitmapData(width, height, true, 0);
			}
			var g:Graphics  = MovieClip(context).graphics;
			with (g)
			{
				beginFill(_color);
				drawRect(0,0,width, height);
				endFill();
			}
			
			_canvasData.draw(context);	
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
		
	}

}