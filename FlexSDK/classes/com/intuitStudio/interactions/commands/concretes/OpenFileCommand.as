package com.intuitStudio.interactions.commands.concretes
{
	import flash.net.FileReference;

	import com.intuitStudio.interactions.commands.abstracts.AbstractCommand;
	import com.intuitStudio.interactions.commands.interfaces.ICommand;
	import com.intuitStudio.loaders.core.OpenLocalFile;

	public class OpenFileCommand extends AbstractCommand implements ICommand
	{
		public function OpenFileCommand (receiver:* = null)
		{
			super (receiver);
		}

		override protected function doExecution ():void
		{
			OpenLocalFile(receiver).browse ();
		}

	}

}