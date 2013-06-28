package com.intuitStudio.scriptGraphics.stemGenerate.factories.abstracts
{
	import com.intuitStudio.scriptGraphics.stemGenerate.abstracts.AbstractStemCluster;
	import com.intuitStudio.scriptGraphics.stemGenerate.interfaces.IStem;
	
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	public class StemClusterFactory
	{
		protected var _cluster:AbstractStemCluster;
		
		public function StemClusterFactory()
		{
			
		}
		
		final public function makeStemCluster(top:DisplayObjectContainer,place:Point,wild:Number,stems:int,pieces:int):AbstractStemCluster
		{
			_cluster = doMakeStemCluster(top,place,wild,stems,pieces);
			return _cluster;
		}
		
		protected function doMakeStemCluster(top:DisplayObjectContainer,place:Point,wild:Number,stems:int,pieces:int):AbstractStemCluster
		{
			throw new IllegalOperationError('doMakeStemCluster must be overridden');
		}
		
		final public function snapshot ():BitmapData
		{			
		    //trace('snapshot wild ',2*_cluster.clusterWild)
			var sprite:BitmapData = new BitmapData(2*_cluster.clusterWild,_cluster.tall,true,0);
			var matrix:Matrix = new Matrix();
			matrix.translate(_cluster.clusterWild,_cluster.tall);
			sprite.draw (AbstractStemCluster(_cluster).content,matrix,null,BlendMode.NORMAL,null,false);
			return sprite;
		}
		
	}
}