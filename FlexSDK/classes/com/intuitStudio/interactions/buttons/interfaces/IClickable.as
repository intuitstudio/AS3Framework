package com.intuitStudio.interactions.buttons.interfaces
{
	import flash.events.MouseEvent;
	
	public interface IClickable extends IButton
	{
		function onClick (e:MouseEvent):void;
		function onPressDown (e:MouseEvent):void;
		function onReleaseUp (e:MouseEvent):void;
		function onDbClick (e:MouseEvent):void;
	}
}