package com.intuitStudio.interactions.commands.abstracts
{
	import flash.errors.IllegalOperationError;
	
	public class AbstractKeyCommand
	{
        protected var _receiver:*;
		protected var _type:uint;
		
		public function AbstractKeyCommand (aReceiver:*=null)
		{
			_receiver = aReceiver;
		}		
		
		final public function execute ():void
		{
			if (_receiver == null)
			{
				throw new IllegalOperationError('Receiver must be specified first!');
				return;
			}

			doExecution ();
		}

		final public function set receiver (aReceiver:*):void
		{
			_receiver = aReceiver;
		}
		final public function get receiver ():*
		{
			return _receiver;
		}

		protected function doExecution ():void
		{
			throw new IllegalOperationError('doExecution must be overridden');
		}		
		
		public function set type (value:int):void
		{
			_type = value;
		}

		public function get type ():int
		{
			return _type;
		}	
		
	}
}