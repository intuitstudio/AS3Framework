package aeon.animators {

	import aeon.Animation;
	import aeon.events.AnimationEvent;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix3D;
	
	public class Transformer3D extends Animation {
	
		private var _tween:Tweener;
		private var _target:DisplayObject;
		private var _startValue:Matrix3D;
		private var _endValue:Matrix3D;
		private var _time:Number;
		private var _easeFunction:Function;
	
		public function Transformer3D(
			target:DisplayObject,
			startValue:Matrix3D,
			endValue:Matrix3D,
			time:Number,
			easeFunction:Function=null
		) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
			_time = time;
			_easeFunction = easeFunction;
		}
	
		private function onEndTween(event:AnimationEvent):void {
			_target.transform.matrix3D = _endValue;
			stop();
			dispatchEvent(new AnimationEvent(AnimationEvent.END));
		}
	
		private function onChangeTween(event:AnimationEvent):void {
			var percent:Number = _tween.currentValue.percent as Number;
			var matrix:Matrix3D = Matrix3D.interpolate(_startValue, _endValue, percent);
			_target.transform.matrix3D = matrix;
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
		}
		
		override public function stop():void {
			super.stop();
			_tween.removeEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.removeEventListener(AnimationEvent.END, onEndTween);
			_tween.stop();
		}
	
		override public function start():void {
			_target.transform.matrix3D = _startValue;
			_tween = new Tweener(null, {percent:0}, {percent:1}, _time, _easeFunction);
			_tween.addEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.addEventListener(AnimationEvent.END, onEndTween);
			_tween.start();
			super.start();
		}
	
	}
	
}