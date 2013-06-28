package aeon.easing {

	public class Sine {

		static public function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
			return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
		}

		static public function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sin(t/d * (Math.PI/2)) + b;
		}

		static public function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		}

	}

}