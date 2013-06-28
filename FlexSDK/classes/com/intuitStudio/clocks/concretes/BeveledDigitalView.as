package com.intuitStudio.clocks.concretes
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import com.intuitStudio.clocks.concretes.SimpleDigitalView;
	import com.intuitStudio.clocks.core.ClockData;
	import com.intuitStudio.clocks.core.ClockController;
	import com.intuitStudio.images.concretes.BeveledTextImage;
	import com.intuitStudio.utils.ImageUtils;

	
	public class BeveledDigitalView extends SimpleDigitalView
	{
		protected var _bevel:BeveledTextImage;
		protected var _colors:Array = [0xFFFF9900,0xFFCC7700];
		
		public function BeveledDigitalView(model:ClockData,controller:ClockController,size:Number,color:uint=0,fontSize=36,fontFamily:String='Impact')
		{			
			super(model,controller,size,color,fontSize,fontFamily);
		}
	
		override protected function makeTimeFieldImage ():void
		{
			_bevel = new BeveledTextImage(_colors[0],_colors[1],BeveledTextImage.BEVEL_THINNER);
			_bevel.appdendText (" 00 : 00 : 00 ",_fontSize,_color,_fontFamily);
			_bevel.makeEffects ();		
			
			_scale = _size / _bevel.width;
			_offset.x = (_size-_bevel.width*_scale)*.5;
			_offset.y = (_size-_bevel.height*_scale)*.5*2/3;
			drawTimeFieldImage(_bevel);
			
		}

		override public function onUpdateView (e:Event):void
		{
			_bevel.reset();
			_bevel.appdendText(getTimeString(),_fontSize,_color,_fontFamily);
			_bevel.makeEffects ();		
			drawTimeFieldImage (_bevel);
		}

	}
}