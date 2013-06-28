package com.intuitStudio.common.patterns.mvc
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.errors.IllegalOperationError;
	import com.intuitStudio.common.patterns.observer.interfaces.ISubject;
	import com.intuitStudio.common.patterns.observer.interfaces.IObserver;

	public class Model extends EventDispatcher implements ISubject
	{
		protected var _target:IEventDispatcher;
		protected var subscribers:Dictionary;
		
		public function Model (target:IEventDispatcher = null)
		{
			super (target);
			_target = target;
			subscribers = new Dictionary(false);
		}

		public function addObserver (observer:IObserver,aspect:Function):Boolean
		{
			subscribers[observer] = aspect;
			return true;
		}

		public function removeObserver (observer:IObserver):Boolean
		{
			subscribers[observer] = null;
			delete subscribers[observer];
			return true;
		}

		protected function notify ():void
		{
			throw new IllegalOperationError('notify must be overridded');
		}
		
		public function get target():*
		{
			return _target;
		}
	}

}