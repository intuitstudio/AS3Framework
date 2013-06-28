package com.intuitStudio.clocks.concretes
{
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.filters.ShaderFilter;
	import flash.filters.BlurFilter;
	import flash.events.Event;


	import com.intuitStudio.clocks.core.*;
	import com.intuitStudio.clocks.concretes.MarbleBeveledAnalogView;
	import com.intuitStudio.shaders.core.ShaderProxy;
	import com.intuitStudio.interactions.keyboard.core.KeyboardUI;
	import com.intuitStudio.utils.ImageUtils;

	import com.intuitStudio.projects.animation.clocks.objects.interactions.FunhouseMirrorShader;
	import com.intuitStudio.projects.animation.clocks.objects.interactions.DistortCommand;
	import com.intuitStudio.projects.animation.clocks.objects.interactions.WarpCommand;
	import com.intuitStudio.projects.animation.clocks.objects.interactions.WarpBeginCommand;
	import com.intuitStudio.projects.animation.clocks.objects.interactions.WarpEndCommand;
	import com.intuitStudio.projects.animation.clocks.objects.interactions.MirrorKeyboard;


	public class FunhouseMirrorMarbleAnalogView extends MarbleBeveledAnalogView
	{
		protected var _shader:ShaderProxy;
		protected var _keyboard:KeyboardUI;
		protected var _distortBg:BitmapData;
		protected var _distortImage:Bitmap;

		public function FunhouseMirrorMarbleAnalogView (model:ClockData,controller:ClockController,size:Number,color:uint=0,fontSize=36,fontFamily:String='Impact')
		{
			super (model,controller,size,color,fontSize,fontFamily);
		}
		
		override protected function drawClock():void
		{
			_distortImage = new Bitmap();
			 
			addChild (_distortImage);
			 
		}

		override protected function doCreateClockFace ():void
		{
			super.doCreateClockFace();
			makeShader ();
		}

		protected function makeShader ():void
		{
			_shader = new FunhouseMirrorShader();
			_shader.addEventListener (Event.RENDER,onRender);
		}

		public function makeKeyboard (invoker:DisplayObject):void
		{
			_keyboard = new MirrorKeyboard(invoker);
			_keyboard.subscribe (new DistortCommand(_shader));
			_keyboard.subscribe (new WarpCommand(_shader));
			_keyboard.subscribe (new WarpBeginCommand(_shader));
			_keyboard.subscribe (new WarpEndCommand(_shader));
			_keyboard.addEventListener (Event.CHANGE,onChange);
		}

		private function onChange (e:Event):void
		{
			//trace ('distortionX,distortionY',_shader.distortionX,_shader.distortionY);
			//trace ('warpRotioX,warpRatioY',_shader.warpRatioX,_shader.warpRatioY);
			//trace ('warpBeginX,warpBeginY',_shader.warpBeginX,_shader.warpBeginY);
			//trace ('warpEndX,warpEndY',_shader.warpEndX,_shader.warpEndY);
			
			_distortBg = _faceImageData.clone();
			
			//ImageUtils.applyFilter (_distortBg,_distortBg,new BlurFilter(2,2));
			drawDistortion ();
		}

		private function drawDistortion ():void
		{
			if (_distortImage.bitmapData)
			{
				_distortImage.bitmapData.dispose ();
			}
            var clone:BitmapData = _distortBg.clone();
			clone.draw(_timeImageData);
			applyEffect (clone);
			_distortImage.bitmapData = clone;
			//
			
		}

		public function onRender (e:Event):void
		{
			_shader.removeEventListener (Event.RENDER,onRender);
			setupShader ();
			onChange (e);
			//
			
 
		}

		private function setupShader ():void
		{
			_shader.warpBeginX = 0;
			_shader.warpBeginY = 87;
			_shader.warpEndX = _size;
			_shader.warpEndY = _size;

			_shader.distortionX = .75;
			_shader.distortionY = .3;
			_shader.warpRatioX = .18;
			_shader.warpRatioY = .14;
		}

		protected function applyEffect (source:BitmapData):void
		{
			ImageUtils.applyFilter (source,source,new ShaderFilter(_shader.shader));
		}

		override public function onUpdateView (e:Event):void
		{
			super.onUpdateView (e);
			if (_shader.valid)
			{
				drawDistortion ();
			}
		}

	}
}