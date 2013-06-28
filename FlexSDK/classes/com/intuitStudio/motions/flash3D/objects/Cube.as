package com.intuitStudio.motions.flash3D.objects
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	import com.intuitStudio.motions.flash3D.core.Point3D;
	import com.intuitStudio.motions.flash3D.core.Vehicle3D;
	import com.intuitStudio.motions.flash3D.core.Shape3D;
	import com.intuitStudio.framework.abstracts.ShaderColor;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.Vector3DUtils;

	public class Cube extends Vehicle3D
	{
		public static const FACE_TOP:int = 0;
		public static const FACE_BOTTOM:int = 1;
		public static const FACE_LEFT:int = 2;
		public static const FACE_RIGHT:int = 3;
		public static const FACE_FORE:int = 4;
		public static const FACE_BACK:int = 5;

		protected var _size:Number;
		protected var _color:ShaderColor;
		protected var _colors:Dictionary;
		protected var _blend:Number = 1.0;
		protected var _light:Vector3D;
		protected var _lightAngle:Number;
		protected var _shadows:Dictionary;

		public function Cube (size:Number,color:ShaderColor,openness:Number=1.0,light:Vector3D=null)
		{
			_size = size;
			if (color == null)
			{
				color = new ShaderColor(0xcccccc);
			}
			_color = color;
			_blend = openness;
			if (light == null)
			{
				light = new Vector3D(0,0,0);
			}
			_light = light;
			_lightAngle = Math.PI * .25;
			//
			super ();
		}

		override protected function init ():void
		{
			initPaints (_color);
			super.init ();
			sortZ ();
		}
		
		override public function get displayObject():DisplayObject
		{
			return instance;
		}

		override public function getDisplayObjectByName(symbol:Object):DisplayObject
		{
			return getChildByName(symbol) as DisplayObject;
		}

		protected function initPaints (coloring:ShaderColor):void
		{
			//trace ('init pain color');
			_colors = new Dictionary();
			setFacePaint (Cube.FACE_TOP, coloring);
			setFacePaint (Cube.FACE_BOTTOM, coloring);
			setFacePaint (Cube.FACE_LEFT, coloring);
			setFacePaint (Cube.FACE_RIGHT, coloring);
			setFacePaint (Cube.FACE_FORE, coloring);
			setFacePaint (Cube.FACE_BACK, coloring);
		}

		protected function setFacePaint (face:int,coloring:ShaderColor):int
		{
			_colors[face] = coloring;
			return 0;
		}

		protected function makeShadows (angle:Number):int
		{
			//trace('init shadows ');
			_shadows = new Dictionary();
			makeFaceShadow (Cube.FACE_TOP,angle);
			makeFaceShadow (Cube.FACE_BOTTOM,angle);
			makeFaceShadow (Cube.FACE_LEFT,angle);
			makeFaceShadow (Cube.FACE_RIGHT,angle);
			makeFaceShadow (Cube.FACE_FORE,angle);
			makeFaceShadow (Cube.FACE_BACK,angle);
			return 0;
		}

		protected function makeFaceShadow (face:int,angle:Number):Number
		{
			var normal:Vector3D = getFaceNormal(face);
			var shape:Vehicle3D = getChildByName('wall_' + face) as Vehicle3D;
			normal = Vector3DUtils.localToGlobal(instance,shape.instance);
			var minlight:Number = .8;
			var scalar:Number = Math.max(minlight,ColorUtils.get3DLightByAngle(lightAngle,normal));
			_shadows[face] = scalar;
			//shaderShadow (face,_colors['wall_'+face].color,scalar);
			return scalar;
		}

		private function getFaceNormal (face:int):Vector3D
		{
			var normal:Vector3D;
			switch (face)
			{
				case Cube.FACE_TOP :
					normal = new Vector3D(0,-1,0);
					break;
				case Cube.FACE_BOTTOM :
					normal = new Vector3D(0,1,0);
					break;
				case Cube.FACE_LEFT :
					normal = new Vector3D(-1,0,0);
					break;
				case Cube.FACE_RIGHT :
					normal = new Vector3D(1,0,0);
					break;
				case Cube.FACE_FORE :
					normal = new Vector3D(0,0,1);
					break;
				case Cube.FACE_BACK :
					normal = new Vector3D(0,0,-1);
					break;
			}
			return normal;
		}

		public function set size (value:Number):void
		{
			_size = value;
			_updateView++;
		}

		public function get size ():Number
		{
			return _size;
		}

		public function set color (value:int):void
		{
			_color.color = value;
			_updateView++;
		}

		public function get color ():int
		{
			return _color.color;
		}

		public function set lightAngle (value:Number):void
		{
			_lightAngle = value;
			_updateView++;
		}

		public function get lightAngle ():Number
		{
			return _lightAngle;
		}

		override public function update (elapsed:Number = 1.0):void
		{
			makeShadows (lightAngle);
			sortZ ();
			_updateView++;
		}

		override public function render ():void
		{
			if (_updateView > 0)
			{
				for each (var obj:Object in _register.objects)
				{
					if (obj is Vehicle3D)
					{
						Vehicle3D(obj).render ();
					}
				}
				super.render ();
				_updateView = 0;
			}
		}

		override public function draw ():void
		{
			super.doDraw ();
			doDraw ();
		}

		override protected function doDraw ():void
		{
			makeShapes ();
			paintColors (_color);
		}

		private function makeShapes ():void
		{
			addChild (makeShape(Cube.FACE_TOP),'wall_'+Cube.FACE_TOP);
			addChild (makeShape(Cube.FACE_BOTTOM),'wall_'+Cube.FACE_BOTTOM);
			addChild (makeShape(Cube.FACE_LEFT),'wall_'+Cube.FACE_LEFT);
			addChild (makeShape(Cube.FACE_RIGHT),'wall_'+Cube.FACE_RIGHT);
			addChild (makeShape(Cube.FACE_FORE),'wall_'+Cube.FACE_FORE);
			addChild (makeShape(Cube.FACE_BACK),'wall_'+Cube.FACE_BACK);
		}
		
		private function makeShape (face:int):Shape3D
		{
			var shape:Shape3D = new Shape3D(size,_color,_blend);
			shape.render ();
			addChild (shape.instance);

			var translate:Vector3D = new Vector3D();
			var rotate:Vector3D = new Vector3D();
			var scale:Vector3D = new Vector3D(1,1,1);
			switch (face)
			{
				case Cube.FACE_TOP :
					rotate = new Vector3D(90,0,0);
					translate = new Vector3D(0, -  size * .5,0);
					break;
				case Cube.FACE_BOTTOM :
					translate = new Vector3D(0,size * .5,0);
					rotate = new Vector3D(-90,0,0);
					break;
				case Cube.FACE_LEFT :
					rotate = new Vector3D(0,-90,0);
					translate = new Vector3D( -  size * .5,0,0);
					break;
				case Cube.FACE_RIGHT :
					rotate = new Vector3D(0,90,0);
					translate = new Vector3D(size * .5,0,0);
					break;
				case Cube.FACE_FORE :
					translate = new Vector3D(0,0, -  size * .5);
					break;
				case Cube.FACE_BACK :
					translate = new Vector3D(0,0,size * .5);
					break;
			}

			shape.makeTransform (translate,rotate,scale);
			return shape;
		}

		public function paintColors (coloring:ShaderColor):void
		{
			if (! _color.equalTo(coloring))
			{
				_color = coloring;
				initPaints (coloring);
			}
			makeShadows (lightAngle);
			//
			paintWallColor (Cube.FACE_TOP,coloring);
			paintWallColor (Cube.FACE_BOTTOM,coloring);
			paintWallColor (Cube.FACE_LEFT,coloring);
			paintWallColor (Cube.FACE_RIGHT,coloring);
			paintWallColor (Cube.FACE_FORE,coloring);
			paintWallColor (Cube.FACE_BACK,coloring);
		}

		protected function paintWallColor (face:int,coloring:ShaderColor):void
		{
			shaderColorAndShadow (face,_colors[face].color, _shadows[face]);
		}

		private function shaderColorAndShadow (face:int,col:int,scalar:Number):void
		{
			var shadow:uint = ColorUtils.darker(col,scalar);
			dyeing (face,new ShaderColor(shadow));
		}

		public function dyeing (face:int,color:ShaderColor):void
		{
			var wall:Shape3D = _register.getObjectByName('wall_' + face) as Shape3D;
			wall.dyeing (color);
		}

		public function showWall (face:int,valid:Boolean):void
		{
			var wall:Shape3D = getChildByName('wall_' + face) as Shape3D;
			wall.instance.visible = valid;
		}
		
		public function makeup(face:int,source:BitmapData):void
		{
			var wall:Shape3D = _register.getObjectByName('wall_' + face) as Shape3D;
            wall.makeup(source);
		}
		
	}

}