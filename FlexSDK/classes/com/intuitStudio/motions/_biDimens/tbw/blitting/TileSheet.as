package com.intuitStudio.TBW.blitting
{
	import flash.display.BitmapData;
	import flash.geom.*;

	public class TileSheet
	{
		public var sourceBitmapData:BitmapData;
		public var width:int;
		public var height:int;
		public var tileWidth:int;
		public var tileHeight:int;
		public var tilesPerRow:int;//用來計算tile的行例值

		public function TileSheet (sourceBitmapData:BitmapData,tileWidth:int,tileHeight:int )
		{
			this.sourceBitmapData = sourceBitmapData;
			width = sourceBitmapData.width;
			height = sourceBitmapData.height;
			this.tileHeight = tileHeight;
			this.tileWidth = tileWidth;
			tilesPerRow = int(width / this.tileWidth);
		}

	}

}