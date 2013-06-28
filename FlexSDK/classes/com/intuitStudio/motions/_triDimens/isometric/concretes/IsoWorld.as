/*
   等角投影世界：以等角視角建構的世界座標系統
    - 以長度單位為計算基值，包括移動速度、座標...，顯示在螢幕時則需依照比例換算，
	  相對的當處理和讀取螢幕上的座標資訊也需要按比例換算之。設計的目的是增加應用
	  彈性，不被局限在像素的大小範圍。
	  
*/


package com.intuitStudio.motions.triDimens.isometric.concretes
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	import com.intuitStudio.motions.triDimens.isometric.IsoUtils;
	import com.intuitStudio.motions.triDimens.isometric.core.IsoObject;
	import com.intuitStudio.motions.triDimens.isometric.core.DrawnIsoTile;
	import com.intuitStudio.motions.triDimens.isometric.concretes.DrawnIsoBox;
	import com.intuitStudio.motions.triDimens.isometric.concretes.GraphicTile;
	import com.intuitStudio.motions.triDimens.core.Velocity3D;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;

	public class IsoWorld extends Sprite
	{
		public static const TILE_SHAPE:int = 0;
		public static const TILE_GRAPHIC:int = 1;
		public static const WORLD_NORMAL:int = 0;
		public static const WORLD_GRAPHIC:int = 1;
		public static var pixelsScale:Number = 20;

		private var _floor:Sprite;
		private var _world:Sprite;
		private var _grounds:Vector.<IsoObject > ;
		private var _objects:Vector.<IsoObject > ;
		private var _gridSize:Vector3D;//(columns,rows,size) , size with foot


		public function IsoWorld (cols:Number,rows:Number,pixelSize:Number=20)
		{
			_gridSize = new Vector3D(cols,rows,pixelSize / pixelsScale);
			init ();
		}

		protected function init ()
		{
			_objects = new Vector.<IsoObject>();
			makeSprites ();
		}

		public function set columns (value:Number):void
		{
			_gridSize.x = value;
		}

		public function get columns ():Number
		{
			return _gridSize.x;
		}

		public function set rows (value:Number):void
		{
			_gridSize.y = value;
		}

		public function get rows ():Number
		{
			return _gridSize.y;
		}

		public function set size (value:Number):void
		{
			_gridSize.z = value;
		}

		public function get size ():Number
		{
			return _gridSize.z;
		}

		public function get pixelSize ():Number
		{
			return _gridSize.z * pixelsScale;
		}

		public function get floor ():Sprite
		{
			return _floor;
		}

		public function get world ():Sprite
		{
			return _world;
		}

		public function set objects (vc:Vector.<IsoObject>):void
		{
			_objects = vc;
		}

		public function get objects ():Vector.<IsoObject > 
		{
			return _objects;
		}

		public function set grounds (vc:Vector.<IsoObject>):void
		{
			_grounds = vc;
		}

		public function get grounds ():Vector.<IsoObject > 
		{
			return _grounds;
		}

		public function set location (point:Point):void
		{
			x = point.x;
			y = point.y;
		}

		public function get location ():Point
		{
			return new Point(x,y);
		}

		private function makeSprites ():void
		{
			_floor = new Sprite();
			addChild (_floor);
			_world = new Sprite();
			addChild (_world);
			_world.x = _floor.x;
			_world.y = _floor.y;
		}

		public function makeFloor (def:Dictionary=null):void
		{
			_grounds = new Vector.<IsoObject>();
			for (var i:uint=0; i<columns; i++)
			{
				for (var j:uint=0; j<rows; j++)
				{
					var tile:IsoObject = new DrawnIsoTile(pixelSize,0xcccccc);
					var loc:Vector3D = new Vector3D(j * size,0,i * size);
					floor.addChild (tile);
					tile.render ();
					_grounds.push (tile);
				}
			}
		}

		public function paintFloor (color:uint):void
		{
			for (var i:uint=0; i<_grounds.length; i++)
			{
				var tile:IsoObject = _grounds[i] as IsoObject;
				tile.transform.colorTransform = ColorUtils.colorTransform(color);
			}
		}

		public function addToWorld (obj:IsoObject):void
		{
			world.addChild (obj);
			objects.push (obj);
			sort ();
		}

		public function addToFloor (obj:IsoObject):void
		{
			floor.addChild (obj);
		}

		public function sort ():void
		{
			objects = Vector.<IsoObject > (VectorUtils.sortOn(objects,"depth",Array.NUMERIC));

			for (var i:uint=0; i<objects.length; i++)
			{
				world.addChild (objects[i]);
			}
		}

		public function render ():void
		{
			sort ();
			for (var i:uint=0; i<objects.length; i++)
			{
				var obj:IsoObject = objects[i] as IsoObject;
				obj.render ();
			}
		}

		//檢查物件是否可移動到新的位置點
		public function canMove (obj:IsoObject,elapsed:Number=1.0):Boolean
		{
			var rectA:Rectangle = detectRect(obj,elapsed);
			for (var i:uint=0; i<objects.length; i++)
			{
				var objB:IsoObject = objects[i] as IsoObject;
				if (isfloorCell(objB))
				{
					continue;
				}

				var rectB:Rectangle = objB.rect;
				if (obj != objB && ! objB.canWalk && rectA.intersects(rectB))
				{
					return canJump(obj,objB,elapsed);
				}
			}
			return true;
		}

		private function detectRect (obj:IsoObject,elapsed:Number=1.0):Rectangle
		{
			var pos:Vector2D = new Vector2D(obj.vx,obj.vz).multiply(elapsed);
			var rect:Rectangle = obj.rect;
			rect.offset (pos.x,pos.y);
			return rect;
		}

		public function isfloorCell (obj:IsoObject):Boolean
		{
			return obj.floor == 0;
		}

		//檢查是否可以跳躍，尚未完成
		public function canJump (obj:IsoObject,jumped:IsoObject,elapsed:Number=1.0):Boolean
		{
			return false;
			if (Math.abs(obj.y) < jumped.height)
			{
				var dx:Number = jumped.x - obj.x;
				var dz:Number = jumped.z - obj.z;
				var different:Vector3D = new Vector3D(dx,0,dz);
				if (different.dotProduct(obj.velocity) > 0)
				{
					obj.location = jumped.location.add(new Vector3D(size,0,size));
				}
				else
				{
					obj.location = jumped.location.subtract(new Vector3D(size,0,size));
				}
			}
		}

		//檢查座標點上有無可阻礙物件
		public function checkObstacle (loc:Vector3D):IsoObject
		{
			return isEmptyIndex(IsoUtils.isoToIndex(loc,size));
		}

		public function checkObstacleByIndex (index:Point):IsoObject
		{
			return isEmptyIndex(index);
		}

		private function isEmptyIndex (index:Point):IsoObject
		{
			var objList:Vector.<IsoObject> = new Vector.<IsoObject>();
			for (var i:uint=0; i<objects.length; i++)
			{
				var obj:IsoObject = objects[i] as IsoObject;
				if (IsoUtils.isoToIndex(obj.location,size).equals(index))
				{
					objList.push (obj);
				}
			}

			if (objList.length > 0)
			{
                for(i=0;i<objList.length;i++)
				{
					obj = objList[i];
					if(!isfloorCell(obj))
					{
						break;
					}
				}
                return obj;
			}
			return null;
		}

		public function freeIndexCell (index:Point):void
		{
			var obj:IsoObject = isEmptyIndex(index);
			if (obj)
			{
				removeFromWorld (obj);
			}
		}

		//檢查座標點上有無可以移動的物件
		public function checkWalkable (loc:Vector3D):IsoObject
		{
			var index:Point = IsoUtils.isoToIndex(loc,size);
			return checkWalkableByIndex(index);
		}

		public function checkWalkableByIndex (index:Point):IsoObject
		{
			var obj:IsoObject = isEmptyIndex(index);
			if (obj)
			{
				obj.location = IsoUtils.snapSpaceToGrid(obj.location,size);
				return obj;
			}
			return null;
		}

		private function checkIntersect (obj:IsoObject,rect:Rectangle):Boolean
		{
			return obj.rect.intersects(rect);
		}

		public function removeFromWorld (obj:IsoObject):void
		{
			var index:Number = objects.indexOf(obj);
			objects.splice (index,1);
			world.removeChild (obj);
		}

		public function getEmptyCell ():Vector3D
		{
			var intersect:Boolean = true;
			while (intersect)
			{
				var index:Point = new Point(Math.floor(Math.random() * columns),Math.floor(Math.random() * rows));
				var count:int = 0;
				if (isEmptyIndex(index))
				{
					count++;
				}
				//
				if (count == 0)
				{
					intersect = false;
					return IsoUtils.indexToIso(index,size);
				}
				else
				{
					//if full then remove index object
					if (count >= columns * rows)
					{
						intersect = false;
						freeIndexCell (index);
						return IsoUtils.indexToIso(index,size);
					}
				}

			}
			return null;
		}

	}

}