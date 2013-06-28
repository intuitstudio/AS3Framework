package com.intuitStudio.dataProcess.XML.abstracts
{
	import com.intuitStudio.dataProcess.XML.core.*;
	
	dynamic public class AbstractXMLParser extends XMLProxy
	{
		protected var _wrapper:XMLWrapper;
		protected var _source:XML;
		
		public function AbstractXMLParser(pathOrClass:Object = null)
		{
			makeWrapper(pathOrClass);
			super(_wrapper);
		}
		
		protected function makeWrapper(pathOrClass:Object = null):void
		{
			_wrapper = new XMLWrapper(pathOrClass);
		}
		
		public function get source():XML
		{
			return _source;
		}
		
		public function set source(data:XML):void
		{
			_source = data;
		}		
		
 	    public function makeXMLData():void
		{
			_wrapper.makeXMLByData(_source);
		}
		
		//get elements of specilized tag or sub tag
		override protected function getElements (params:*):*
		{
			//check tag matched from top layer to child layers; Beacuse sample XML has three layers,so the max checks is 3 times.
			var list:XMLList = xmlData.elements(String(params));
			if (! list.toString())
			{
				list = xmlData.elements().elements(String(params));

				if (! list.toString())
				{
					list = xmlData.elements().elements().elements(String(params));
				}
			}

			return list;
		}

		override protected function getAttribute (params:*):*
		{
			//check for root
			var list:XMLList = xmlData.attribute(String(params));
			//check nested child nodes
			if (! list.toString())
			{
				list = xmlData.elements().attribute(String(params));

				if (! list.toString())
				{
					list = xmlData.elements().elements().attribute(String(params));
					if (! list.toString())
					{
						list = xmlData.elements().elements().elements().attribute(String(params));
					}
				}
			}

			return list;
		}

			
		override protected function setChildNodes(params:*, value:Object):Boolean
		{
			return false;
		}
		
		override protected function setElements(params:*, value:Object):Boolean
		{
			return false;
		}
	
		public function toString():String
		{
			return 'XML Parser';
		}
		
	}
}