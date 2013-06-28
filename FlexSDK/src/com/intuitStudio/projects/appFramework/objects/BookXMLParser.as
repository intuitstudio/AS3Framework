package com.intuitStudio.projects.appFramework.objects
{
	import com.intuitStudio.dataProcess.XML.core.XMLWrapper;
	import com.intuitStudio.dataProcess.XML.abstracts.AbstractXMLParser;
	
		
	dynamic public class BookXMLParser extends AbstractXMLParser
	{		
		public function BookXMLParser(data:XML)
		{
			_source = data;
			super();			
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
	}
	
}