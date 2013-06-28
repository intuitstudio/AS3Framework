package aeon.events {

	import aeon.Animation;
	
	import flash.events.Event;

	public class AnimationEvent extends Event {
		
		public static const START:String = "tweenEnd";
		public static const END:String = "tweenStart";
		public static const CHANGE:String = "tweenChange";

		public function AnimationEvent(pType:String) {
			super(pType);
		}

		override public function clone():Event {
			return new AnimationEvent(type);
		}

	}
	
}