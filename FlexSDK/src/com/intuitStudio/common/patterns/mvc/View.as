package com.intuitStudio.common.patterns.mvc
{
	import flash.display.Sprite;
	import com.intuitStudio.common.patterns.observer.interfaces.IObserver;

	public class View extends Sprite implements IObserver
	{
		protected var _mdl:Model;

		public function View (mdl:Model=null)
		{
			if (mdl)
			{
				_mdl = mdl;
			}
		}
		
		public function update(elapsed:Number=1.0):void
		{
			
		}

		public function notify (str:String):void
		{
			//throw new IllegalOperationError('notify must be overridden');
		}

		public function get mdl ():Model
		{
			return _mdl;
		}
		public function set mdl (mdl:Model):void
		{
			_mdl = mdl;
			_mdl.addObserver (this,null);
		}

	}

}