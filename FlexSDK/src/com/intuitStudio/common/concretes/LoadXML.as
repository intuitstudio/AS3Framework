package com.intuitStudio.common.concretes
{
	import com.intuitStudio.dataProcess.XML.core.XMLWrapper;

	public class LoadXML extends XMLWrapper
	{
		public  function LoadXML(pathOrClass:Object)
		{
			super(pathOrClass);
		}
		
		override protected function makeXMLByFactory (assetName:String):XML
		{			
			return null;
		}
	}
}