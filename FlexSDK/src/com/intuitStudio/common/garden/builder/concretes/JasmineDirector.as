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

	public class JasmineDirector extends AbstractDisplayDirector
	{
		private const _wild:Number = 1000;
		private const _tall:Number = 700;

		public function JasmineDirector (builder:AbstractDisplayBuilder)
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
			createLeftBottomJasmine();			
			createRightBottomJasmine();					
			createRandomBottomJasmine();
			
			return _builder.getView();
		}

		private function createLeftBottomJasmine ():void
		{
			assignRect (200,_tall-300);
			StemClusterBuilder(_builder).createStemCluster(rect);
		}
		private function createRightBottomJasmine ():void
		{
			assignRect (_wild-200,_tall-300);
			StemClusterBuilder(_builder).createStemCluster(rect);
		}
		private function createRandomBottomJasmine ():void
		{
			assignRect (Math.random()*(_wild-300)+150,_tall-300);
			StemClusterBuilder(_builder).createStemCluster(rect);
		}

	}
}