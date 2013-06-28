package aeon {

	import aeon.events.AnimationEvent;

	public class AnimationComposite extends Animation {
	
		private var _animationIndex:uint;
		private var _animations:Array;
	
		public function AnimationComposite(animations:Array) {
			_animations = animations;
		}
	
		private function onEndAnimation(event:AnimationEvent):void {
			if (++_animationIndex >= _animations.length) {
				stop();
				dispatchEvent(new AnimationEvent(AnimationEvent.END));
			}
		}
	
		override public function stop():void {
			super.stop();
			for each (var animation:Animation in _animations) {
				animation.removeEventListener(AnimationEvent.END, onEndAnimation);
				if (animation.running) {
					animation.stop();
				}
			}
		}
	
		override public function start():void {
			_animationIndex = 0;
			for each (var animation:Animation in _animations) {
				animation.addEventListener(AnimationEvent.END, onEndAnimation);
				animation.start();
			}
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