package aeon {

	import aeon.events.AnimationEvent;

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class AnimationHold extends Animation {
	
		private var _timer:Timer;
		
		public function AnimationHold(time:Number) {
			_timer = new Timer(time, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onEndAnimation, false, 0, true);
		}
	
		private function onEndAnimation(pEvent:TimerEvent):void {
			stop();
			dispatchEvent(new AnimationEvent(AnimationEvent.END));
		}
	
		override public function stop():void {
			super.stop();
			if (_timer && _timer.running) {
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onEndAnimation);
				_timer.stop();
			}
		}
	
		override public function start():void {
			_timer.start();
			super.start();
		}
	
	}
	
}