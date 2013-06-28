package aeon.animators {
	
	import aeon.Animation;
	import aeon.easing.Linear;
	import aeon.events.AnimationEvent;

	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ColorTransformer extends Animation {

		private var _tween:Tweener;
		private var _target:DisplayObject;
		private var _startTransform:ColorTransform;
		private var _endTransform:ColorTransform;
		private var _time:Number;
		private var _easeFunction:Function;

		public function ColorTransformer(
			target:DisplayObject,
			startTransform:ColorTransform=null,
			endTransform:ColorTransform=null,
			time:Number=1000,
			easeFunction:Function=null
		) {
			_target = target;
			_time = time;
			if (easeFunction == null) easeFunction = Linear.easeNone;
			_easeFunction = easeFunction;
			_startTransform = startTransform || new ColorTransform(0, 0, 0, 1, 255, 255, 255, 0);
			_endTransform = endTransform || new ColorTransform();
		}
	
		private function makeTransform(transform:ColorTransform):Object {
			var object:Object = {
				ra:transform.redMultiplier,
				rb:transform.redOffset,
				ga:transform.greenMultiplier,
				gb:transform.greenOffset,
				ba:transform.blueMultiplier,
				bb:transform.blueOffset,
				aa:transform.alphaMultiplier,
				ab:transform.alphaOffset
			};
			return object;
		}

		private function onEndTween(event:AnimationEvent):void {
			_target.transform.colorTransform = _endTransform;
			stop();
			dispatchEvent(new AnimationEvent(AnimationEvent.END));
		}
	
		private function onChangeTween(event:AnimationEvent):void {
			var value:Object = _tween.currentValue;
			_target.transform.colorTransform = new ColorTransform(
				value.ra,
				value.ga,
				value.ba,
				value.aa,
				value.rb|0,
				value.gb|0,
				value.bb|0,
				value.ab
			);
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
		}
		
		override public function stop():void {
			super.stop();
			_tween.removeEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.removeEventListener(AnimationEvent.END, onEndTween);
			_tween.stop();
		}
	
		override public function start():void {
			_target.transform.colorTransform = _startTransform;
			_tween = new Tweener(null, makeTransform(_startTransform), makeTransform(_endTransform), _time, _easeFunction);
			_tween.addEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.addEventListener(AnimationEvent.END, onEndTween);
			_tween.start();
			super.start();
		}

	}

}