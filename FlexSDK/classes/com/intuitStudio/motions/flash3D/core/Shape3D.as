package com.intuitStudio.motions.flash3D.core
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import flash.geom.Point;

	import com.intuitStudio.motions.flash3D.core.Point3D;
	import com.intuitStudio.motions.flash3D.core.Vehicle3D;
	import com.intuitStudio.framework.abstracts.ShaderColor;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.utils.ImageUtils;
	import flash.geom.Matrix;

	public class Shape3D extends Vehicle3D
	{
		protected var _size:Number;
		protected var _color:ShaderColor;
		protected var _blend:Number;
		protected var _bitmap:Bitmap;
		protected var _bitmapData:BitmapData;
		protected var _drawCanvas:Shape;

		private var _updateColor:int = 0;

		public function Shape3D (size:Number,color:ShaderColor=null,blend:Number=1.0)
		{
			_size = size;
			if (color == null)
			{
				color = new ShaderColor(0xCCCCCC);
			}
			_color = color;
			_blend = blend;

			super ();
		}

		override public function get displayObject ():DisplayObject
		{
			return getDisplayObjectByName('shape1') as DisplayObject;
		}

		override public function getDisplayObjectByName (symbol:Object):DisplayObject
		{
			return getChildByName(symbol) as DisplayObject;
		}

		public function set size (value:Number):void
		{
			_size = value;
			_updateView++;
		}

		public function get size ():Number
		{
			return _size;
		}

		public function setColor (color:ShaderColor):void
		{
			_color = color;
		}

		public function set color (value:int):void
		{
			_color.color = value;
			_updateColor++;
		}

		public function get color ():int
		{
			return _color.color;
		}
		
		override public function render ():void
		{
			if (_updateView > 0)
			{
				super.render ();
			}

			if (_updateColor > 0)
			{
				_updateColor = 0;
				//dyeing (_color);
			}
		}

		override public function draw ():void
		{
			//trace('call draw by Shape3D')
			_drawCanvas ||= new Shape();
			_drawCanvas.z = 0;

			addChild (_drawCanvas,'shape1');
			//addChild(_bitmap);
			doDraw ();			
		}

		public function makeup (source:BitmapData):void
		{
			//trace('make up texture ');
			_bitmapData = ImageUtils.make32BitImage(size,size);
			_bitmapData.fillRect (_bitmapData.rect,0);
			var matrix:Matrix = new Matrix();			
			var scale:Number =  size/source.width;
			
			matrix.scale(scale,scale);
			_bitmapData.draw (source,matrix);
			 
			with (_drawCanvas.graphics)
			{
				clear ();
				matrix = new Matrix();
				matrix.translate(-size*.5,-size*.5);
				beginBitmapFill (_bitmapData,matrix,false);
				drawRect (-size*.5,-size*.5,size,size);
				endFill ();
			}			 
		}

		private function sketch (color:uint = 0xFFFFFF):void
		{
			with (_drawCanvas.graphics)
			{
				clear ();
				beginFill (color,_blend);
				drawRect (-size*.5,-size*.5,size,size);
				endFill ();
			}
			
		}

		override protected function doDraw ():void
		{
			if (_bitmapData)
			{
				makeup (_bitmapData);
			}
			else
			{
				sketch ();
			}
		}

		public function dyeing (color:ShaderColor):void
		{
			//instance.transform.colorTransform = ColorUtils.colorTransform(color.color,color.amount,color.openness);
			sketch(color.color);
		}

	}


}