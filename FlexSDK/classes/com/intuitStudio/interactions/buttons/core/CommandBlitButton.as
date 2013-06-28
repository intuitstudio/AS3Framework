package com.intuitStudio.interactions.buttons.core
{
    import com.intuitStudio.ui.commands.interfaces.ICommand;	
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.ID3Info;
	import flash.errors.IllegalOperationError;	

	public class CommandBlitButton extends Sprite
	{
		protected var _outCommand:ICommand;
		protected var _hoverCommand:ICommand;

		public function CommandBlitButton ()
		{
			addEventListener ( MouseEvent.MOUSE_OVER , onHover );
			addEventListener ( MouseEvent.MOUSE_OUT , onOut );
		}

        final public function setCommands(target:*):void
		{
			doSetCommands(target);
		}

		final public function onHover (e:MouseEvent):void
		{			
			buttonMode = true;
			doHover (e);
		}

		final public function onOut (e:MouseEvent):void
		{
			buttonMode = false;
			doOut (e);
		}

		final public function get hoverCommand ():ICommand
		{
			return _hoverCommand;
		}
		final public function set hoverCommand ( command : ICommand ):void
		{
			_hoverCommand = command;
		}
		final public function get exitCommand ():ICommand
		{
			return _outCommand;
		}
		final public function set exitCommand (command : ICommand):void
		{
			_outCommand = command;
		}
         
		protected function doSetCommands(target:IPauseable):void
		{
			throw new IllegalOperationError('doSetCommands must be overridden');
		}
		 
		protected function doHover (e:MouseEvent):void
		{
			_hoverCommand.execute ();
		}

		protected function doOut (e:MouseEvent):void
		{
			_outCommand.execute ();
		}

	}

}