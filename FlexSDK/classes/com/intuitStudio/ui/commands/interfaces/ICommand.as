package com.intuitStudio.ui.commands.interfaces
{	
	public interface ICommand
	{
		function execute():void;
		function set type(value:int):void;
		function get type():int;
	}
	
}