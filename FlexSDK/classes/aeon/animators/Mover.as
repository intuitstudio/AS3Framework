package aeon.animators {

	import aeon.Animation;
	import aeon.easing.Linear;
	import aeon.events.AnimationEvent;
	
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	public class Mover extends Animation {
	
		private var _tween:Tweener;
		private var _target:DisplayObject;
		private var _useBlur:Boolean;
		private var _blurAmount:Number;
		private var _blurQuality:int;
		private var _blurFilter:BlurFilter;
		private var _startValue:Object;
		private var _endValue:Object;
		private var _time:Number;
		private var _easeFunction:Function;
		private var _lastPosition:Point;
	
		public function Mover(
			target:DisplayObject,
			startValue:Point,
			endValue:Point,
			time:Number,
			easeFunction:Function=null,
			useBlur:Boolean=false,
			blurAmount:Number=1,
			blurQuality:int=1
		) {
			_target = target;
			_startValue = {x:startValue.x, y:startValue.y};
			_endValue = {x:endValue.x, y:endValue.y};
			_time = time;
			if (easeFunction == null) easeFunction = Linear.easeNone;
			_easeFunction = easeFunction;
			_useBlur = useBlur;
			_blurAmount = blurAmount;
			_blurQuality = blurQuality;
		}
	
		private function onEndTween(event:AnimationEvent):void {
			stop();
			dispatchEvent(new AnimationEvent(AnimationEvent.END));
		}
	
		private function onChangeTween(event:AnimationEvent):void {
			var changedValues:Object = _tween.currentValue;
			_target.x = changedValues.x;
			_target.y = changedValues.y;
			if (_useBlur) {
				var factor:Number = _blurAmount/10;
				_blurFilter.blurX = Math.abs((changedValues.x - _lastPosition.x)*factor);
				_blurFilter.blurY = Math.abs((changedValues.y - _lastPosition.y)*factor);
				var filters:Array = _target.filters.slice(0, -1);
				_target.filters = filters.concat(_blurFilter);
				_lastPosition = new Point(changedValues.x, changedValues.y);
			}
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
		}
		
		override public function stop():void {
			super.stop();
			if (_useBlur) {
				_target.filters = _target.filters.slice(0, -1);
			}
			_tween.removeEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.removeEventListener(AnimationEvent.END, onEndTween);
			_tween.stop();
		}
	
		override public function start():void {
			_tween = new Tweener(null, _startValue, _endValue, _time, _easeFunction);
			_tween.addEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.addEventListener(AnimationEvent.END, onEndTween);
			if (_useBlur) {
				_lastPosition = new Point(_target.x, _target.y);
				var filters:Array = _target.filters || [];
				_blurFilter = new BlurFilter(0, 0, _blurQuality);
				filters.push(_blurFilter);
				_target.filters = filters;
			}
			_tween.start();
			super.start();
		}
	
	}
	
}