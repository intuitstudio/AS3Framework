package com.intuitStudio.common.garden
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;

	import com.intuitStudio.utils.GameTimer;
	import com.intuitStudio.scriptGraphics.stemGenerate.abstracts.AbstractStemCluster;
	import com.intuitStudio.scriptGraphics.stemGenerate.interfaces.IStem;
	import com.intuitStudio.scriptGraphics.stemGenerate.concretes.Bamboo;
	import com.intuitStudio.scriptGraphics.stemGenerate.factories.abstracts.StemClusterFactory;
	import com.intuitStudio.scriptGraphics.stemGenerate.factories.BambooFactory;
	import com.intuitStudio.scriptGraphics.stemGenerate.factories.JasmineFactory;
	//buliders
	import com.intuitStudio.common.garden.builder.abstracts.*;
	import com.intuitStudio.common.garden.builder.concretes.*;




	public class StemGenerator extends Sprite
	{
		private var _stage:Stage;
		private var gametimer:GameTimer;
		private var myPlants:IStem;
		private var _factory:StemClusterFactory;

		private var gardenBuilder:AbstractDisplayBuilder;
		private var gardenDirector:AbstractDisplayDirector;
		private var myGarden:BitmapData;
		private var frontLayer:Sprite = new Sprite();

		public function StemGenerator (top:Stage)
		{

			if (top)
			{
				_stage = top;
				init ();
			}
			else
			{
				addEventListener (Event.ADDED_TO_STAGE,init,false,0,true);
			}

			//
		}

		private function init (e:Event=null):void
		{
			if (e)
			{
				_stage = e.target.stage;
				removeEventListener (Event.ADDED_TO_STAGE,init);
			}
			gametimer = new GameTimer();
			addEventListener (Event.ENTER_FRAME,enterFrameHandler,false,0,true);
			launch ();
		}

		private function launch ():void
		{
			
			
			frontLayer = new Sprite();
	        addChild(frontLayer);
			
			//with factory
			/*
			_factory = new BambooFactory();
			//var plants:IStem = _factory.makeStemCluster(_stage,new Point(0,_stage.stageHeight),50,10,13) as IStem;
			//addChild(_factory.makeStemCluster(frontLayer,new Point(0,_stage.stageHeight),225,30,13) as AbstractStemCluster);
            _factory.makeStemCluster(frontLayer,new Point(0,0),225,30,13);
			var clone:Bitmap = new Bitmap(_factory.snapshot());
			clone.x = 10;
			clone.y = _stage.stageHeight-clone.bitmapData.height;
			//addChild(clone);
			*/
			
			//with bulid bambooes
			gardenBuilder = new BambooCluster(frontLayer);
			gardenDirector = new BambooDirector(gardenBuilder);
			var view:BitmapData = gardenDirector.getView().clone();
            addChild(new Bitmap(view));

			gardenBuilder = new JasmineCluster(frontLayer);
			gardenDirector = new JasmineDirector(gardenBuilder);
			view = gardenDirector.getView().clone();
            addChild(new Bitmap(view));

			gardenBuilder = new StubbyCluster(frontLayer);
			gardenDirector = new StubbyDirector(gardenBuilder);
			view = gardenDirector.getView().clone();
            addChild(new Bitmap(view));

/*
			myPlants = new Bamboo(_stage,225,10,13);
			myPlants.plant (700,600);
			//;
			_factory = new BambooFactory();
			var plants:IStem = _factory.makeStemCluster(_stage,50,10,13);
			plants.plant (10,600);

			_factory.makeStemCluster(_stage,50,30,13).plant (200,600);
			_factory.makeStemCluster(_stage,50,60,5).plant (400,600);
			_factory.makeStemCluster(_stage,25,30,30).plant (600,600);

			_factory = new JasmineFactory();
			_factory.makeStemCluster(_stage,225,30,13).plant (100,450);
*/

		}

		private function enterFrameHandler (e:Event=null):void
		{
			gametimer.tick ();
			gameStep (gametimer.frameMs);
			renderScene ();
		}

		private function gameStep (frameMs:uint):void
		{

		}

		private function renderScene ():void
		{

		}

		public function resize ():void
		{

		}

		public function dispose ():void
		{

		}

	}

}