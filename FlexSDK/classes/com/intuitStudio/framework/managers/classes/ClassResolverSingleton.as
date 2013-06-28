package com.intuitStudio.framework.managers.classes
{
	
	/**
	 * @author vanier peng,2013.5.20
	 * 抽象類別解析器實體的操做界面，用來登錄類別、宣告以及建立類別實體；
	 * 使用獨體模式可以保有單獨且唯一的實體物件，外界則透過其類別方法存取解析器實體
	 */
	
	public class ClassResolverSingleton
	{
		//以界面替代抽象建構者，增加應用彈性
		static private var _factory:IClassResolverCreator = new AClassResolverCreator(); 
		static private var _instance:ClassResolver;
		
		public function ClassResolverSingleton()
		{
		
		}
		
		static public function getInstance():ClassResolver
		{
			if (!_instance)
			{
				_instance = _factory.makeUniqueCR();
			}
			return _instance;		
		}
		
		static public function setFactory(fc:IClassResolverCreator):void
		{
			_factory = fc;
		}
	
		public  function registerClass(classRef:Class, id:String, overwrite:Boolean = false):Boolean
        {
			return _instance.registerClass(classRef, id, overwrite);
	    }
		
		public function getClass(id:String, strictCheck:Boolean = true):Class
        {
			return _instance.getClass(id, strictCheck);
		}
		
		public function classExists(id:String):Boolean
		{
			return _instance.classExists(id);
		}
		
	}

}