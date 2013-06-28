package com.intuitStudio.framework.managers.classes
{
	/**
	 * ClassResolver Class
	 * @author vanier peng,2013.5.8
	 * 類別解析器，用來替代getDefinitionByName()函式的使用
	 */
	import flash.utils.Dictionary;
	
	public class ClassResolver
	{
		private var _classes:Dictionary = new Dictionary();
		
		/**
		 * 登記class
		 * @param {classRef:Class} , 欲登記的目標類別
		 * @param {id:String} , 使用id值(別名)來表示類別
		 * @parem {overwrite:Boolean}，是否覆寫同名id
		 * @return {result:Boolean} , 登記成功回傳真,失敗則回傳假
		 */
		public  function registerClass(classRef:Class, id:String, overwrite:Boolean = false):Boolean
		{
			var result:Boolean = overwrite || !_classes.hasOwnProperty(id);
			if (result)
				_classes[id] = classRef;
			return result;
		}
		
		/**
		 * 登記多組class
		 * @param {classRef:Class} , 欲登記的目標類別
		 * @param {id:String} , 使用id值(別名)來表示類別
		 * @parem {overwrite:Boolean}，是否覆寫同名id
		 * @return {result:Vector.<String>} , 登記成功回一組id的向量值,若存在非class時則抛出錯誤物件
		 */
		public function registerClasses(classes:Dictionary, overwrite:Boolean = false):Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			for (var id:String in classes)
			{
				if (classes[id] is Class)
				{
					if (!registerClass(classes[id], id, overwrite))
						result.push(id);
				}
				else
					throw new Error("parameter " + classes[id] + " for id \"" + id + "\" is not a class");
			}
			return result;
		}
		
		/**
		 * 查詢指定id別名的類別
		 * @param   {id:String} , 指定id字串
		 * @param   {strictCheck:Boolean} , 是否嚴格檢查，若值為真且無登記類別存在時,直接抛出錯誤
		 * @return  {}
		 */
		public function getClass(id:String, strictCheck:Boolean = true):Class
		{
			if (strictCheck && !classExists(id))
				throw new Error("no class registered for id \"" + id + "\"");
			return _classes[id];
		}
		
		/**
		 * 檢查別名id的關連類別是否已登記
		 * @param  {id:String} , 別名
		 * @return {Boolean}
		 */
		public function classExists(id:String):Boolean
		{
			return _classes.hasOwnProperty(id);
		}
	
	}

}