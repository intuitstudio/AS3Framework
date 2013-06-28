package com.intuitStudio.motions.triDimens.isometric.concretes
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	import com.intuitStudio.motions.triDimens.isometric.core.IsoObject;
	
	
	public class GraphicTile extends IsoObject	
	{		
		private var _graphic:DisplayObject;
		private var _offsets:Point;
		
		public function GraphicTile(size:Number,instance:DisplayObject,offsetX:Number,offsetY:Number)
		{
			_graphic = instance;
			_offsets = new Point(offsetX,offsetY);
			super(size);
		}
		
		override public function draw():void
		{
			var scale:Number = Math.max(size/_graphic.width,size/_graphic.height);	
			//var scale:Number = size/_graphic.height;	
			_graphic.transform.matrix = new Matrix(scale,0,0,scale,-_offsets.x,-_offsets.y);
			addChild(_graphic);
		}
	}
	
}