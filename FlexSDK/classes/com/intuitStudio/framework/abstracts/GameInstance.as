package com.intuitStudio.framework.abstracts
{
	import com.intuitStudio.framework.interfaces.IGame;
	import com.intuitStudio.framework.managers.RegisterObject;
	import com.intuitStudio.utils.*;	
	import com.intuitStudio.triMotion.core.*;

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	import flash.geom.Rectangle;	
	import flash.geom.Matrix3D;	
	import flash.geom.PerspectiveProjection;	
	import flash.geom.Vector3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	public class GameInstance extends MovieClip implements IGame
	{
		//宣告程式所使用的座標系統為平面或者立體
		private var gameCoordinate:String = '2d';
		protected var _container:DisplayObjectContainer;
		protected var _stage:Stage;
		protected var gametimer:GameTimer;
		protected var _register:RegisterObject;
		
		//system physic variables
		protected var projection:Perspective;
		protected var sortContainer:DisplayObjectContainer;
		private static var instance:GameInstance;	
		public static var pixelsPerUnit:Number = 20;		
		//game's object and configurations
		protected var bgLayer:Sprite;
		protected var menuLayer:Sprite;
		protected var contentLayer:Sprite;	
		
	    public var playingNow:Boolean = false;		
		//motion paramters
		public var friction:Number = .97;
		public var bounce:Number = -.6;
		public var gravity:Number = 320;
		public var easing:Number = .2;
		public var spring:Number = .1;
		public var boundary:Dictionary;

		public function GameInstance (coordinate:String = '2d')
		{
			gameCoordinate = coordinate;
			addEventListener (Event.ADDED_TO_STAGE, onAdd, false,0, true);
			//addEventListener (Event.REMOVED_FROM_STAGE, onRemove,false, 0, true);
			addEventListener (Event.RESIZE,onResize);
		}
		
		public function get coordinate():String
		{
			return gameCoordinate;
		}
		
		public function set coordinate(mode:String):void
		{
			gameCoordinate = mode;
		}		
		
		public function onAdd (e:Event):void
		{
			if (e)
			{
				removeEventListener (Event.ADDED_TO_STAGE, onAdd);
			}
			_container = e.currentTarget.parent as DisplayObjectContainer;
			
			if (_container == stage)
			{
				_stage = container as Stage;
			}
			else
			{
				_stage = container.parent as Stage;
			}
			init ();
		}


		public function set container (obj:DisplayObjectContainer):void
		{
			_container = obj;
		}

		public function get container ():DisplayObjectContainer
		{
			return _container;
		}

		public function init ():void
		{

			instance = this;
			this.focusRect = false;
			_register = new RegisterObject();
			gametimer = new GameTimer(heartBeat, 1000);
			
			if (coordinate === '3d') {
				perspectiveSystem();
			}
			
			defalutBounds();
			makeLayers();	
		}
		
		/**
		 * 建立需要的容器圖層物件，用來處理不同的層級
		 */
		private function makeLayers():void
		{
			bgLayer = new Sprite();
			menuLayer = new Sprite;
			contentLayer = new Sprite;	
			
			_stage.addChild(bgLayer);
			_stage.addChild(contentLayer);
			_stage.addChild(menuLayer);
		}		

		protected function defalutBounds():void 
		{
			boundary =  new Dictionary();
			boundary['top'] = 0;
			boundary['bottom'] = _stage.stageHeight;
			boundary['left'] = 0;
			boundary['right'] = _stage.stageWidth;
			boundary['fore'] = 1000;
			boundary['back'] = -250;
		}

		public function get pp():PerspectiveProjection
		{
			return root.transform.perspectiveProjection;
		}
		
		private function perspectiveSystem():void
		{
			var pp:PerspectiveProjection = root.transform.perspectiveProjection;
			
			trace('system ', pp.projectionCenter.toString());
			//trace(' ' ,);
			
			projection = new Perspective(pp);
			projection.vanishingPoint = new Point(stage.stageWidth >> 1, stage.stageHeight >> 1);
			projection.center = new Vector3D(0, 0, 0);
			root.transform.perspectiveProjection.projectionCenter = projection.vanishingPoint;
			//root.transform.perspectiveProjection.	
			
			trace('system ', pp.projectionCenter.toString());
		}
		
		public static function get perspective():PerspectiveProjection
		{
			return instance.pp;
		}				

		public static function get desktop():Stage
		{
			return instance._stage;
		}
		
		public function get center():*
		{
			return (coordinate === '2d')?new Point(_stage.stageWidth >> 1, _stage.stageHeight >> 1):pp.projectionCenter;
		}
		
		protected function onResizeStage(e:Event):void
		{
			perspectiveSystem();
		}
		
		private function removeTop():void
		{
			_stage.removeChildAt(_stage.numChildren - 1);
			_stage.focus = this;
		}
		
		public function setup ():void
		{

		}

		public function onRemove (e:Event):void
		{
			removeEventListener (Event.REMOVED_FROM_STAGE, onRemove);
			dispose ();
		}

		public function onResize (e:Event):void
		{
			trace ('resize game instance');
		}

		public function dispose ():void
		{
			delete this;
		}

		public function launch ():void
		{
			addEventListener (Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
			
			var mouseMsgs:Array = [MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_MOVE];
			var keyMsgs:Array = [KeyboardEvent.KEY_DOWN,KeyboardEvent.KEY_UP];			
			addElementListeners(_stage, mouseMsgs,onCaptureStageEvents, false, 0, true);
			addElementListeners(_stage, keyMsgs,onCaptureStageEvents, false, 0, true);
		}

		public function addElementListeners(element:*,messages:Array,callback:Function,useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{			
			for (var i:int = 0; i < messages.length; i++)
			{
				element.addEventListener(messages[i], callback, useCapture, priority, useWeakReference);			
			}
		}	
		
		protected function onCaptureStageEvents(e:*):void
		{
			trace('onCaptureStageEvents must overridded!');
		}
		
		public function quit ():void
		{

		}

		public function toggle():void
		{
			playingNow = !playingNow;
		}
		
		protected function heartBeat ():void
		{

		}
		//game looping
		private function enterFrameHandler (e:Event=null):void
		{
			gametimer.tick ();
			gameStep (gametimer.frameMs);
			//renderScene ();
		}

		protected function gameStep (frameMs:Number):void
		{

		}

		protected function renderScene ():void
		{

		}

		public function setBoundary (top:Number,bottom:Number,left:Number,right:Number,fore:Number=1000,back:Number=-250):void
		{
			boundary.top = top;
			boundary.bottom = bottom;
			boundary.left = left;
			boundary.right = right;
			boundary.fore = fore;
			boundary.back = back;
		}

		public function addAChild (obj:Object,symbol:Object,isShow:Boolean=true):Boolean
		{
			_register.add (obj,symbol);

			if (obj is DisplayObject && isShow)
			{
				_stage.addChild (obj as DisplayObject);
			}
			return true;
		}

		public function removeAChild (symbol:Object):void
		{
			var obj:Object = _register.remove(symbol);
			if (obj is DisplayObject && _stage.contains(obj as DisplayObject))
			{
				_stage.removeChild (obj as DisplayObject);
			}
		}

		public function getAChildByName (symbol:Object):Object
		{
			return _register.getObjectByName (symbol);
		}

		public function get children ():Vector.<Object > 
		{
			return _register.objects;
		}

		/**
		 * 檢查目標點是否位於指定的矩形範圍內
		 * @param	rect
		 * @param	point
		 * @return
		 */
		public function containsPoint(rect:Rectangle, point:Point):Boolean
		{
			return !(point.x < rect.x || point.x > rect.x + rect.width || point.y < rect.y || point.y > rect.y + rect.height);
		}
		
		
		public function sortZ(objects:Vector.<DisplayObject>):void
		{
			objects = Vector.<DisplayObject>(VectorUtils.vector2Array(objects).sortOn('z', Array.NUMERIC | Array.DESCENDING));
			for (var i:uint = 0; i < objects.length; i++)
			{
				var obj:DisplayObject = objects[i] as DisplayObject;
				addChild(obj);
			}
		}		
				
		public function sortDepth(objA:DisplayObject, objB:DisplayObject):int
		{
			var locA:Vector3D = objA.transform.matrix3D.position;
			var locB:Vector3D = objB.transform.matrix3D.position;
			locA = sortContainer.transform.matrix3D.deltaTransformVector(locA);
			locB = sortContainer.transform.matrix3D.deltaTransformVector(locB);
			return locB.z - locA.z;
		}	
		
		public function sortContainerZ(container:DisplayObjectContainer):void
		{
			sortContainer = container;
			var objects:Vector.<Object> = new Vector.<Object>;
			for each (var obj:Object in children)
			{
				if (obj is DisplayObject && container.contains(obj as DisplayObject))
				{
					objects.push(obj);
				}
				
				/*
				if (obj is Vehicle3D)
				{
					if (container.contains(Vehicle3D(obj).instance))
					{
						objects.push(Vehicle3D(obj).instance);
					}
				}
				*/
			}
			
			if (objects.length > 1)
			{
				//
				objects.sort(sortDepth);
				for (var i:uint = 0; i < objects.length; i++)
				{
					container.addChild(objects[i] as DisplayObject);
				}
			}
		}	
		
		public function get mousePoint():Point
		{
			return new Point(_stage.mouseX, _stage.mouseY);
		}
		
		public function setMask(target:DisplayObject, area:Rectangle):void
		{
			var maskClip:MovieClip = new MovieClip;
			with (maskClip.graphics)
			{
				beginFill(0x000000, 1);
				drawRect(area.x, area.y, area.width, area.height);
				endFill();
			}
			
			target.mask = maskClip;
		}

		public function makeSprite(layer:Sprite, x:Number = 0, y:Number = 0):Sprite
		{
			var sprite:Sprite = new Sprite;
			placeElement(layer, sprite, x, y);
			return sprite;
		}
		
		public function placeElement(layer:Sprite, obj:DisplayObject, xpos:Number = 0, ypos:Number = 0, zpos:Number = 0):void
		{
			obj.x = xpos;
			obj.y = ypos;
			if (obj.hasOwnProperty('z'))
			{
				obj.z = zpos;
			}
			layer.addChild(obj);
		}		
	}
}