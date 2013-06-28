/*
    Class ShaderDrawer is used to wrap Shader instance and handle it's behaviours,
	other classes or objects can take adventange with this drawer more flexibly , example animation effect
*/
package com.intuitStudio.drawAPIs.concretes
{
	import flash.display.Shader;
	import com.intuitStudio.drawAPIs.abstracts.AbstractGraphicsDraw;
	import com.intuitStudio.drawAPIs.abstracts.AbstractShaderWrapper;

	public class ShaderDrawer extends AbstractGraphicsDraw
	{
		public static const SHADER_FILTER:int = 0;
		public static const SHADER_BLEND:int = 1;
		public static const SHADER_FILL:int = 2;
		
		protected var _shader:AbstractShaderWrapper;
		protected var _type:int;
		protected var _updateView:int = 0;
		protected var _delay:Number = .6;//between 0.1~1.0 with sin or cos

		public function ShaderDrawer (wrapper:AbstractShaderWrapper,type:int=0)
		{
			_shader = wrapper;
			_type = type;			
			super ();			
		}
        
		public function set wrapper(obj:AbstractShaderWrapper):void
		{
			_shader = obj;
		}
		
		public function get wrapper():AbstractShaderWrapper
		{
			return _shader;
		}

		public function get shader ():Shader
		{
			return _shader.shader;
		}

        public function get type():int
		{
			return _type;
		}

		public function get updateView ():int
		{
			return _updateView;
		}

		public function set delay (value:Number):void
		{
			value = Math.max(0.1,value);
			_delay = Math.min(1,value);
		}

		public function get delay ():Number
		{
			return _delay;
		}

		//-------------- Abstract methods which muse be override by derivative classes

		public function reset ():void
		{

		}

		protected function checkBound (value:Number):Number
		{
			return 0;
		}

		public function update (elapsed:Number=1.0):void
		{

		}

		public function render ():void
		{

		}

	}

}