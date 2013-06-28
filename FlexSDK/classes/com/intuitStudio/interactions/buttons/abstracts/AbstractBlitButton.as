package com.intuitStudio.interactions.buttons.abstracts
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.filters.DropShadowFilter;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.intuitStudio.interactions.buttons.core.CommandButton;
	import com.intuitStudio.interactions.commands.interfaces.ICommand;
	import com.intuitStudio.interactions.buttons.interfaces.IButton;
	import com.intuitStudio.interactions.buttons.interfaces.IClickable;
	
	public class AbstractBlitButton extends CommandButton implements IButton,IClickable
	{
		protected var _width:Number;
		protected var _height:Number;
		protected var _location:Point;
		
		public function AbstractBlitButton(bound:Rectangle):void
		{
			super();
			_width = bound.width;
			_height = bound.height;
			_location = new Point(bound.x,bound.y);
			init();
		}
		
		protected function init():void
		{
			
		}
										   
	}
	
}