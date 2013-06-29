package com.intuitStudio.projects.appFramework
{	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;	
	import flash.events.TouchEvent;	
	import flash.errors.IllegalOperationError;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	import flash.external.ExternalInterface;
	
	//framework classes
	import com.intuitStudio.framework.abstracts.GameInstance;
	import com.intuitStudio.framework.managers.classes.ClassResolverSingleton;
	import com.intuitStudio.common.factories.abstracts.AssetsFB;
	import com.intuitStudio.projects.appFramework.factories.Assets;
    import com.intuitStudio.biMotion.core.Point2d;
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.triMotion.core.Point3d;
	import com.intuitStudio.triMotion.core.Vector3;
	//tools
	import com.intuitStudio.loaders.core.SafeLoaderWrapper;
	import com.intuitStudio.utils.*;
	//project class 
	import com.intuitStudio.interactions.commands.concretes.*;
	import com.intuitStudio.interactions.commands.interfaces.ICommand;
	
	import aeon.animators.Tweener;
	import aeon.animators.Transformer3D;
	import aeon.AnimationSequence;
	import aeon.AnimationComposite;
	
	import aeon.easing.Quad;
	import aeon.easing.Bounce;
	import aeon.easing.Elastic;
	import aeon.easing.Sine;
	import aeon.events.AnimationEvent;
	
	public class GameMain extends GameInstance
	{
		//game configuration
		private var assetLoader:SafeLoaderWrapper;
		private var currentApp:MovieClip;
		private var currentGame:MovieClip;
		private var defaultDuration:Number = 800;
		
		private var assetFc:Assets;
		
		
		public function GameMain(coordinate:String = '2d') {
			super(coordinate);
		}
		
		override public function init():void
		{
			super.init();
			_stage.addEventListener(Event.RESIZE, onResizeStage, false, 0, true);
			launch();
		}
		
		override public function launch():void
		{
			//TODO lauch application
	
			Assets.register();

				
			//--------------------
			//var center:Point3d = makePoint('3d') as Point3d;
		
			playingNow = true;			
			super.launch();
		}

		override protected function onCaptureStageEvents(e:*):void 
		{
			if (e is MouseEvent) {
				(e.type === MouseEvent.MOUSE_DOWN)
				?onPressMouse(e):(e.type === MouseEvent.MOUSE_MOVE)?onMovingMouse(e):null;
			}
			
			if ( e is KeyboardEvent)
			{
				(e.type === KeyboardEvent.KEY_DOWN)
				?onPressKeyboard(e):(e.type === KeyboardEvent.KEY_UP)?onReleaseKeyboard(e):null;
			}						
		}		
		
		
		
		
		
		override protected function gameStep(frameMs:Number):void
		{
			if (playingNow)
			{
				var elapsed:Number = frameMs / 1000;
				//-------------------------
			
		
				
				//-------------------------
				renderScene();
			}
		}
		
		override protected function renderScene():void
		{
			//--------call objects' rendering method------------

		}
		
		//------------------------------------------------
		private function makePoint(geo:String = '2d'):*
		{
			var point:*;
			var dest:Object;
			
			if (geo === '2d')
			{
				dest = MathTools.getRandomPoint(_stage.stageWidth, _stage.stageHeight);
				point = new Point2d(dest.x, dest.y);
			}
			
			if (geo === '3d')
			{
				dest = MathTools.getRandomPoint(_stage.stageWidth >> 1, _stage.stageHeight >> 1, 125);
				point = new Point3d(dest.x, dest.y, dest.z);
				point.perspective = projection;
				point.perspective.center = new Vector3D(0, 0, 200);
			}
			
			return point;
		}
		
		private function createVector():void
		{
			var v2:Vector2d = new Vector2d(100, 100);
			v2.rendering(contentLayer);
		} 
		
		//-----------------------------------------------
		
		private function makeTestSafeLoader(url:String):void
		{
			if (assetLoader != null)
			{
				assetLoader.unload();
			}
			else
			{
				assetLoader = new SafeLoaderWrapper;
			}
			
			if (contentLayer.numChildren > 0)
			{
				clearContent();
			}
			
			//trace ('content children has ',contentLayer.numChildren);
			assetLoader.addEventListener(Event.COMPLETE, onAppLoaded);
			assetLoader.load(url);
		}
		
		private function clearContent():void
		{
			trace('clear ', contentLayer.numChildren, currentApp);
			//for (var i:int=contentLayer.numChildren-1; i>=0; i--)
			//{
			//var item:DisplayObject = contentLayer.getChildAt(i) as DisplayObject;
			//contentLayer.removeChild (item);
			//}
			
			if (currentApp)
			{
				if (currentApp.hasOwnProperty('dispose'))
				{
					currentApp.dispose();
				}
				
				if (contentLayer.contains(currentApp))
				{
					currentApp.mask = null;
					contentLayer.removeChild(currentApp);
				}
				
				if (contentLayer.contains(currentGame))
				{
					contentLayer.removeChild(currentGame);
				}
				
			}
		}
		
		private function onAppLoaded(e:Event):void
		{
			
			currentGame = assetLoader.content as MovieClip;
			assetLoader.removeEventListener(Event.COMPLETE, onAppLoaded);
			contentLayer.addChild(currentGame);
			
			if (currentGame)
			{
				if (currentGame.hasOwnProperty("app"))
				{
					currentApp = currentGame.app;
				}
				else
				{
					currentApp = currentGame;
				}
				
				if (_stage.contains(currentApp))
				{
					trace('remove app from stage ', currentApp);
					_stage.removeChild(currentApp);
				}
				
				currentApp.alpha = 0;
				contentLayer.addChild(currentApp);
				var w:Number = currentApp.width;
				var h:Number = currentApp.height;
				trace('app size ', w, h);
				
				var tween:Tweener = new Tweener(currentApp, {alpha: 0}, {alpha: 1}, defaultDuration * 2, Sine.easeInOut);
				tween.addEventListener(AnimationEvent.END, onEndTween);
				tween.start();
				
				function onEndTween(e:AnimationEvent):void
				{
					tween.removeEventListener(AnimationEvent.END, onEndTween);
					trace('app show ');
				}
				
				/*
				   if (w > 0 || h > 0)
				   {
				   currentApp.x = (_stage.stageWidth-w)>>1;
				   currentApp.y = (_stage.stageHeight-h)>>1;
				   setMask (currentApp,new Rectangle(currentApp.x,currentApp.y,w,h));
				   }
				   else
				   {
				   setMask (currentApp,new Rectangle(currentApp.x,currentApp.y,_stage.stageWidth,_stage.stageHeight));
				   }
				
				   addCloseButton (new Point(currentApp.x+w,currentApp.y));
				 */
			}
		
		}
		
		private function closeApp(e:MouseEvent):void
		{
			clearContent();
		}
		

				
		//---------------------------------------------------------;
		private function checkBounds(obj:*):void
		{
			var size:Number = 0;
			var offsetx:Number = obj.size * .5;
			var offsetz:Number = obj.size * .5;
			
			if (obj.x > boundary.right - size + offsetx)
			{
				trace('hit right');
				obj.x = boundary.right - size + offsetx;
				obj.vx *= bounce;
			}
			
			if (obj.x < boundary.left - size * .5 + offsetx)
			{
				trace('hit left');
				obj.x = boundary.left - size * .5 + offsetx;
				obj.vx *= bounce;
			}
			
			if (obj.z > boundary.fore - size + offsetz)
			{
				trace('hit fore');
				obj.z = boundary.fore - size + offsetz;
				obj.vz *= bounce;
			}
			
			if (obj.z < boundary.back - size * .5 + offsetz)
			{
				trace('hit back');
				obj.z = boundary.back - size * .5 + offsetz;
				obj.vz *= bounce;
			}
			
			if (obj.y > boundary.bottom)
			{
				obj.y = boundary.bottom;
				obj.vy *= bounce;
			}
		}
		
		private function checkCollisions():void
		{
		
		}
		
		private function onCaptureMouse(e:MouseEvent):void
		{
			
			
		}
		
		private function onCaptureTouch(e:TouchEvent):void
		{
			
		}
		
		private function onCaptureKeyboard(e:KeyboardEvent):void
		{
			
		}
		
		
		private function onPressMouse(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
			

		}
		
		private function onMovingMouse(e:MouseEvent):void
		{

		}
		
		private function onReleaseMouse(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.ARROW;

			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
		}
 
		
		private function onPressKeyboard(e:KeyboardEvent):void
		{
			
			switch (e.keyCode)
			{
				case Keyboard.UP: 
					break;
				case Keyboard.DOWN: 
					break;
				case Keyboard.RIGHT:
					
					break;
				case Keyboard.LEFT:
					
					break;
				case Keyboard.SPACE: 
					break;
				case Keyboard.M: 
					break;
				case Keyboard.SHIFT: 
					break;
				default: 
					break;
			}
		}
		
		private function onReleaseKeyboard(e:KeyboardEvent):void
		{
	
			switch (e.keyCode)
			{
				case Keyboard.UP:					
					break;
				case Keyboard.DOWN:					
					break;
				case Keyboard.RIGHT:					
					break;
				case Keyboard.LEFT:					
					break;
				case Keyboard.SPACE: 
					break;
				case Keyboard.SHIFT:				
					break;
			}
			//stage.removeEventListener (KeyboardEvent.KEY_UP,onReleaseKeyboard);
		}
	
	}
} 