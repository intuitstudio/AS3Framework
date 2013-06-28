package com.intuitStudio.projects.appFramework
{
	
	import aether.effects.filters.BitmapFilterEffect;
	import aether.textures.ITexture;
	import com.intuitStudio.common.factories.abstracts.AssetsFB;
	import com.intuitStudio.flash3D.concretes.*;
	import com.intuitStudio.flash3D.core.Triangle;
	import com.intuitStudio.flash3D.core.Polygon;
	import com.intuitStudio.flip.core.*;
	import com.intuitStudio.flip.abstracts.*;
	import com.intuitStudio.flip.concretes.*;
	import flash.events.TouchEvent;
	 
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.BlurFilter;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import flash.errors.IllegalOperationError;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getDefinitionByName;
	import flash.external.ExternalInterface;
	
	//framework classes
	import com.intuitStudio.framework.abstracts.GameInstance;
	import com.intuitStudio.framework.managers.classes.ClassResolverSingleton;
	//import com.intuitStudio.projects.appFramework.objects.BookXMLParser;
	//motions
	
	import com.intuitStudio.motions.flash3D.core.Vehicle3D;
	import com.intuitStudio.motions.flash3D.objects.Room;
	import com.intuitStudio.framework.abstracts.ShaderColor;
	
	import com.intuitStudio.kinematics.core.*;
	import com.intuitStudio.kinematics.*;
	import com.intuitStudio.triMotion.core.*;
	import com.intuitStudio.biMotion.core.*;
	
	//tools
	import com.intuitStudio.loaders.core.SafeLoaderWrapper;
	import com.intuitStudio.utils.*;
	//project class 
	import com.intuitStudio.interactions.commands.concretes.*;
	import com.intuitStudio.interactions.commands.interfaces.ICommand;
	
	import com.intuitStudio.motions.biDimen.core.MoveEntity;
	//import com.intuitStudio.motions.biDimen.core.Vector2D;
	import com.intuitStudio.utils.ColorUtils;
	
	import com.intuitStudio.projects.appFramework.factories.Assets;
	
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
		private var angleOffset:Number = 0;
		private var scrollZ:Boolean = false;
		
		private var assetLoader:SafeLoaderWrapper;
		private var currentApp:MovieClip;
		private var currentGame:MovieClip;
		private var defaultDuration:Number = 800;
		
		private var chains:Vector.<Object>;
		private var points:Vector.<Point2d>;
		
		private var robot:Robot;
		private var robotFeet:RobotFeet;
		private var leg:Leg;
		private var robotLayer:Sprite;
		private var reachings:Vector.<Object> = new Vector.<Object>();
		private var draggings:Vector.<Object> = new Vector.<Object>();
		
		private var spot3d:Point3d;
		private var cube:Object;
		private var pyramid:Object;
		private var cylinder:Object;
		private var letterA:Object;
		private var ik:Object;
		private var flipper:Object;
		private var rollFlipper:Boolean = false;
		private var rollStopping:Boolean = false;
		public var f_m_x:Object = {value: 0};
		
		private var pageWidth:Number = 300;
		private var pageHeight:Number = 400;
		
		private var book:FlipPageContainer;
		private var bookPages:Vector.<Object>;
		private var sourceImages:Vector.<Bitmap>;
		
		private var currentPage:int = 0;	
		private var assetFc:Assets;
		
		private var leftImages:Vector.<Bitmap>;
		private var rightImages:Vector.<Bitmap>;
		private var pagePairs:Vector.<Vector.<Bitmap>>;
		
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
			
			//test class resolver function 
			var resolver:Class = ClassResolverSingleton.getInstance().getClass('bookParser',false);
			var bookReader:* = new resolver(null);
			
	
			Assets.register();
			
			
			//create objects in app
			createRobot();
			createFlipper();
				
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
			
				movePages(elapsed);
				
				//-------------------------
				renderScene();
			}
		}
		
		override protected function renderScene():void
		{
			//--------call objects' rendering method------------
			// chains.forEach(function(item:Object,index:int,vector:Vector.<Object>):void { item.instance.rendering(item.container); } ); 	
			// draggings.forEach(function(item:Object, index:int, vector:Vector.<Object>):void { item.instance.rendering(item.container); } ); 	
			// reachings.forEach(function(item:Object,index:int,vector:Vector.<Object>):void { item.instance.rendering(item.container); } ); 	
			// ik.instance.rendering(ik.container); 
			
			//	drawPoints();
			drawRobot();
			// cube.entity.rendering(cubeLayer);
			//letterA.instance.rendering(letterA.container);
			
			if (flipper)
			{
				flipper.entity.rendering(flipper.container);
			}
		}
		
		//------------------------------------------------
		private function createRobot():void
		{
			robotLayer = makeSprite(contentLayer, 100, 100);
			leg = new Leg(100, 100);
			leg.outgrow(60, 20, 0xFF00FF);
			
			robotFeet = new RobotFeet();
			robotFeet.outgrow(60, 20, 0x00FFFF);
			robotFeet.location = new Vector2d(200, 100);
			
			robot = makeRobot(50, 20);
			setRobotState();
		}
		
		private function createFlipper():void
		{
			//create images source
			sourceImages = new Vector.<Bitmap>();
			// sourceImages.push(new AntImage());
			// sourceImages.push(new FlowerImage());
			// sourceImages.push(new SunImage());
			// sourceImages.push(new MoonImage());
			
			leftImages = new Vector.<Bitmap>();
			rightImages = new Vector.<Bitmap>();
			leftImages.push(Assets.getAssetById('cover_L'));
		    rightImages.push(Assets.getAssetById('cover_R'));
			leftImages.push(Assets.getAssetById('page0_L'));
		    rightImages.push(Assets.getAssetById('page0_R'));
			leftImages.push(Assets.getAssetById('page1_L'));
		    rightImages.push(Assets.getAssetById('page1_R'));
			leftImages.push(Assets.getAssetById('page2_L'));
		    rightImages.push(Assets.getAssetById('page2_R'));
			leftImages.push(Assets.getAssetById('page3_L'));
		    rightImages.push(Assets.getAssetById('page3_R'));
			

			pagePairs = new Vector.<Vector.<Bitmap>>();
			pagePairs.push(Vector.<Bitmap>([leftImages[0], leftImages[1]]));
			pagePairs.push(Vector.<Bitmap>([rightImages[1], leftImages[2]]));
			pagePairs.push(Vector.<Bitmap>([rightImages[2], leftImages[3]]));
			pagePairs.push(Vector.<Bitmap>([rightImages[3], leftImages[4]]));
			pagePairs.push(Vector.<Bitmap>([rightImages[4], leftImages[1]]));
			//create bitmap pieces
			
			var entity:Flipper = new Flipper(pageWidth, pageHeight, _stage.stageWidth, _stage.stageHeight);
			entity.location = new Vector2d(center.x, center.y - (pageHeight >> 1));
			
			var container:Sprite = makeSprite(contentLayer);
			container.mouseChildren = false;
			container.doubleClickEnabled = true;
			container.addEventListener(MouseEvent.DOUBLE_CLICK, onDbClickFlipper);
			
			
			flipper = { entity: entity, container: container };
			var numSlice:int  = 20;
			flipper.entity.setup(pagePairs[currentPage][0], pagePairs[currentPage + 1][1], numSlice);
			
			// flipper.entity.setup(leftImages[currentPage*2],rightImages[currentPage*2+1],numSlice);			
			f_m_x.value = pageWidth;
		
		}
		
		private function onDbClickFlipper(e:MouseEvent):void
		{
			if (checkFlippable( new Point(mouseX, mouseY))) {
				trace('Double Click Flipper to autoFlip');
			}			
		}		
		
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
		
		private function makeBook():FlipPageContainer
		{
			var pageWidth:Number = _stage.stageWidth >> 1, pageHeight:Number = _stage.stageHeight;
			var page:FlipPageContainer = new FlipPageContainer(pageWidth, pageHeight);
			page.setColor(ColorUtils.random());
			return page;
		}
		
		private function moveIK(elapsed:Number = 1.0):void
		{
			ik.instance.roll(new Vector2d(mouseX, mouseY), elapsed);
		}
		
		private function moveRobot(elapsed:Number = 1.0):void
		{
			//leg.move(elapsed);
			//robotFeet.move(elapsed);
			
			//忽略elapsed
			robot.move();
		}
		
		private function movePages(elapsed:Number = 1.0):void
		{
			if (this.rollFlipper || this.rollStopping)
			{
				flipper.entity.update();
			}
		}
		
		private function drawRobot():void
		{
			//leg.rendering(robotLayer);
			//robotFeet.rendering(robotLayer);
			robot.rendering(robotLayer);
		}
		
		private function makeSegment(w:Number, h:Number):Segment
		{
			var point:Point2d = makePoint();
			var color:uint = ColorUtils.random();
			var seg:Segment = new Segment(w, h, color, Math.abs(point.x), Math.abs(point.y));
			//seg.rotation = 0;
			//seg.gravity = 0;
			seg.velocity.zero();
			return seg;
		}
		
		private function makeFeet(w:Number, h:Number, color:uint):RobotFeet
		{
			var feet:RobotFeet = new RobotFeet();
			feet.outgrow(w, h, color);
			return feet;
		}
		
		private function makeRobot(w:Number, h:Number):Robot
		{
			
			var rob:Robot = new Robot(w, h);
			var px:Number = (_stage.stageWidth - rob.getBounds().width) >> 1;
			var py:Number = (_stage.stageHeight - rob.getBounds().height) >> 1;
			rob.location = new Vector2d(px, py);
			rob.setMargin(_stage.stageWidth, _stage.stageHeight);
			rob.gravity = 1;
			rob.friction = 0.1;
			//  rob.minDist = .1;
			return rob;
		
		}
		
		private function setRobotState():void
		{
			var tempo:Number = .3;
			var thighRange:Number = 25;
			var thighBase:Number = 81;
			var calfRange:Number = 20;
			var calfOffset:Number = -90;
			
			robot.makeWalkState(tempo, thighRange, thighBase, calfRange, calfOffset);
		}
		
		private function moveChains(elapsed:Number):void
		{
			chains.forEach(function(item:Object, index:int, vector:Vector.<Object>):void
				{
					item.instance.move(elapsed);
				});
		}
		
		private function moveDraggings(elapsed:Number):void
		{
			var segments:Vector.<Segment> = new Vector.<Segment>();
			draggings.forEach(function(item:Object, index:int, vector:Vector.<Object>):void
				{
					segments.push(item.instance);
				});
			Segment.dragChain(segments, new Vector2d(mouseX, mouseY));
		}
		
		private function moveReachings(elapsed:Number):void
		{
			var segments:Vector.<Segment> = new Vector.<Segment>();
			reachings.forEach(function(item:Object, index:int, vector:Vector.<Object>):void
				{
					segments.push(item.instance);
				});
			Segment.rollChain(segments, new Vector2d(mouseX, mouseY));
		}
		
		private function drawChains():void
		{
			chains.forEach(function(item:Object, index:int, vector:Vector.<Object>):void
				{
					item.instance.rendering(item.container);
				});
		}
		
		private function drawPoints():void
		{
			for each (var point:Point2d in points)
			{
				point.rendering(contentLayer);
			}
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
			
			if (flipper)
			{
				rollFlipper = checkFlippable( new Point(mouseX, mouseY));
				trace('open rollFlipper ' , rollFlipper);
			}
		}
		
		private function onMovingMouse(e:MouseEvent):void
		{
			if (flipper === null || rollStopping===true) return;
			
			
			if (rollFlipper)
			{
				var cx:Number = pp.projectionCenter.x;
				f_m_x.value += (mouseX - cx - f_m_x.value) * 0.2;
				flipper.entity.handleX = f_m_x.value;
				
					 trace('rolling fipper',f_m_x.value);
			}
			else
			{
				checkFlippable( new Point(mouseX, mouseY));
			}
		}
		
		private function checkFlippable(point:Point):Boolean
		{
			var rect:Rectangle = flipper.entity.rect;
			var offset:Number = 50;
			if (containsPoint(rect,point))
			{
				if (!flipper.entity.isLeft && point.x > rect.right - offset)
				{
					Mouse.cursor = MouseCursor.HAND;
					return true;
				}else {
					
					if ( flipper.entity.isLeft && point.x < rect.left + offset) {
					   Mouse.cursor = MouseCursor.HAND;
					   return true;
					}else {
					   Mouse.cursor = MouseCursor.BUTTON;	
					}					
				}		
			}
			return false;
		}
		
		private function onReleaseMouse(e:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.ARROW;
			if(rollFlipper){
			   rollFlipper = false;			   
			   stopFlipping();
			}
			stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMouse);
		}
 
		
		private function stopFlipping():void
		{
			var w:Number = pageWidth << 1;
			var cx:Number = pp.projectionCenter.x;
			var startValue:Number = f_m_x.value + (mouseX - cx - f_m_x.value) * 0.2;
			
			rollStopping = true;
			var duration:Number = (f_m_x.value < 0) ? Math.abs((-w - f_m_x.value)) / (w) : Math.abs((w - f_m_x.value)) / (w);
			duration = Math.min(duration *1000, defaultDuration);			
			var destValue:Number = (f_m_x.value < 0) ? -w - cx : w + cx;
			
			var tween:Tweener = new Tweener(f_m_x, {value: f_m_x.value}, {value: destValue}, duration, Sine.easeInOut);
			tween.addEventListener(AnimationEvent.CHANGE, onUpdateTween);
			tween.addEventListener(AnimationEvent.END, onEndTween);
			tween.start();
			var context:* = this;
			function onUpdateTween(e:AnimationEvent):void
			{
				flipper.entity.handleX = f_m_x.value;
			}
			
			function onEndTween(e:AnimationEvent):void
			{
				tween.removeEventListener(AnimationEvent.END, onEndTween);
				rollFlipper = false;
				rollStopping = false;
				flipper.entity.handleX = f_m_x.value;
				flipper.entity.rollBack();
				flipper.entity.update();
			}
		}
		
		private function onPressKeyboard(e:KeyboardEvent):void
		{
			var pageIndex:int = 0;
			trace('press keyboard ' , e.keyCode);			
			switch (e.keyCode)
			{
				case Keyboard.UP: 
					currentPage = Math.min(currentPage + 1, 1);					
					break;
				case Keyboard.DOWN: 
					currentPage = Math.max(0, currentPage - 1);
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
					scrollZ = true;
					break;
				default: 
					break;
			}
			
			/*
			if (flipper)
			{
				flipper.entity.setup(pagePairs[currentPage][0], pagePairs[currentPage + 1][1], numSlice);
				
				//flipper.entity.setup(leftImages[currentPage * 2], rightImages[currentPage * 2 + 1], 30);
				f_m_x.value = pageWidth;
				flipper.entity.handleX = f_m_x.value;
			}
		*/
		}
		
		private function onReleaseKeyboard(e:KeyboardEvent):void
		{
			trace('release keyboard ' , e.keyCode);			
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
					scrollZ = false;
					break;
			}
			//stage.removeEventListener (KeyboardEvent.KEY_UP,onReleaseKeyboard);
		}
		

	
	}
} /*

   import flash.display.Sprite;

   Class ObjectCollection {

   private var arr:Array;
   private var contructor:Function;
   private var container:Sprite;
   public function ObjectCollection(...args)
   {
   arr = (args.length == 1 && !isNaN(args[0])) ? new Array(args[0]) : args;
   }

   public function insert(obj:Object):void {
   remove(obj);
   arr.push(obj);
   }

   public function remove(obj:Object):void {
   for(var i:uint = 0; i < arr.length; i++) {
   if(arr[i] == obj) {
   var obj:Object = arr.splice(i, 1)[0];
   }
   }
   }

   public function select(val:int, fn:Function):ObjectCollection {
   var col:ObjectCollection = new ObjectCollection();
   for(var i:uint = 0; i < arr.length; i++) {
   if(fn.call(this, arr[i], val)) {
   col.insert(arr[i]);
   }
   }
   return col;
   }

   public function toString():String {
   var str:String = new String();
   for(var i:uint = 0; i < arr.length - 1; i++) {
   str += arr[i] + ", ";
   }
   str += arr[arr.length - 1];
   return str;
   }


   }
 */