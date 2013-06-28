package aeon.easing {

	public class Linear {

		static public function easeNone(t:Number, b:Number, c:Number, d:Number):Number {
			return c*t/d + b;
		}

	}
	
}