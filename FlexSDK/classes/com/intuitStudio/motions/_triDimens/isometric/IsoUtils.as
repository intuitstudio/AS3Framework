/*
   Note: calculate distance and postion of points,vectors on the screen with unit somegthing like cm,feet,and 
         the factor is set by Velocity.pixelsToFoot .
		 
	EX.	 1 pixel = 10 foot ;
	     // on screen , pixel is unit of movement,before calcuating ,we must trans to foot unit.
	     location = point(x/10,y/10);
		 velocity:Point = point(x,y);//unit is foot 
		 location.x += velocity.x;
		 location.y += velocity.y;
		 //when render on screen , reverse foot to pixel
		 obj.x = location.x * 10;
		 obj.y = location.y *10;
*/

package com.intuitStudio.motions.triDimens.isometric
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.display.DisplayObject;

	import com.intuitStudio.motions.triDimens.isometric.core.DrawnIsoTile;
	import com.intuitStudio.motions.triDimens.isometric.core.IsoObject;
	import com.intuitStudio.motions.triDimens.isometric.concretes.IsoWorld;
	import com.intuitStudio.motions.triDimens.isometric.concretes.DrawnIsoBox;
	import com.intuitStudio.motions.triDimens.isometric.concretes.SteeredDrawnIsoBox;
	import com.intuitStudio.motions.triDimens.isometric.concretes.DrawnIsoCircle;
	import com.intuitStudio.motions.triDimens.isometric.concretes.GraphicTile;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;
	import flash.display.IBitmapDrawable;

	public class IsoUtils
	{
		public static const yModifier:Number = Math.cos( -  Math.PI / 6) * Math.SQRT2;
		private static var oriPos:Point = new Point();

		public static function isoToScreen (pt:Vector3D):Point
		{
			var sx:Number = pt.x - pt.z;
			var sy:Number = pt.y*yModifier+(pt.x+pt.z)*.5;
			//var loc:Vector2D = new Vector2D(sx,sy).multiply(IsoWorld.footMultipler);	
			//var loc:Vector2D = new Vector2D(sx,sy);	
			return new Point(sx,sy);			
		}

		public static function screenToIso (pt:Point):Vector3D
		{
			//var loc:Vector2D = new Vector2D(pt.x,pt.y).multiply(1/IsoWorld.footMultipler);
			var loc:Vector2D = new Vector2D(pt.x,pt.y);	
			var px:Number = loc.y + loc.x * .5;
			var py:Number = 0;
			var pz:Number = loc.y - loc.x * .5;
			return new Vector3D(px,py,pz);			
		}

        

		public static function makeTileObject (type:int,size:Number,color:uint,pos:Point=null,floor:Number=0,h:Number=20):IsoObject
		{
			var key:String = IsoObject.TileClassIndex[type];
			var classSymbol:* = IsoObject.TileClassBook[key];
			
			switch (type)
			{
				case IsoObject.DRAWNISOTILE :
					var tile:IsoObject = new classSymbol(size,color) as IsoObject;
					break;
				case IsoObject.DRAWNISOBOX :
					tile = new classSymbol(size,color,pos,h) as IsoObject;
					tile.floor = 1;
					break;
				case IsoObject.STEEREDDRAWNISOBOX :
					tile = new classSymbol(size,color,h) as IsoObject;
					tile.floor = 1;
					break;
				case IsoObject.DRAWNISOCIRCLE :
					tile = new classSymbol(size,color,pos) as IsoObject;
					break;
			}
			
			tile.getVelocity().zero();
			pos = (pos==null)?oriPos:pos;
			tile.location = screenToIso(pos);
			tile.canWalk = (floor==0);
            return tile;			
		}
		
		public static function makeGraphicObject (size:Number,instance:DisplayObject,offsetX:Number,offsetY:Number,pos:Point=null,floor:Number=0):GraphicTile
		{
			var tile:GraphicTile = new GraphicTile(size,instance,offsetX,offsetY);
			pos = (pos==null)?oriPos:pos;
			tile.location = snapScreenToGrid(pos,size);
			tile.floor = floor;
			return tile;
		}

		public static function makeGraphic (size:Number,instance:DisplayObject,offsetX:Number,offsetY:Number,pos:Point=null,floor:Number=0):GraphicTile
		{
			var tile:GraphicTile = new GraphicTile(size,instance,offsetX,offsetY);
			pos = (pos==null)?oriPos:pos;
			tile.location = snapScreenToGrid(pos,size);
			tile.floor = floor;
			return tile;
		}

		private static function makeSteeredBox (size:Number,color:uint,pos:Point=null,h:Number=20):SteeredDrawnIsoBox
		{
			var box:SteeredDrawnIsoBox = new SteeredDrawnIsoBox(size,color,h);
			pos = (pos==null)?oriPos:pos;
			box.location = snapScreenToGrid(pos,size);
			box.floor = 1;
			return box;
		}

		public static function snapScreenToGrid (pos:Point,size:Number):Vector3D
		{
			return snapSpaceToGrid(screenToIso(pos),size);
		}

		public static function snapSpaceToGrid (loc:Vector3D,size:Number):Vector3D
		{
			var index:Point = isoToIndex(loc,size);
			loc = new Vector3D(index.y*size,loc.y,index.x*size);			
			return loc;
		}
		
		public static function isoToIndex(loc:Vector3D,size:Number):Point
		{
			var col:Number = Math.round(loc.z / size) ;
			var row:Number = Math.round(loc.x / size) ;
			return new Point(col,row);
		}
		
		public static function screenToIndex(loc:Point,size:Number):Point
		{
			var pos:Vector2D = new Vector2D(loc.x,loc.y);
			pos = pos.multiply(1/size);
			return new Point(pos.x,pos.y);
		}
		
		public static function indexToIso(index:Point,size:Number):Vector3D
		{
			var x:Number = index.y*size;
			var z:Number = index.x*size;
			return new Vector3D(x,0,z);			
		}
	}
}