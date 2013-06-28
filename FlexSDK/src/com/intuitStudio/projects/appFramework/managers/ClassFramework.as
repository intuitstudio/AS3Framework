package com.intuitStudio.projects.appFramework.managers 
{
	/**
	 * ClassFramework Class
	 * @author vanier peng
	 *  宣告及登記程式所使用到的系統框架類型的類別集合
	 */
	
	import com.intuitStudio.framework.managers.classes.ClassResolver;
	import com.intuitStudio.projects.appFramework.GameMain;
	 
	public class ClassFramework  extends ClassResolver 
	{
		
		public function ClassFramework() 
		{
			super();
			init();
		}
		
		private function init():void
		{			
			registerClass(GameMain, 'game');
			
			
			
		}
	}

}