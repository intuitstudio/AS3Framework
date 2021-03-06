﻿package com.intuitStudio.TBW.blitting
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BlitSprite extends Sprite
	{
		private var bitmap:Bitmap;
		public var bitmapData:BitmapData;
		private var tileSheet:TileSheet;
		private var rect:Rectangle;
		private var point:Point;
		public var animationDelay:int = 3;
		public var animationCount:int = 0;
		public var animationLoop:Boolean = false;
		public var tileList:Array;
		public var currentTile:int;
		public var tileWidth:Number;
		public var tileHeight:Number;
		public var nextX:Number = 0;
		public var nextY:Number = 0;
		public var dx:Number = 0;
		public var dy:Number = 0;
		public var doCopyPixels:Boolean = false;
		public var loopCounter:int = 0;
		// counts the number of animation loops if useCounter is set to true;
		public var useLoopCounter:Boolean = false;

		public function BlitSprite (tileSheet:TileSheet, tileList:Array, firstFrame:int)
		{

			this.tileSheet = tileSheet;
			tileWidth = tileSheet.tileWidth;
			tileHeight = tileSheet.tileHeight;
			this.tileList = tileList;

			rect = new Rectangle(0,0,tileWidth,tileHeight);
			point = new Point(0,0);

			bitmapData = new BitmapData(tileWidth,tileHeight,true,0x00000000);
			bitmap = new Bitmap(bitmapData);
			bitmap.x = -.5 * tileWidth;
			bitmap.y = -.5 * tileHeight;
			addChild (bitmap);
			currentTile = firstFrame;
			renderCurrentTile (true );
		}
		public function updateCurrentTile ():void
		{
			if (animationLoop)
			{
				if (animationCount > animationDelay)
				{
					animationCount = 0;
					currentTile++;
					doCopyPixels = true;
					if (currentTile > tileList.length - 1)
					{
						currentTile = 0;
						if (useLoopCounter)
						{
							loopCounter++;
						}
					}
				}
				animationCount++;
			}
		}


		public function renderCurrentTile (forceCopyPixels:Boolean=false):void
		{
			if (forceCopyPixels)
			{
				doCopyPixels = true;
			}
			if (doCopyPixels)
			{
				bitmap.bitmapData.lock ();
				rect.x = int(tileList[currentTile] % tileSheet.tilesPerRow) * tileWidth;
				rect.y = int(tileList[currentTile] / tileSheet.tilesPerRow) * tileHeight;
				bitmap.bitmapData.copyPixels (tileSheet.sourceBitmapData, rect, point);
				bitmap.bitmapData.unlock ();
			}
			doCopyPixels = false;
		}
		
		public function dispose():void {
			bitmap.bitmapData.dispose();
			bitmap = null;
			rect = null;
			rect = null;
			tileList = null;
		}
	}


}