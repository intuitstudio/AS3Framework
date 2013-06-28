package com.intuitStudio.motions.flash3D.core
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.framework.managers.RegisterObject;
	import com.intuitStudio.motions.flash3D.core.Perspective;

	import flash.errors.IllegalOperationError;

	public class Vehicle3D extends Point3D
	{
		private var _velocity:Vector3D;
		private var _boundary:Dictionary;
		protected var _rotation:Vector3D;
		protected var _instance:Sprite;
		protected var _objects:Vector.<DisplayObject > ;//added to _instance
		protected var _objectsDic:Dictionary;
		protected var _register:RegisterObject;

		public function Vehicle3D ()
		{
			super ();
		}

		override protected function init ():void
		{
			_velocity = new Vector3D();
			_rotation = new Vector3D();
			_register = new RegisterObject();
			super.init ();
			makeInstance ();
			defaultBoundary ();
			draw ();
		}

		private function makeInstance ():void
		{
			_instance = new Sprite();
			_instance.x = 0;
			_instance.y = 0;
			_instance.z = 0;
		}

		private function defaultBoundary ():void
		{
			_boundary =  new Dictionary();
			_boundary['top'] = 0;
			_boundary['bottom'] = 1000;
			_boundary['left'] = 0;
			_boundary['right'] = 1000;
			_boundary['fore'] = 1000;
			_boundary['back'] = -250;
		}

		public function get objects ():Vector.<Object > 
		{
			return _register.objects;
		}

		//
		public function get instance ():Sprite
		{
			return _instance;
		}

		// override by sub class
		public function get displayObject ():DisplayObject
		{
			throw new IllegalOperationError('displayObject must be overridden by sub class!');
			return null;
		}

		public function getDisplayObjectByName (symbol:Object):DisplayObject
		{
			throw new IllegalOperationError('displayObject must be overridden by sub class!');
			return null;
		}

		public function addChild (obj:Object,symbol:Object=null,isAdd:Boolean=true):void
		{
			if (symbol == null)
			{
				symbol = (obj as DisplayObject).name;
			}

			_register.add (obj as Object,symbol);

			if (isAdd)
			{
				if (obj is Vehicle3D)
				{
					_instance.addChild (obj.instance);
				}

				if (obj is DisplayObject)
				{
					_instance.addChild (obj as DisplayObject);
				}

			}
		}

		public function removeChild (obj:Object):void
		{
			_register.remove (obj);

			if (obj is Vehicle3D)
			{
				if (_instance.contains(obj.instance))
				{
					_instance.removeChild (obj.instance);
				}
			}
			else
			{
				if (_instance.contains(obj as DisplayObject))
				{
					_instance.removeChild (obj as DisplayObject);
				}
			}
		}

		public function getChildByName (symbol:Object):Object
		{
			return _register.getObjectByName(symbol) as Object;
		}

		public function set boundary (bounds:Dictionary):void
		{
			_boundary = bounds;
		}

		public function get boundary ():Dictionary
		{
			return _boundary;
		}

		public function set rotation (value:Vector3D):void
		{
			_rotation = value;
		}

		public function get rotation ():Vector3D
		{
			return _rotation;
		}

		public function set velocity (vel:Vector3D):void
		{
			_velocity = vel;
		}

		public function get velocity ():Vector3D
		{
			return _velocity;
		}

		public function update (elapsed:Number=1.0):void
		{

		}

		override public function render ():void
		{
			instance.x = x;
			instance.y = y;
			instance.z = z;
			instance.rotationX = _rotation.x;
			instance.rotationY = _rotation.y;
			instance.rotationZ = _rotation.z;
			_updateView = 0;
		}

		//override by sub class
		public function rotate (rotateAngles:Vector3D):void
		{
			_rotation = rotateAngles;
		}

		public function makeTransform (translate:Vector3D,rotate:Vector3D,scale:Vector3D):void
		{
			var matrix:Matrix3D = instance.transform.matrix3D;
			if (rotate)
			{
				matrix.appendRotation (rotate.x, Vector3D.X_AXIS);
				matrix.appendRotation (rotate.y, Vector3D.Y_AXIS);
				matrix.appendRotation (rotate.z, Vector3D.Z_AXIS);
				_rotation = rotate;
			}
			if (scale)
			{
				matrix.appendScale (scale.x, scale.y, scale.z);
			}
			if (translate)
			{
				matrix.appendTranslation (translate.x, translate.y, translate.z);
				location = translate;
			}
		}

		public function sortZ ():void
		{
			var objects:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for each (var obj:Object in _register.objects)
			{
				if (obj is Vehicle3D)
				{
					objects.push (Vehicle3D(obj).instance);
				}
				if (obj is DisplayObject)
				{
					objects.push (obj as DisplayObject);
				}
			}

			objects.sort (sortDepth);
			for (var i:uint=0; i<objects.length; i++)
			{
				_instance.addChild (objects[i]);
			}
		}

		private function sortDepth (objA:DisplayObject,objB:DisplayObject):int
		{
			var locA:Vector3D = Vector3DUtils.localToGlobal(instance,objA);
			var locB:Vector3D = Vector3DUtils.localToGlobal(instance,objB);
			return locB.z-locA.z;
		}

	}

}