package com.intuitStudio.framework.abstracts
{
	import com.intuitStudio.framework.interfaces.IEmbedAssets;
	import flash.errors.IllegalOperationError;
	import flash.utils.getDefinitionByName;

	public class EmbedAssets implements IEmbedAssets
	{
		private var _classRefPath:String;

		public function set classRefPath (value:String):void
		{
             _classRefPath = value;
		}
		
		public function get classRefPath ():String
		{
             return _classRefPath;
		}

		public function getAssetByName (symbolName:String):*
		{
			var classRef:Class = getDefinitionByName(symbolName) as Class;
			if (classRef)
			{
				return makeInstance(classRef);
			}
			else
			{
				throw new IllegalOperationError("Invalid asset : " + symbolName);
				return null;
			}
		}
		
		protected function makeInstance(classRef:Class):*
		{
			throw new IllegalOperationError('makeInstance must be overridden!');
			return null;
		}
	}
}