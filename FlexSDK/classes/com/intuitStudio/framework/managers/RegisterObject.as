package com.intuitStudio.framework.managers
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.errors.IllegalOperationError;
	
	
	public class RegisterObject
	{
		private var _objects:Vector.<Object>;
		private var _objectsDic:Dictionary;
		private var _pointer:int=0;
		
		public function RegisterObject()
		{
			_objects = new Vector.<Object>();
			_objectsDic = new Dictionary();			
		}
		
		public function add(obj:Object,symbol:Object=null):void
		{
			if(symbol==null)
			{
				symbol = obj.name;
			}
			//
			registerObject(obj,symbol);
		}
		
		public function remove(symbol:Object):Object
		{
			return unregisterObject(symbol);
		}
		
		public function getObjectByName(symbol:Object):Object
		{
			return retrieveObject(symbol);
		}
		
		
		private function registerObject (obj:Object,symbol:Object):void
		{			
			if(_objects.indexOf(obj)==-1)
			{				
				_objects.length++;
				_objects[_pointer] = obj;
				_objectsDic[symbol] = _pointer;	
				_pointer++;
			}
			else
			{
				_pointer--;
				throw new IllegalOperationError('Object had been registered!');				
			}
		}

		private function unregisterObject (symbol:Object):Object
		{		
			_pointer--;
			var index:int = _objectsDic[symbol];
			if(_objects.indexOf(_objects[index])!=-1)
			{
			    var deled:Vector.<Object >  = _objects.splice(index,1);
			    delete _objectsDic[symbol];				    
				_pointer--;				
				//deled[0] = null;
				return deled[0];
			}
			return null;			
		}

		private function retrieveObject (symbol:Object):Object
		{
			if(_objectsDic[symbol] != undefined)
			{
			   var index:int = parseInt(_objectsDic[symbol]);				
			   return _objects[index];
			}
			else
			{
				throw new IllegalOperationError('Object is not registered yet!');				
			}
			return null;
		}
		
		public function get objects():Vector.<Object>
		{
			return _objects;
		}
				
		public function get pointer():int
		{
			return _pointer;
		}
				
	}	
	
}