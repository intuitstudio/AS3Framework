package com.intuitStudio.framework.interfaces
{	
	import flash.display.DisplayObjectContainer;
	
	public interface IGameFactory
	{
		function makeGame(coordinate:String):IGame;
	}
}