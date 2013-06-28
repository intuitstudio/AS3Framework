package aeon.animators {

	import aeon.Animation;
	import aeon.easing.Linear;
	import aeon.events.AnimationEvent;

	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	public class FilterAnimator extends Animation {

		private var _tween:Tweener;
		private var _target:DisplayObject;
		private var _startTransform:Object;
		private var _endTransform:Object;
		private var _time:Number;
		private var _easeFunction:Function;
		private var _filter:Object;
		private var _filterIndex:int;
		private var _removeFilter:Boolean;
	
		public function FilterAnimator(
			target:DisplayObject,
			filter:BitmapFilter,
			startTransform:Object,
			endTransform:Object,
			filterIndex:int=-1,
			time:Number=1000,
			easeFunction:Function=null
		) {
			_target = target;
			_filter = filter;
			_filterIndex = filterIndex;
			_removeFilter = _filterIndex < 0;
			_startTransform = startTransform;
			_endTransform = endTransform;
			_time = time;
			if (easeFunction == null) easeFunction = Linear.easeNone;
			_easeFunction = easeFunction;
		}

		private function addFilter():void {
			var filters:Array = _target.filters || [];
			_filterIndex = filters.length;
			filters.push(_filter);
			_target.filters = filters;
		}

		private function removeFilter():void {
			var filters:Array = _target.filters;
			filters.splice(_filterIndex, 1);
			_target.filters = filters;
		}

		private function setFilter():void {
			var filters:Array = _target.filters;
			filters.splice(_filterIndex, 1, _filter);
			_target.filters = filters;
		}

		private function setFilterProperties(transform:Object):void {
			for (var property:String in transform) {
				_filter[property] = transform[property];
			}
		}

		private function onEndTween(event:AnimationEvent):void {
			if (_removeFilter) {
				removeFilter();
			} else {
				setFilterProperties(_endTransform);
				setFilter();
			}
			stop();
			dispatchEvent(new AnimationEvent(AnimationEvent.END));
		}
	
		private function onChangeTween(event:AnimationEvent):void {
			setFilterProperties(_tween.currentValue);
			setFilter();
			dispatchEvent(new AnimationEvent(AnimationEvent.CHANGE));
		}

		override public function stop():void {
			super.stop();
			_tween.removeEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.removeEventListener(AnimationEvent.END, onEndTween);
			_tween.stop();
		}
	
		override public function start():void {
			setFilterProperties(_startTransform);
			if (_removeFilter) {
				addFilter();
			} else {
				setFilter();
			}
			_tween = new Tweener(null, _startTransform, _endTransform, _time, _easeFunction);
			_tween.addEventListener(AnimationEvent.CHANGE, onChangeTween);
			_tween.addEventListener(AnimationEvent.END, onEndTween);
			_tween.start();
			super.start();
		}

	}
	
}