package com.intuitStudio.flip.abstracts 
{
	/**
	 * FlipPageContainer Class
	 * @author vanier peng,2012,4,23
	 * 翻頁頁容器
	 */
	import com.intuitStudio.flip.core.*;
	 
	public class FlipPageContainer 
	{
		private var _smoothing:Boolean;
		
		
		public function FlipPageContainer() 
		{
			
		}
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
		}
		
	}

}