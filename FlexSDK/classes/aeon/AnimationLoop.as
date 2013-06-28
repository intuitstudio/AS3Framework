package aeon {

	import aeon.easing.Linear;
	import aeon.events.AnimationEvent;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AnimationLoop extends Animation {
	
		private var _animation:Animation;
		private var _totalLoops:uint;
		private var _currentLoop:uint;

		public function AnimationLoop(
			animation:Animation,
			numLoops:Number=-1,
			changeFunction:Function=null,
			endFunction:Function=null
		) {
			_animation = animation;
			_animation.addEventListener(AnimationEvent.END, onEndAnimation);
			_totalLoops = numLoops;
			if (changeFunction != null) {
				_animation.addEventListener(AnimationEvent.CHANGE, changeFunction);
			}
			if (endFunction != null) {
				_animation.addEventListener(AnimationEvent.END, endFunction);
			}
		}
	
		private function onEndAnimation(event:AnimationEvent):void {
			if (_totalLoops > 0 && ++_currentLoop >= _totalLoops) {
				stop();
				dispatchEvent(new AnimationEvent(AnimationEvent.END));
			} else {
				_animation.start();
			}
		}

		override public function start():void {
			_currentLoop = 0;
			super.start();
			_animation.start();
		}
	
		override public function stop():void {
			super.stop();
			if (_animation) {
				_animation.removeEventListener(AnimationEvent.END, onEndAnimation);
				_animation.stop();
			}
		}

		public function get animation():Animation {
			return _animation;
		}

	}

}