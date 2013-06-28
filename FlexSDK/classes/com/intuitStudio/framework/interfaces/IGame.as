package com.intuitStudio.framework.interfaces
{
	public interface IGame extends IShell
	{
		function launch():void;		
		function setup():void;
		function quit():void;
		function get coordinate():String;
		function set coordinate(mode:String):void;
	}	
}