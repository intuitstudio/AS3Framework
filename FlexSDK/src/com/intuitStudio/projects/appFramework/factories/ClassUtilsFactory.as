package com.intuitStudio.projects.appFramework.factories
{
	import com.intuitStudio.framework.managers.classes.AClassResolverCreator;
	import com.intuitStudio.framework.managers.classes.ClassResolver;
	import com.intuitStudio.projects.appFramework.managers.ClassUtils;
	
	/**
	 * ClassUtilsFactory Class
	 * @author vanier peng
	 * 負責建構工具型態的類別集合
	 */
	public class ClassUtilsFactory extends AClassResolverCreator
	{
		
		public function ClassUtilsFactory()
		{
		
		}
		
		override public function makeUniqueCR():ClassResolver
		{
			return new ClassUtils();
		}
	}

}