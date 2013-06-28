package aeon.animators {

	import aeon.Animation;
	import aeon.easing.Linear;
	import aeon.events.AnimationEvent;
	
	import flash.utils.getTimer;

	public class Tweener extends Animation {

		public static var CURRENT_VALUE:String = "*";
	
		private var _target:Object;
		private var _prop:String;
		private var _startValue:Object;
		private var _endValue:Object;
		private var _changeValue:Object;
		private var _currentValue:Object;
		private var _lastValue:Object;
		private var _time:Number;
		private var _easeFunction:Function;
		private var _startTime:Number;
		
		public function Tweener(
			target:Object,
			startValue:Object,
			endValue:Object,
			time:Number,
			easeFunction:Function=null
		) {
			_receiveEnterFrame = true;
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
			_time = time;
			if (easeFunction == null) easeFunction = Linear.easeNone;
			_easeFunction = easeFunction;
			_changeValue = {};
		}
	
		private function setClipValues():void {
			for (var property:String in _currentValue) {
				if (_target.hasOwnProperty(property)) {
					_target[property] = _currentValue[property];
				}
			}
		}
	
		override protected function updateAnimation():void {
			_lastValue = _currentValue;
			var currentTime:Number = getTimer()-_startTime;
			if (currentTime >= _time || percentComplete >= 1) {
				_currentValue = _endValue;
				if (_target != null) {
					setClipValues();
				}
				stop();
				dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
				dispatchEvent(new AnimationEvent(AnimationEvent.END));
			} else {
				_currentValue = {};
				for (var property:String in _changeValue) {
					if (isNaN(_changeValue[property])) {
						_currentValue[property] = _startValue[property];
					} else {
						_currentValue[property] = _easeFunction(currentTime, _startValue[property], _changeValue[property], _time);
					}
				}
				if (_target != null) {
					setClipValues();
				}
				dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
			}
		}

		override public function start():void {
			_startTime = getTimer();
			_currentValue = _startValue;
			for (var property:String in _startValue) {
				if (_startValue[property] == CURRENT_VALUE) {
					if (_target && _target.hasOwnProperty(property)) {
						_startValue[property] = _target[property];
					}
				}
				if (isNaN(_startValue[property])) {
					_changeValue[property] = _startValue[property];
				} else {
					if (_endValue[property] is String) {
						var sign:String = _endValue[property].charAt(0);
						if (sign == "+") {
							_endValue[property] = _startValue[property] + Number(_endValue[property].substr(1));
						} else if (sign == "-") {
							_endValue[property] = _startValue[property] - Number(_endValue[property].substr(1));
						}
					}
					_changeValue[property] = _endValue[property] - _startValue[property];
				}
			}
			super.start();
		}
	
		override public function die():void {
			super.die();
			_target = null;
			_startValue = null;
			_endValue = null;
			_easeFunction = null;
			_changeValue = null;
			_currentValue = null;
			_lastValue = null;
		}
		
		public function get percentComplete():Number {
			return ((getTimer()-_startTime)/_time);
		}
		
		public function get currentValue():Object {
			return _currentValue;
		}

		public function get lastValue():Object {
			return _lastValue;
		}

	}

}