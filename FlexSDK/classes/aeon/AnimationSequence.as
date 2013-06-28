package aeon {

	import aeon.events.AnimationEvent;

	public class AnimationSequence extends Animation {
	
		private var _animation:Animation;
		private var _animations:Array;
		private var _runningAnimations:Array;
	
		public function AnimationSequence(animations:Array) {
			_animations = animations;
		}
	
		private function onEndAnimation(event:AnimationEvent):void {
			_animation.removeEventListener(AnimationEvent.END, onEndAnimation);
			runAnimation();
		}
	
		private function runAnimation():void {
			_animation = _runningAnimations.shift() as Animation;
			if (_animation == null) {
				stop();
				dispatchEvent(new AnimationEvent(AnimationEvent.END));
			} else {
				_animation.addEventListener(AnimationEvent.END, onEndAnimation);
				_animation.start();
			}
		}
	
		override public function stop():void {
			super.stop();
			if (_animation) {
				_animation.removeEventListener(AnimationEvent.END, onEndAnimation);
				if (_animation.running) {
					_animation.stop();
				}
			}
		}
	
		override public function start():void {
			_runningAnimations = _animations.slice();
			runAnimation();
			super.start();
		}
	
		override public function die():void {
			super.die();
			_animations = null;
		}
		
		public function get animations():Array {
			return _animations;
		}

	}
	
}