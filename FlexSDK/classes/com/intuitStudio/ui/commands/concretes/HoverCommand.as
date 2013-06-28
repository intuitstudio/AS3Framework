package com.intuitStudio.ui.commands.concretes
{
	import com.intuitStudio.ui.commands.abstracts.AbstractCommand;
	import com.intuitStudio.ui.commands.interfaces.ICommand;

	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.display.DisplayObject;

	public class HoverCommand extends AbstractCommand implements ICommand
	{
		static public const HOVER_GLOW:int = 0;
		static public const HOVER_SHADOW:int = 1;
		static public const HOVER_GLOW_SHADOW:int = 2;

		public function HoverCommand(receiver:*=null)
		{
			super (receiver);
			type = HOVER_GLOW_SHADOW;
		}

		override protected function doExecution ():void
		{
			var glow:GlowFilter = new GlowFilter(0x33FFFF,2,6,6,2,1);
			var dropShadow:DropShadowFilter = new DropShadowFilter(2);
			var filters:Array = new Array();

			switch (type)
			{
				case HOVER_GLOW :
					filters.push (glow);
					break;
				case HOVER_SHADOW :
					filters.push (dropShadow);
					break;
				case HOVER_GLOW_SHADOW :
					filters.push (glow);
					filters.push (dropShadow);
					break;				    
			}

			(receiver as DisplayObject).filters = filters;
		}
	}

}