package aeon.easing {

	public class Quad {

		static public function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
			return c*(t/=d)*t + b;
		}
		
		static public function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -c *(t/=d)*(t-2) + b;
		}
		
		static public function easeInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return c/2*t*t + b;
			return -c/2 * ((--t)*(t-2) - 1) + b;
		}
		
	}

}