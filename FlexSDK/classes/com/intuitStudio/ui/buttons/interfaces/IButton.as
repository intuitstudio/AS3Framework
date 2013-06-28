package com.intuitStudio.ui.buttons.interfaces
{
	import com.intuitStudio.ui.commands.interfaces.ICommand;
	import flash.events.MouseEvent;
	
	public interface IButton
	{
		function setCommand(target:*,cmd:ICommand):void;
		function onHover (e:MouseEvent):void;
		function onOut (e:MouseEvent):void;
	}
}