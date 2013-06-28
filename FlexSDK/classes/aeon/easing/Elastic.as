package aeon.easing {

	public class Elastic {

		static public function easeIn(t:Number, b:Number, c:Number, d:Number, a:Number=-1, p:Number=-1):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (p<0) p=d*.3;
			if (a<0 || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		}

		static public function easeOut(t:Number, b:Number, c:Number, d:Number, a:Number=-1, p:Number=-1):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (p<0) p=d*.3;
			if (a<0 || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b);
		}

		static public function easeInOut(t:Number, b:Number, c:Number, d:Number, a:Number=-1, p:Number=-1):Number {
			var s:Number;
			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (p<0) p=d*(.3*1.5);
			if (a<0 || a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
			return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
		}

	}

}