package com.intuitStudio.flash3D.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import com.intuitStudio.utils.VectorUtils;

	public class DepthesManager
	{
		public static function sort (container:DisplayObjectContainer,objects:Vector.<DisplayObject>):Vector.<DisplayObject > 
		{
			return setObjects(calculateDepthes (container,objects));
		}

		private static function calculateDepthes (container:DisplayObjectContainer,objects:Vector.<DisplayObject>):Vector.<Object > 
		{
			var displayObjects:Vector.<Object> = new Vector.<Object>();
			var _matrix:Matrix3D;
			for each (var object:DisplayObject in objects)
			{
				_matrix = object.transform.getRelativeMatrix3D(container);
				displayObjects.push ({instance:object,z:_matrix.position.z});
			}

			displayObjects = Vector.<Object > (VectorUtils.vector2Array(displayObjects).sortOn("z",Array.NUMERIC | Array.DESCENDING));
			return displayObjects;
		}

		private static function setObjects (objects:Vector.<Object>):Vector.<DisplayObject > 
		{
			var displayObjects:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for each (var object:Object in objects)
			{
				displayObjects.push (object.instance as DisplayObject);
			}
			return displayObjects;
		}

	}

}