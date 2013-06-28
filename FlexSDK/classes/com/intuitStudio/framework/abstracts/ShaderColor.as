package com.intuitStudio.framework.abstracts
{
	public class ShaderColor
	{
		private var _color:int;
		private var _amount:Number;
		private var _openness:Number;

		public function ShaderColor (col:int,amount:Number=1.0,openness:Number=1.0)
		{
			_color = col;
			_amount = amount;
			_openness = openness;
		}

		public function get clone ():ShaderColor
		{
			return new ShaderColor(_color,_amount,_openness);
		}

		public function toString ():String
		{
			return "[ShaderColor : color= "+ color + ", amount= " + amount + " , openness+ " + openness +" ]";
		}

		public function set color (value:int):void
		{
			_color = value;
		}

		public function get color ():int
		{
			return _color;
		}

		public function set amount (value:Number):void
		{
			_amount = value;
		}

		public function get amount ():Number
		{
			return _amount;
		}

		public function set openness (value:Number):void
		{
			_openness = value;
		}

		public function get openness ():Number
		{
			return _openness;
		}

		public function equalTo (coloring:ShaderColor):Boolean
		{
			return (coloring.color == color && coloring.amount==amount && coloring.openness==openness);
		}

	}

}