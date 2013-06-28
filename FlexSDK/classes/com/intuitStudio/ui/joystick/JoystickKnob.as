package com.intuitStudio.ui.joystick
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	public class JoystickKnob extends Sprite
	{
		private var assetName:Class;
		private var instance:MovieClip;
		private var oriX:Number;
		private var oriY:Number;
		
		public function JoystickKnob(classId:Class)
		{
			assetName = classId;
			init();
		}
		
		private function init():void
		{
			draw();
		}
		
		protected function draw():void
		{			
			instance = new assetName() as MovieClip;
			addChild(instance);
		}
		
		public function set originX(value:Number):void
		{
			oriX = value;			
		}
		
		public function get originX():Number
		{
			return oriX;
		}
		
		public function set originY(value:Number):void
		{
			oriY = value;
		}
		
		public function get originY():Number
		{
			return oriY;
		}
	}
	
	
}