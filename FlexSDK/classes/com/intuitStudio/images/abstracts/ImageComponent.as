package com.intuitStudio.images.abstracts
{
    /**
     *  ImageComponent Class
     * @author vanier peng ,2013.4.17
     * purpose : 定義影像元素的抽象類別，結合BitmapWrapper的核心資料以及ShaderProxy的操做方法，提供更具彈性的影像處理的應用
     * 
    */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.errors.IllegalOperationError;
	import com.intuitStudio.images.core.BitmapWrapper;
	import com.intuitStudio.shaders.core.ShaderProxy;

	public class ImageComponent
	{
		protected var _image:BitmapWrapper;

		public function ImageComponent (image:BitmapWrapper=null)
		{
			if(image)
			{
				_image = image;
			}			
		}

        public function set valid(value:Boolean):void
		{
			_image.valid = value;
		}
		
		public function get valid ():Boolean
		{
			return _image.valid;
		}
        
		public function set image(wrapper:BitmapWrapper):void
		{
			_image = wrapper;
		}

		public function get image ():BitmapWrapper
		{
			return _image;
		}

		public function get bitmap ():Bitmap
		{
			return _image.bitmap;
		}

		public function get bitmapData ():BitmapData
		{
			return _image.bitmapData;
		}

        public function clone():ImageComponent
		{
			var comp:ImageComponent = new ImageComponent();
			comp.image = image.clone();
			comp.valid = image.valid;			
			return comp;
		}
		
		public function dispose():void
		{
			_image.dispose();
		}

		//Abstract methods which should be overridden by derivative classes
		public function get shader ():ShaderProxy
		{
			throw new IllegalOperationError('getter shader() must be overridden');
		}

		public function onRender (e:Event):void
		{
			throw new IllegalOperationError('onRender must be overridden');
		}

		public function update (elapsed:Number = 1.0):void
		{
			throw new IllegalOperationError('update must be overridden');
		}

		public function render ():void
		{
			throw new IllegalOperationError('render must be overridden');
		}

	}

}