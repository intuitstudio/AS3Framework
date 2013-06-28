package aeon.easing {

	public class Circ {

		static public function easeIn(t:Number, b:Number, c:Number, d:Number):Number {
			return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
		}

		static public function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
		}

		static public function easeInOut(t:Number, b:Number, c:Number, d:Number):Number {
			if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
		}
	}

}