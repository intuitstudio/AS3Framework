package com.intuitStudio.interactions.commands.interfaces
{	
	public interface ICommand
	{
		function execute():void;
		//function unexecute():void;
		function set type(value:int):void;
		function get type():int;
	}
	
}