package com.intuitStudio.TBW.blitting
{
	public class MapLevel
	{
		public var backgroundMap:Array;//mappy建立的背景圖層layer0
		public var spriteMap:Array;//mappy建立的背景圖層layer1	
		public var map:Array;
		public var backgroundTile:int;//空白tile的表示編號		
		public var playerStartFacing:int;
		public var vecBackgroundMap:Vector.<Vector>;
		public var vecSpriteMap:Vector.<Vector>;

		public function MapLevel()
		{
			
		}

	}
}