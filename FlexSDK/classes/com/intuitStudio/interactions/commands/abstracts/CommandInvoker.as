package com.intuitStudio.interactions.commands.abstracts
{

	public class CommandInvoker
	{
		private var currentCommand:ICommand;

		public function setCommand (c:ICommand)
		{
			this.currentCommand = c;
		}

		public function executeCommand ():void
		{
			this.currentCommand.execute ();
		}

	}
}