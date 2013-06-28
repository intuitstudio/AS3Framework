package com.intuitStudio.scriptGraphics.stemGenerate.concretes
{
	import com.intuitStudio.scriptGraphics.stemGenerate.abstracts.AbstractStemCluster;
    import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;

	public class Stubby extends AbstractStemCluster
	{
		public function Stubby (top:DisplayObjectContainer,wild:Number,stems:int,pieces:int)
		{
			BranchClass = Class(getDefinitionByName('Segment'));
			LeafClass = Class(getDefinitionByName('Leaf'));

			super (top,wild,stems,pieces);
		}

        override protected function doInitSegment():void
		{
			segments =  Math.floor(Math.random() * 70);
			leafxScale = .15;
			leafyScale = .45;
		}
 
	}
}