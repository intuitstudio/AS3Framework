package com.intuitStudio.ui.commands.concretes
{
	import com.intuitStudio.ui.commands.abstracts.AbstractCommand;
	import com.intuitStudio.ui.commands.interfaces.ICommand;
	

	public class NavigateCommand extends AbstractCommand implements ICommand
	{
		static public const START_UP:int = 0;
		static public const STOP_UP:int = 1;
		static public const START_DOWN:int = 2;
		static public const STOP_DOWN:int = 3;
		static public const START_LEFT:int = 4;
		static public const STOP_LEFT:int = 5;
		static public const START_RIGHT:int = 6;
		static public const STOP_RIGHT:int = 7;		

		public function NavigateCommand (receiver:*)
		{
			super (receiver);
		}

		override protected function doExecution ():void
		{
			switch (type)
			{
				case START_UP :
					receiver.startNavigate ('up');
					break;
				case STOP_UP :
					receiver.stopNavigate ('up');
					break;
				case START_DOWN :
					receiver.startNavigate ('down');
					break;
				case STOP_DOWN:
					receiver.stopNavigate ('down');
					break;
				case START_LEFT :
					receiver.startNavigate ('left');
					break;
				case STOP_LEFT :
					receiver.stopNavigate ('left');
					break;
				case START_RIGHT :
					receiver.startNavigate ('right');
					break;
				case STOP_RIGHT :
					receiver.stopNavigate ('right');
					break;
			}
		}

	}
}