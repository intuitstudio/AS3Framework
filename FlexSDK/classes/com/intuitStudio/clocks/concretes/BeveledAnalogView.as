package com.intuitStudio.clocks.concretes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import com.intuitStudio.clocks.concretes.SimpleAnalogView;
	import com.intuitStudio.clocks.core.ClockData;
	import com.intuitStudio.clocks.core.ClockController;
	import com.intuitStudio.images.concretes.BeveledTextImage;
	import com.intuitStudio.utils.ImageUtils;

	
	public class BeveledAnalogView extends SimpleAnalogView
	{
		protected var _bevel:BeveledTextImage;
		protected var _colors:Array = [0xFFFF9900,0xFFCC7700];
		
		public function BeveledAnalogView(model:ClockData,controller:ClockController,size:Number,color:uint=0,fontSize=36,fontFamily:String='Impact')
		{			
			super(model,controller,size,color,fontSize,fontFamily);
		}
	
		override protected function makeHourImages ():void
		{
			
			var matrix:Matrix;
			var offsetAngle:Number = (Math.PI*2/12);
			var angle:Number = 0;
			var dx:Number = 0;
			var dy:Number = 0;
			var radius:Number = _size * .5 - 20;
            var bevel:BeveledTextImage;
			for (var i:uint=0; i<12; i++)
			{
				var hrStr:String = " " + String(i + 1) +" ";
				bevel = new BeveledTextImage(_colors[0],_colors[1],BeveledTextImage.BEVEL_THINNER);
			    bevel.appdendText ( hrStr ,_fontSize,_color,_fontFamily);
			    bevel.makeEffects ();	
				
				matrix = new Matrix();
				angle = offsetAngle*(i+1)-Math.PI*.5;
				dx = _center.x + Math.cos(angle) * radius - bevel.width * .5;
				dy = _center.y + Math.sin(angle) * radius - bevel.height * .5;
				matrix.translate (dx,dy);
				_bgData.draw (bevel,matrix);
				//_hrsImage.draw(bevel,matrix);
			}
		}

	}
}