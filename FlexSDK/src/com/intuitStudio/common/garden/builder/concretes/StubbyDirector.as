package com.intuitStudio.projects.common.garden.builder.concretes
{
	import com.intuitStudio.projects.common.garden.builder.abstracts.AbstractDisplayDirector;
	import com.intuitStudio.projects.common.garden.builder.abstracts.*;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class StubbyDirector extends AbstractDisplayDirector
	{
		private const _wild:Number = 1000;
		private const _tall:Number = 700;

		public function StubbyDirector (builder:AbstractDisplayBuilder)
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
			createLeftBottomStubby();			
			createRightBottomStubby();					
			createRandomBottomStubby();
			
			return _builder.getView();
		}

		private function createLeftBottomStubby ():void
		{
			assignRect (100,_tall-300);
			StemClusterBuilder(_builder).createStemCluster(rect);
		}
		private function createRightBottomStubby ():void
		{
			assignRect (_wild-100,_tall-300);
			StemClusterBuilder(_builder).createStemCluster(rect);
		}
		private function createRandomBottomStubby ():void
		{
			assignRect (Math.random()*(_wild-200)+200,_tall-300);
			StemClusterBuilder(_builder).createStemCluster(rect);
		}
	}
}