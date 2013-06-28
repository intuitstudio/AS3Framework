package com.intuitStudio.interactions.buttons.core
{
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.errors.IllegalOperationError;
	
    import com.intuitStudio.interactions.commands.interfaces.ICommand;	
	import com.intuitStudio.interactions.commands.concretes.HoverCommand;
	import com.intuitStudio.interactions.commands.concretes.OutCommand;

	public class CommandSimpleButton extends SimpleButton
	{
		protected var _upColor:uint = 0xFFCC00;
		protected var _overColor:uint = 0xCCFF00;
		protected var _downColor:uint = 0x00CCFF;
		protected var _wide:Number = 80;
		protected var _tall:Number = 80;
		protected var _location:Point;
		protected var _buttonMode:Boolean = false;
		
		protected var _outCommand:ICommand;
		protected var _hoverCommand:ICommand;
		protected var _commands:Vector.<ICommand>;

		public function CommandSimpleButton (w:Number,h:Number,point:Point=null)
		{
			_wide = w;
			_tall = h;
			_location =(point==null)? new Point():point;
			init ();
		}

		protected function init ():void
		{
			_buttonMode = false;
			_commands = new Vector.<ICommand>();
			makeButtonStates ();
			addListeners();
		}
		
		protected function makeButtonStates ():void
		{
			downState = drawState(_downColor,new Point(wide,tall));
			overState = drawState(_overColor,new Point(wide,tall));
			upState = drawState(_upColor,new Point(wide,tall));
			hitTestState = drawState(_upColor,new Point(wide*2,tall*2));
			hitTestState.x = -(wide>>1);
			hitTestState.y = -(tall>>1);
			useHandCursor = true;
		}

		private function drawState (color:uint,size:Point):Shape
		{
			var shape:Shape = new Shape();
			with (shape.graphics)
			{
				beginFill (color);
				drawRect (0, 0, size.x, size.y);
				endFill ();
			}
			return shape;
		}

		public function set wide (value:Number):void
		{
			_wide = value;
		}

		public function get wide ():Number
		{
			return _wide;
		}

		public function set tall (value:Number):void
		{
			_tall = value;
		}

		public function get tall ():Number
		{
			return _tall;
		}
		
        private function addListeners():void
		{
			addEventListener ( MouseEvent.MOUSE_OVER , onHover );
			addEventListener ( MouseEvent.MOUSE_OUT , onOut );
		}
		
        private function removeListeners():void
		{
			removeEventListener ( MouseEvent.MOUSE_OVER , onHover );
			removeEventListener ( MouseEvent.MOUSE_OUT , onOut );
		}    

		final public function onHover (e:MouseEvent):void
		{			
			_buttonMode = true;
			notify(_hoverCommand);
		}

		final public function onOut (e:MouseEvent):void
		{
			_buttonMode = false;
			notify(_outCommand);
		}
		 
		protected function doHover (e:MouseEvent):void
		{
			_hoverCommand.execute ();
		}

		protected function doOut (e:MouseEvent):void
		{
			trace('Button : do roll out command ');
			_outCommand.execute ();
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
				}
			}
		}
		
		public function getCommand (cmdClass:Class):ICommand
		{
			for each (var cmd:ICommand in _commands)
			{
				if (cmd is cmdClass)
				{
					return cmd;
				}
			}
			return null;
		}		

	}
}