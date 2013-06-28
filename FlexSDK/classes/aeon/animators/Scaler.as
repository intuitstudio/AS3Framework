package aeon.animators {

	import aeon.Animation;
	import aeon.easing.Linear;
	import aeon.events.AnimationEvent;

	/**
	* Tweens both width and height of an object.
	*/
	public class Scaler extends Animation {
	
		public static const PIXEL:String = "pixel";
		public static const PERCENT:String = "percent";
	
		private var _tween:Tweener;
		private var _scaleType:String;
		private var _target:Object;
		private var _startValue:Object;
		private var _endValue:Object;
		private var _time:Number;
		private var _easeFunction:Function;
	
		/**
		* Constructor.
		*
		* @param  target  The object on which the tween will perform.
		* @param  startValue  The value of the x and y properties at the start of the tween.
		* @param  endValue  The value of the x and y properties at the end of the tween.
		* @param  time  The number of milliseconds the tween should run.
		* @param  scaleType  Whether the scaling should be done by pixel value or by percent.
		* @param  easeFunction  The function to use to calculate values during the tween.
		*/
		public function Scaler(
			target:Object,
			startValue:Object,
			endValue:Object,
			time:Number,
			scaleType:String=PIXEL,
			easeFunction:Function=null
		) {
			_target = target;
			if (startValue is Number) {
				startValue = {x:startValue, y:startValue};
				endValue = {x:endValue, y:endValue};
			}
			_startValue = startValue;
			_endValue = endValue;
			_scaleType = scaleType;
			_time = time;
			if (easeFunction == null) easeFunction = Linear.easeNone;
			_easeFunction = easeFunction;
		}
	
		/**
		* Called once the TweenRunner completes the tween.
		*
		* @param  event  Event fired by TweenRunner.
		*/
		private function onEndTween(event:AnimationEvent):void {
			stop();
			dispatchEvent(new AnimationEvent(AnimationEvent.END));
		}
	
		private function onChangeTween(event:AnimationEvent):void {
			var changedValues:Object = _tween.currentValue;
			if (_scaleType == PIXEL) {
				if (_target.hasOwnProperty("setSize")) {
					_target.setSize(changedValues.x, changedValues.y);
				} else {
					_target.width = changedValues.x;
					_target.height = changedValues.y;
				}
			} else {
				_target.scaleX = changedValues.x;
				_target.scaleY = changedValues.y;
			}
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
		}
	
		/**
		* Starts the animation.
		*/
		override public function start():void {
			_tween = new Tweener(null, _startValue, _endValue, _time, _easeFunction);
			_tween.addEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.addEventListener(AnimationEvent.END, onEndTween);
			_tween.start();
			super.start();
		}
	
		/**
		* Stops the animation.
		*/
		override public function stop():void {
			super.stop();
			_tween.removeEventListener(AnimationEvent.END, onEndTween);
			_tween.stop();
		}
	
	}
	
}