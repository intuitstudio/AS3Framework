package com.intuitStudio.projects.appFramework.factories
{
	import com.intuitStudio.framework.managers.classes.*;
	import com.intuitStudio.projects.appFramework.managers.ClassFramework;
	
	/**
	 * ClassUtilsFactory Class
	 * @author vanier peng
	 * 負責建構程式框架的類別集合
	 */
	public class ClassFrameworkFactory extends AClassResolverCreator
	{
		
		public function ClassFrameworkFactory()
		{
		
		}
		
		override public function makeUniqueCR():ClassResolver
		{
			return new ClassFramework();
		}
	}

}