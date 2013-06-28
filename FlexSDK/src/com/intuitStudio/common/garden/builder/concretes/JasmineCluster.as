package com.intuitStudio.projects.common.garden.builder.concretes
{
	import flash.display.DisplayObjectContainer;

	import com.intuitStudio.scriptGraphics.stemGenerate.interfaces.IStem;
	import com.intuitStudio.projects.common.garden.builder.abstracts.StemClusterBuilder;
	import com.intuitStudio.scriptGraphics.stemGenerate.factories.JasmineFactory;

	public class JasmineCluster extends StemClusterBuilder
	{
		public function JasmineCluster (top:DisplayObjectContainer)
		{
			_factory = new JasmineFactory();
			super (top);
		}

		override protected function doCreateStemCluster (type:int):IStem
		{
			return  _factory.makeStemCluster(_top,_pt,120,30,13);
		}
	}
}