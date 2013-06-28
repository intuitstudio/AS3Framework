package com.intuitStudio.projects.common.garden.builder.concretes
{
	import com.intuitStudio.projects.common.garden.builder.abstracts.*;
	import com.intuitStudio.projects.common.garden.builder.concretes.BambooCluster;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BambooDirector extends AbstractDisplayDirector
	{
		private const _wild:Number = 1000;
		private const _tall:Number = 700;

		public function BambooDirector (builder:AbstractDisplayBuilder)
		{
			super (builder);
		}

		override public function getView ():BitmapData
		{
			//create display area
			_builder.width = _wild;
			_builder.height = _tall;
			_builder.createDisplay ();
			//create clusters plants
			
			createLeftBottomWildBamboo();
			createLeftBottomNarrowBamboo();
			
			createRightBottomWildBamboo();
			createRightBottomNarrowBamboo();
			
			createMiddleBottomNormalBamboo();
			
			createRandomBottomFewBamboo();
			createRandomBottomMoreBamboo();
			createRandomBottomHeaviorBamboo();
			
			return _builder.getView();
		}

		private function createLeftBottomWildBamboo ():void
		{
			//assignRect (64,_tall-300);
			assignRect (0,_tall-366);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_WILD_BRANCHES);
		}
		
		private function createLeftBottomNarrowBamboo ():void
		{
			assignRect (60,_tall-330);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_NARROW_BRANCHES);
		}

		private function createRightBottomWildBamboo ():void
		{
			assignRect (_wild-225,_tall-330);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_WILD_BRANCHES);
		}

		private function createRightBottomNarrowBamboo ():void
		{
			assignRect (_wild-90,_tall-330);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_NARROW_BRANCHES);
		}

		private function createMiddleBottomNormalBamboo ():void
		{
			assignRect (360,_tall-330);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_NORMAL_BRANCHES);
		}

		private function createRandomBottomFewBamboo ():void
		{
			assignRect (Math.random()*(_wild-240)+15,_tall-340);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_FEW_LEAVES);
		}

		private function createRandomBottomMoreBamboo ():void
		{
			assignRect (Math.random()*(_wild-240)+30,_tall-340);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_MORE_LEAVES);
		}

		private function createRandomBottomHeaviorBamboo ():void
		{
			assignRect (Math.random()*(_wild-240)+30,_tall-366);
			StemClusterBuilder(_builder).createStemCluster (rect,BambooCluster.STEM_CLUSTER_HEAVIER_LEAVES);
		}

	}
}