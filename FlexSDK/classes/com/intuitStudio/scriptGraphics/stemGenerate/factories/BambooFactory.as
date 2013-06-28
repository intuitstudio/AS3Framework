package com.intuitStudio.scriptGraphics.stemGenerate.factories
{
	import com.intuitStudio.scriptGraphics.stemGenerate.factories.abstracts.StemClusterFactory;
	import com.intuitStudio.scriptGraphics.stemGenerate.abstracts.AbstractStemCluster;
	import com.intuitStudio.scriptGraphics.stemGenerate.interfaces.IStem;
	import com.intuitStudio.scriptGraphics.stemGenerate.concretes.Bamboo;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class BambooFactory extends StemClusterFactory
	{
		override protected function doMakeStemCluster(top:DisplayObjectContainer,place:Point,wild:Number,stems:int,pieces:int):AbstractStemCluster
		{			
			_cluster = new Bamboo(top,wild,stems,pieces);
			_cluster.plant(place.x,place.y);
			return _cluster;			
		}
	}
	
	
}