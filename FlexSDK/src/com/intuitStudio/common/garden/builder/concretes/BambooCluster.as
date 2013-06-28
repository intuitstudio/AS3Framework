package com.intuitStudio.projects.common.garden.builder.concretes
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import com.intuitStudio.scriptGraphics.stemGenerate.interfaces.IStem;
	import com.intuitStudio.projects.common.garden.builder.abstracts.StemClusterBuilder;
	import com.intuitStudio.scriptGraphics.stemGenerate.factories.BambooFactory;

	public class BambooCluster extends StemClusterBuilder
	{
		public static const STEM_CLUSTER_WILD_BRANCHES:int = 0;
		public static const STEM_CLUSTER_WILD_MORE_BRANCHES:int = 1;
		public static const STEM_CLUSTER_NARROW_BRANCHES:int = 2;
		public static const STEM_CLUSTER_NORMAL_BRANCHES:int = 3;
		public static const STEM_CLUSTER_FEW_LEAVES:int = 4;
		public static const STEM_CLUSTER_MORE_LEAVES:int = 5;
		public static const STEM_CLUSTER_HEAVIER_LEAVES:int = 6;

		public function BambooCluster (top:DisplayObjectContainer)
		{
			_factory = new BambooFactory();
			super (top);
		}

		override protected function doCreateStemCluster (type:int):IStem
		{
			var shrub:IStem;
			switch (type)
			{
				case BambooCluster.STEM_CLUSTER_WILD_BRANCHES :
					shrub = createWildBranches();
					break;
				case BambooCluster.STEM_CLUSTER_WILD_MORE_BRANCHES :
					shrub = createWildMoreBranches();
					break;
				case BambooCluster.STEM_CLUSTER_NARROW_BRANCHES :
					shrub = createNarrowBranches();
					break;
				case BambooCluster.STEM_CLUSTER_NORMAL_BRANCHES :
					shrub = createNormalBranches();
					break;
				case BambooCluster.STEM_CLUSTER_FEW_LEAVES :
					shrub = createFewLeaves();
					break;
				case BambooCluster.STEM_CLUSTER_MORE_LEAVES :
					shrub = createMoreLeaves();
					break;
				case BambooCluster.STEM_CLUSTER_HEAVIER_LEAVES :
					shrub = createHeavierLeaves();
					break;
			}
			return shrub;
		}

		private function createWildBranches ():IStem
		{		
			return _factory.makeStemCluster(_top,_pt,225,30,13);
		}

		private function createWildMoreBranches ():IStem
		{
			return _factory.makeStemCluster(_top,_pt,225,60,13);
		}

		private function createNarrowBranches ():IStem
		{
			return _factory.makeStemCluster(_top,_pt,90,30,13);
		}

		private function createNormalBranches ():IStem
		{
			return _factory.makeStemCluster(_top,_pt,150,30,13);
		}

		private function createFewLeaves ():IStem
		{
			return _factory.makeStemCluster(_top,_pt,90,18,5);
		}

		private function createMoreLeaves ():IStem
		{
			return _factory.makeStemCluster(_top,_pt,120,24,7);
		}

		private function createHeavierLeaves ():IStem
		{
			return _factory.makeStemCluster(_top,_pt,120,30,30);
		}

	}


}