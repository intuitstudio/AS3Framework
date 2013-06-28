package com.intuitStudio.common.objects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
    import com.intuitStudio.flash3D.abstracts.TriDimensContainer;
	import aether.textures.natural.StarsTexture;
	import aether.effects.common.CompositeEffect;
	import aether.effects.filters.BlurEffect;
	import aether.effects.filters.ColorMatrixEffect;

	
	public class StarSky extends TriDimensContainer
	{
		protected var _background:BitmapData;
		protected var _area:Rectangle;
		protected var _openness:Number;
		
		public function StarSky(container:DisplayObjectContainer,destRect:Rectangle,vanishingPoint:Point=null,openness:Number=1.0)
		{
			_area = destRect;
			_openness = openness;
			super(container,vanishingPoint);
		}
		
		public function get bitmapData():BitmapData
		{
			return _background;
		}
		
		public function set bitmapData(bitmapData:BitmapData):void
		{
			_background = bitmapData;
		}
		
		override protected function init():void
		{
			_background = new StarsTexture(_area.width,_area.height,0).draw();
			//new CompositeEffect([new BlurEffect(1,1),new ColorMatrixEffect(blueMatrix)]).apply(_background);
			var sky:Bitmap = new Bitmap(_background);
			var trans:ColorTransform = sky.transform.colorTransform;
			trans.redMultiplier  = 1;
			trans.greenMultiplier  = 1;
			trans.alphaMultiplier = _openness;
			sky.transform.colorTransform = trans;
			_container.addChild(sky);
		}		
		
        private function get blueMatrix():Array {
            var matrix:Array = new Array();
            matrix = matrix.concat([0, 0, 0, 0, 0]); // red
            matrix = matrix.concat([0, 0, 0, 0, 0]); // green
            matrix = matrix.concat([0, 0, 1, 0, 0]); // blue
            matrix = matrix.concat([0, 0, 0, .4, 0]); // alpha
            return matrix;
        }		
		
	}
	
}