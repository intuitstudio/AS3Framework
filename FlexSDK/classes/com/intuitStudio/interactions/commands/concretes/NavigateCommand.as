package com.intuitStudio.interactions.commands.concretes
{
	import com.intuitStudio.interactions.commands.abstracts.AbstractCommand;
	import com.intuitStudio.interactions.commands.interfaces.ICommand;
	

	public class NavigateCommand extends AbstractCommand implements ICommand
	{
		static public const START:int = 0;
		static public const STOP:int = 1;

		public function NavigateCommand (receiver:*)
		{
			super (receiver);
		}

		override protected function doExecution ():void
		{
			switch (type)
			{
				case START :
					receiver.startNavigate ();
					break;
				case STOP :
					receiver.stopNavigate ();
					break;
			}
		}

	}
}