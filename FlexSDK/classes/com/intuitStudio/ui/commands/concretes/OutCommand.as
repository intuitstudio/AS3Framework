package com.intuitStudio.ui.commands.concretes
{
	import com.intuitStudio.ui.commands.abstracts.AbstractCommand;
	import com.intuitStudio.ui.commands.interfaces.ICommand;

	import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	import flash.display.DisplayObject;


	public class OutCommand extends AbstractCommand implements ICommand
	{
		static public const CLEAR_FILTERS:int = 0;

		public function OutCommand(receiver:*=null)
		{
			super (receiver);
			type = CLEAR_FILTERS;
		}

		override protected function doExecution ():void
		{
			if (type == CLEAR_FILTERS)
			{
				(receiver as DisplayObject).filters = [];
			}
		}
	}

}