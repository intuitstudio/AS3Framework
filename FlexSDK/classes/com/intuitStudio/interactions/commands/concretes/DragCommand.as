package com.intuitStudio.interactions.commands.concretes
{
	import com.intuitStudio.interactions.commands.abstracts.AbstractCommand;
	import com.intuitStudio.interactions.commands.interfaces.ICommand;
	

	public class DragCommand extends AbstractCommand implements ICommand
	{
		static public const START:int = 0;
		static public const STOP:int = 1;

		public function DragCommand (receiver:*)
		{
			super (receiver);
		}

		override protected function doExecution ():void
		{
			switch (type)
			{
				case START :
					receiver.startDrag ( false , null );
					break;
				case STOP :
					receiver.stopDrag ();
					break;
			}
		}

	}
}