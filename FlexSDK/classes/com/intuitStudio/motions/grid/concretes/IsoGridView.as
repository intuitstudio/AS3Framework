package com.intuitStudio.motions.grid.concretes
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.events.Event;
    import flash.display.Bitmap;
    import flash.display.IBitmapDrawable;
	
	import com.intuitStudio.motions.grid.core.Grid;
	import com.intuitStudio.motions.grid.core.Node;
	import com.intuitStudio.motions.pathFind.AStar;
	import com.intuitStudio.motions.triDimens.isometric.IsoUtils;
	import com.intuitStudio.motions.triDimens.isometric.concretes.IsoWorld;
	import com.intuitStudio.motions.triDimens.isometric.core.IsoObject;
    import com.intuitStudio.motions.triDimens.isometric.core.DrawnIsoTile;
	import com.intuitStudio.motions.triDimens.core.Velocity3D;
	import com.intuitStudio.utils.Vector3DUtils;
	import com.intuitStudio.motions.biDimens.core.Vector2D;


	public class IsoGridView extends GridView
	{
		private var mapSprite:Sprite;
		private var viewSize:Number ;
		private var canvas:Bitmap;

		public function IsoGridView (data:Grid,size:Number)
		{			
		    viewSize = size;
			super (data);
		}
		
		override protected function init ():void
		{
			cellSize = viewSize;
		    makeCanvas(grid.columns,grid.rows);
			super.init();
		}
		
		public function get pixelCellSize ():Number
		{
			return cellSize * IsoWorld.pixelsScale;
		}
		
		
		private function makeCanvas(w:Number,h:Number):void
		{
			w *= pixelCellSize;
			h *= pixelCellSize;
			trace(w,h);
			var bmpData:BitmapData = new BitmapData(w*2,h*2,true,0);
			canvas = new Bitmap(bmpData);
			addChild(canvas);
			canvas.x = -w;
			canvas.y = -h;
		}
		
		private function copyToCanvas(image:IBitmapDrawable,pos:Point):void
		{
			var size:Number = pixelCellSize;
			var offsetX:Number = grid.columns*size;
			var offsetY:Number = grid.rows*size;
			canvas.bitmapData.draw(image,new Matrix(1,0,0,1,pos.x+offsetX,pos.y+offsetY));
		}
		
		private function clearCanvas():void
		{
			canvas.bitmapData.fillRect(canvas.bitmapData.rect,0);
		}
		
		override protected function draw():void
		{
			clearCanvas();
			super.draw();
		}
		
		override protected function drawNode (node:Node,color:int,shape:String='square'):void
		{
			var size:Number = pixelCellSize;
			var loc:Vector3D = new Vector3D(node.y*size,0,node.x*size);
			var pos:Point = IsoUtils.isoToScreen(loc);
			
			if(shape=='square')
			{
				drawIsoSquare(color,pos);
			}
			
			if(shape=='circle')
			{
				drawIsoCircle(color,pos);
			}		
		}
       
	    private function drawIsoSquare(color:uint,pos:Point):void
		{
			var size:Number = pixelCellSize;
			var tile:IsoObject = IsoUtils.makeTileObject(IsoObject.DRAWNISOTILE,size,color,pos);
			tile.render();
			copyToCanvas(tile,pos);			
		}

		private function drawIsoCircle (color:uint,pos:Point):void
		{
			var size:Number = pixelCellSize;
			var tile:IsoObject = IsoUtils.makeTileObject(IsoObject.DRAWNISOCIRCLE,size,color,pos);
			tile.render();
			copyToCanvas(tile,pos);	
		}
		
		override protected function onGridClick (e:MouseEvent):void
		{
			var loc:Vector2D = new Vector2D(mouseX,mouseY).multiply(1/IsoWorld.pixelsScale);
			var pos:Point = new Point(loc.x,loc.y);
			_hitPoint  = IsoUtils.snapScreenToGrid(pos,cellSize);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function swapWalkable(loc:Point=null):Boolean
		{
			if(loc)
			{
			   grid.setWalkable (loc.x,loc.y,!grid.getNode(loc.x,loc.y).walkable);
			}
			
			return search ();
		}
		
		//assign cells' walkable 		
		public function map(world:IsoWorld):void
		{
			var size:Number = pixelCellSize;
			
			for(var i:uint=0;i<world.objects.length;i++)
			{
				var obj:IsoObject = world.objects[i] as IsoObject;
				var loc:Point = IsoUtils.isoToIndex(obj.location,world.size);
				grid.setWalkable (loc.x,loc.y,obj.canWalk);				
			}
		}
		
	}
}