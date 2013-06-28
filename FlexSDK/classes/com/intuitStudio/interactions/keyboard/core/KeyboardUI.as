package com.intuitStudio.interactions.keyboard.core
{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	import com.intuitStudio.interactions.commands.interfaces.ICommand;
	import flash.errors.IllegalOperationError;

	public class KeyboardUI extends EventDispatcher
	{
		protected var _invoker:DisplayObject;
		protected static var _funKeys:Dictionary;
        protected var _commands:Vector.<ICommand>;

		public function KeyboardUI (invoker:DisplayObject)
		{
			_invoker = invoker;
			init ();
		}

		protected function init ():void
		{
			_commands = new Vector.<ICommand>();
		    makeFunKeys();
			addListeners();			
		}
		
		private function makeFunKeys():void
		{
			_funKeys = new Dictionary  ;
			_funKeys[Keyboard.SHIFT] = false;
			_funKeys[Keyboard.CONTROL] = false;
			_funKeys[Keyboard.ALTERNATE] = false;
		}
		
		public function addListeners():void
		{
			_invoker.addEventListener (KeyboardEvent.KEY_DOWN,onKeyPress);
			_invoker.addEventListener (KeyboardEvent.KEY_UP,onKeyRelease);
		}
		
		public function removeListeners():void
		{
			_invoker.removeEventListener (KeyboardEvent.KEY_DOWN,onKeyPress);
			_invoker.removeEventListener (KeyboardEvent.KEY_UP,onKeyRelease);
		}
		
		public function dispose():void
		{
			removeListeners();
		}

		protected function onKeyPress (e:KeyboardEvent):void
		{
			checkFunKeys (e);
			doKeyPress (e);
		}

		protected function onKeyRelease (e:KeyboardEvent):void
		{
			checkFunKeys (e);
			doKeyRelease (e);
		}

		private function checkFunKeys (e:KeyboardEvent):void
		{
			_funKeys[Keyboard.SHIFT] = e.shiftKey;
			_funKeys[Keyboard.CONTROL] = e.ctrlKey;
			_funKeys[Keyboard.ALTERNATE] = e.altKey;
		}

		public static function get Shift ():Boolean
		{
			return _funKeys[Keyboard.SHIFT];
		}
		
		public static function get Ctrl ():Boolean
		{
			return _funKeys[Keyboard.CONTROL];
		}
		
		public static function get Alt ():Boolean
		{
			return _funKeys[Keyboard.ALTERNATE];
		}

		protected function doKeyPress (e:KeyboardEvent):void
		{
			new IllegalOperationError('doCustomKeyPress must overridden by derivated classes.');
           
		    /* format
			switch (e.keyCode)
			{
				case Keyboard.UP :

					break;
				case Keyboard.DOWN :

					break;
				case Keyboard.LEFT :

					break;
				case Keyboard.RIGHT :

					break;
				case Keyboard.ENTER :

					break;
				case Keyboard.SPACE :

					break;
				default :
			}
			
			if(_keyCommand)
			{
			   _keyCommand.excute();
			}
			
			*/
		}

		public function doKeyRelease (e:KeyboardEvent):void
		{
			new IllegalOperationError('doKeyRelease must overridden by derivated classes.');
		}
		
		final public function subscribe (command:*):void
		{
			for (var i:uint = 0; i < _commands.length; i++)
			{
				if (_commands[i] ==(command as ICommand))
				{
					trace ('command has subscribed in Subject already!');
					return;
				}
			}
			_commands.push (command);			
		}
		
		final public function unsubscribe (command:*):void
		{
			for (var i:uint = 0; i < _commands.length; i++)
			{
				if (_commands[i] == (command as ICommand))
				{
					_commands.splice (i,1);					
					break;
				}
			}
		}
		
		final public function notify (command:*):void
		{
			for each(var cmd:ICommand in _commands)
			{
				if(cmd == command)
				{
					cmd.execute();
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
	}
}