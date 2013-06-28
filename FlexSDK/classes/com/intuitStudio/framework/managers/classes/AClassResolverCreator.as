package com.intuitStudio.framework.managers.classes
{
	
	/**
	 * AClassResolverCreator Class
	 * @author vanier peng,2013.5.20
	 * ClassResolver的抽象建構者
	 */
	
	public class AClassResolverCreator extends Object implements IClassResolverCreator
	{
		
		public function AClassResolverCreator()
		{
		
		}
		
		public function makeUniqueCR():ClassResolver
		{
			return new ClassResolver();
		}
	}

}