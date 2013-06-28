package com.intuitStudio.scriptGraphics.stemGenerate.concretes
{
	import com.intuitStudio.scriptGraphics.stemGenerate.abstracts.AbstractStemCluster;
    import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;

	public class Bamboo extends AbstractStemCluster
	{
		public function Bamboo (top:DisplayObjectContainer,wild:Number,stems:int,pieces:int)
		{
			BranchClass = Class(getDefinitionByName('Segment'));
			LeafClass = Class(getDefinitionByName('Leaf'));
			super (top,wild,stems,pieces);
		}

	}
}