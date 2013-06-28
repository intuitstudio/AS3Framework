package com.intuitStudio.flip.abstracts 
{

	/**
	 * FlipPageComponent Class
	 * @author vanier peng
	 * 頁面內容容器 , 在記憶體中儲存及播放
	 * 
	 */
	
	import com.intuitStudio.patterns.Observer.interfaces.IObserver;
	import com.intuitStudio.biMotion.core.BaseParticle;
	import com.intuitStudio.biMotion.core.Vector2d;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;	
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	
	public class FlipPageComponent extends BaseParticle implements IObserver
	{		
		
		private var _bufferData:BitmapData;
		private var _canvasData:BitmapData;
		private var _canvas:Bitmap;
		private var _drawingShape:Shape;
		private var _locus:Vector.<Point>;
		private var _tracker:BaseParticle;
		
		public function FlipPageComponent(w:Number=0,h:Number=0) 
		{
		   super();
		   width = w;
		   height = h;
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
		}
		
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
		
		public function get locus():Vector.<Point>
		{
			return _locus;
		}
		
		public function get tracker():BaseParticle
		{
			return _tracker;
		}
		
		public function set locus(points:Vector.<Point>):void
		{
			_locus = points;
		}
		
		public function change(...arg):void
		{
			throw new IllegalOperationError('change method muse be overridded!');
		}
		
	}

}