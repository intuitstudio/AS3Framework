package com.intuitStudio.TBW
{
	import com.intuitStudio.TBW.blitting.MapLevel;
	import com.intuitStudio.TBW.blitting.TileSheet;
	import com.intuitStudio.TBW.blitting.Camera2D;
	import com.intuitStudio.TBW.blitting.LookAheadPoint;
	import com.intuitStudio.TBW.builder.abstracts.*;
	import com.intuitStudio.utils.GameTimer;
	import com.intuitStudio.ui.components.GameInput;


	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.system.System;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.errors.IllegalOperationError;

	public class TileBasedBlitWorld extends Sprite
	{
		public static const TILE_WALL:int = 0;
		public static const TILE_MOVE:int = 1;
		public static const SPRITE_PLAYER:int = 2;

		public var mapTileWidth:Number = 32;
		public var mapTileHeight:Number = 32;
		public var mapRowCount:Number = 50;
		public var mapColCount:Number = 50;

		//fullscreen blit
		protected var backgroundBitmapData:BitmapData;
		public var backgroundBitmap:Bitmap;
		protected var defaultBgData:BitmapData;
		protected var drawingCanvasData:BitmapData;
		public var canvasBitmapData:BitmapData;
		public var canvasBitmap:Bitmap;
		protected var drawingCanvas:Shape;
		protected var frontLayer:Sprite;

		public var blitPoint:Point = new Point();
		public var tileBlitRectangle:Rectangle = new Rectangle(0,0,mapTileWidth,mapTileHeight);
		public var tileSheet:TileSheet = new TileSheet(new TileSheetPng(0,0),mapTileWidth,mapTileHeight);

		protected var world:Array=new Array();
		protected var worldCols:int = 50;
		protected var worldRows:int = 50;
		protected var worldWidth:int = worldCols * mapTileWidth;
		protected var worldHeight:int = worldRows * mapTileHeight;

		protected var camera:Camera2D = new Camera2D();
		protected var cameraBufferWild:Number = 1000;
		protected var cameraBufferTall:Number = 700;

		protected var _stage:Stage;
		protected var _container:DisplayObjectContainer;
		protected var gameinput:GameInput;
		protected var isPlaying:Boolean = false;

		protected var tileRect:Rectangle;
		protected var tilePoint:Point;
		protected var tileSheetData:Array;


		protected var viewDirector:AbstractDisplayDirector;
		protected var viewBuilder:AbstractDisplayBuilder;

		public function TileBasedBlitWorld (container:DisplayObjectContainer=null)
		{

			if (container)
			{
				_container = container;
				init ();
			}
			else
			{
				addEventListener (Event.ADDED_TO_STAGE,init,false,0,true);
			}
		}

		protected function init (e:Event=null):void
		{
			if (e)
			{
				_container = e.currentTarget as DisplayObjectContainer;
				removeEventListener (Event.ADDED_TO_STAGE,init);
			}

			if (_container is Stage)
			{
				_stage = _container as Stage;
			}
			else
			{
				_stage = _container.stage;
			}

			frontLayer = new Sprite();
			setDefaultBg ();
			setupCamera ();			
			setupDisplay ();
			_stage.focus = this;
		}

		//table sheet data
		private function setDefaultBg ():void
		{
			drawingCanvas = new Shape();
			drawingCanvas.graphics.beginBitmapFill (new TableSheet(),null,true,true);
			drawingCanvas.graphics.drawRect (0,0,worldWidth,worldHeight);
			drawingCanvas.graphics.endFill ();
			defaultBgData = new BitmapData(worldWidth,worldHeight);
			defaultBgData.draw (drawingCanvas);
			drawingCanvas = null;
		}


		public function stampToBackground ():void
		{
			drawingCanvasData = new BitmapData(worldWidth,worldHeight,true,0x00000000);
			drawingCanvasData = viewDirector.getView().clone();
			defaultBgData.lock ();
			defaultBgData.copyPixels (drawingCanvasData,drawingCanvasData.rect,new Point(),null,null,true);
			defaultBgData.unlock ();
			drawingCanvasData.dispose ();
		}

		protected function heartbeatFun ():void
		{
			throw new IllegalOperationError('heartbeatFun must be overridden');
		}

		private function setupCamera ():void
		{
			camera.width = cameraBufferWild;
			camera.height = cameraBufferTall;
			camera.cols = 20;
			camera.rows = 20;
			camera.x = 0;
			camera.y = 0;
			camera.bufferBD = new BitmapData(camera.width + mapTileWidth,camera.height + mapTileHeight,true,0x00000000);
			camera.bufferRect = new Rectangle(0,0,camera.width,camera.height);
			camera.bufferPoint = new Point(0,0);
			tileRect = new Rectangle(0,0,mapTileWidth,mapTileHeight);
			tilePoint = new Point(0,0);
		}

		private function setupDisplay ():void
		{
			canvasBitmapData = new BitmapData(camera.width,camera.height,true,0x00000000);
			canvasBitmap = new Bitmap(canvasBitmapData);
			backgroundBitmapData = new BitmapData(camera.width,camera.height,true,0x00000000);
			backgroundBitmap = new Bitmap(backgroundBitmapData);
			addChild (backgroundBitmap);
			addChild (canvasBitmap);
		}

		public function initTileSheetData ():void
		{
			throw new IllegalOperationError('initTileSheetData must be overridden');

		}

		private function startWorld ():void
		{
			gameinput.cameraAngleX = 0;
			gameinput.cameraAngleY = 0;

			System.gc ();
			isPlaying = true;
		}

		public function setupWorld ():void
		{
			throw new IllegalOperationError('setupWorld must be overridded');
		}

		public function drawCamera ():void
		{
			throw new IllegalOperationError('drawCamera must be overridden');
		}

		public function updateWorld ():void
		{
			throw new IllegalOperationError('updateWorld must be overridden');
		}

		public function renderScene ():void
		{
			drawCamera ();
		}

		public function resize ():void
		{

		}
		
		public function get cameraBuffer():Point
		{
			return new Point(this.cameraBufferWild,this.cameraBufferTall);
		}

	}
}