package com.intuitStudio.common.garden
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.intuitStudio.flash3D.abstracts.TriDimensContainer;
	import com.intuitStudio.images.concretes.EmptyImageWrapper;
	import com.intuitStudio.images.core.BitmapWrapper;
	import com.intuitStudio.utils.ImageUtils;

	public class SolidImage extends TriDimensContainer
	{
		protected var _color:uint=0;
		protected var _area:Rectangle;
		protected var _image:BitmapWrapper;
		
		public function SolidImage(container:DisplayObjectContainer,destRect:Rectangle,color:uint=0,vanishingPoint:Point=null)
		{			
			_area = destRect;
			_color = color;
			super (container,vanishingPoint);
		}
		
		override protected function init():void
		{
			_image = new EmptyImageWrapper(_area.width,_area.height);
			_image.bitmapData = ImageUtils.make24BitImage(_area.width,_area.height);
            _image.bitmapData.fillRect( _image.bitmapData.rect,_color);
			_container.addChild(_image.bitmap);
			x = _area.x;
			y = _area.y;
		}
 
	}
}