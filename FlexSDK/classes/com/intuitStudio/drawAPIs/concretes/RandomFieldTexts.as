package com.intuitStudio.drawAPIs.concretes
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import flash.geom.Matrix;
	import flash.geom.Vector3D;
   
    import com.intuitStudio.framework.abstracts.VirtualDisplayObject;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.utils.TextFieldUtils;

	public class RandomFieldTexts extends VirtualDisplayObject
	{
		protected var _format:TextFormat;		
		protected var _tfs:Vector.<TextField > ;
		protected var _numChars:int=0;
		protected var _pad:Sprite;

		public function RandomFieldTexts (w:Number,h:Number,numChars:int,format:TextFormat=null)
		{
			super(w,h);
			_numChars = numChars;
			_format = (format==null)?defaultFormat:format;
			init();
		}
		
		override protected function init():void
		{
            super.init();
			_tfs = new Vector.<TextField > (_numChars)  ;
			_pad = new Sprite();
			makeTextFiled (_numChars);
			updateSize();
		}
				
		public function set format(fontFormat:TextFormat):void
		{
			_format = fontFormat;
			updateSize();
		}
		
		public function get format():TextFormat
		{
			return _format;
		}
		
		protected function get defaultFormat():TextFormat
		{
			return new TextFormat('_sans',72,0);
		}
				
		override public function update (elapsed:Number=1.0):void
		{
			//this.rotationY +=30*elapsed;

		}

		override public function render ():void
		{
			if(_updateSize>0)
			{
				makeTextFiled(_numChars);
				updateSize(0);
			}
			
            if(_updateView>0)
			{				
                _instance.x = x;
				_instance.y = y;
				_instance.z = z;
				draw();				
				updateSize(0);
			}
		}

		private function makeTextFiled (sum:int):void
		{
			_tfs.length = 0;
            _pad = new Sprite();
			for (var i:uint = 0; i < sum; i++)
			{
				var tf:TextField = new TextField  ;
				var format:TextFormat = _format;
                format.color = ColorUtils.random();
                tf.defaultTextFormat = format;
				tf.text = TextFieldUtils.randomAsciiChar();
				tf.selectable = false;
				tf.wordWrap = true;
				tf.multiline = true;
				tf.x = Math.random() * width*.5;
				tf.y = Math.random() * height*.5;
				tf.z = Math.random() * 1000;
				_pad.addChild (tf);
				_tfs.push (tf);
			}
			sortTextField ();
		}

		private function sortTextField ():void
		{
			_tfs = Vector.<TextField > (VectorUtils.vector2Array(_tfs).sortOn('z',Array.NUMERIC | Array.DESCENDING));
			for (var i:int = 0; i < _tfs.length; i++)
			{
				_instance.addChild (_tfs[i]);
			}
		}
		
		override protected function copyDrawnToCanvas ():void
		{
            cleanCanvas();
		    _canvas.bitmapData.draw (_pad);
		}

	}
}