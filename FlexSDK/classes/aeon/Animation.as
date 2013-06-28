package aeon {
	
	import aeon.events.AnimationEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class Animation extends EventDispatcher {
	
		private static var sTimerSprite:Sprite = new Sprite();

		private var _running:Boolean;
		
		protected var _receiveEnterFrame:Boolean;

		private function addEnterFrameListener(add:Boolean=true):void {
			if (_receiveEnterFrame) {
				sTimerSprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				if (add) {
					sTimerSprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		private function onEnterFrame(event:Event):void {
			if (_running) {
				updateAnimation();
			}
		}
		
		protected function updateAnimation():void {}

		public function start():void {
			_running = true;
			addEnterFrameListener();
			dispatchEvent(new AnimationEvent(AnimationEvent.START));
		}

		public function stop():void {
			_running = false;
			addEnterFrameListener(false);
		}
		
		public function die():void {
			stop();
		}
	
		public function get running():Boolean {
			return _running;
		}

	}
	
}