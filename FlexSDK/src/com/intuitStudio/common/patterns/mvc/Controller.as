package com.intuitStudio.common.patterns.mvc
{
	public class Controller extends Object
	{
		protected var _mdl:Model;
		protected var _view:View;

		public function Controller (mdl:Model=null,view:View=null)
		{
             _mdl = mdl;
			 _view = view;
		}

		public function get mdl ():Model
		{
			return _mdl;
		}
		
		public function set mdl (mdl:Model):void
		{
			_mdl = mdl;
		}

		public function get view ():View
		{
			return _view;
		}
		public function set view (view:View):void
		{
			_view = view;
		}

	}
}