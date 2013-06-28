package com.intuitStudio.flash3D.core 
{
   /**
   * Class Polygon
   * @author vanier peng , 2003.4.21
   * 定義多邊形的抽物件類別，由最基本的三角形所組成 
   * 	@params: 無
   *  實做內容交由函式create2d() / create3d()負責； 
   */
   
    import com.intuitStudio.triMotion.core.*;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class Polygon extends Triangle
	{
		private var _faces:Vector.<Triangle>;
		private var _numbFaces:Number = 3;
		private var _center:Point3d;
		private var _size:Number = 20;
		
		public function Polygon() 
		{
			_faces = new Vector.<Triangle>();
		}
		
		public function get faces():Vector.<Triangle>
		{
			return _faces;
		}
		
		public function get center():Point3d
		{
			return _center;
		}
		
		public function set center(point:Point3d):void
		{
			_center = point;
		}
 
		
		public function get size():Number
		{
			return _size;
		}
		
		public function set size(value:Number):void
		{
			_size = value;
		}
		
		/**
		 * 建立多邊形的標準界面
		 * @param	{String} ,geo 2d或3d圖形
		 * @param {Point3d} , 中心點,預設值為(0,0,0)
		 * @param	{Array} ,...rest 建立多邊形所需要的陣列資料
		 *                   rest的資料格式及順序為{中心點}[頂點平面座標或者3d點],{索引值},{顏色},{透明度}
		 */
		public function makePolygon(geo:String,point:Point3d,...rest):void
		{
			center  = point || new Point3d();
	   		
			var strategy:Function=null,destVertices:Array,destIndices:Array, tint:uint, blend:Number;
     		
			strategy = (geo==='2d')?create2d:(geo==='3d')?create3d:null;
            destVertices = rest[0];
			destIndices = rest[1];
			tint = rest[2] || 0xFFFF00;
			blend = rest[3] || 1.0;
			
			if (strategy!==null)
			{
			   strategy(destVertices, destIndices, tint, blend);
			}
		}
		
		public function create2d(destVertices:Array,destIndices:Array,tint:uint=0xFFFF00,blend:Number=1.0):void
		{
			if (Triangle.checkIndices(destIndices) === false) { return; }
			
			addPoints(destVertices);
			addIndices(destIndices);
			build();
			color = tint;
			alpha = blend;
 	        //build Triangle
			makeTriangles(tint,blend);
		}

        /**
         * 以3d點建多邊形物件內容
         * @param {Array} ,	destPoints
         * @param {Array} , destIndices
         * @param {uint} , tint
         * @param {Number} ,blend
		 * 
		 * 多邊形物件的頂點透視屬性首先參考center ,其次可以由外界的呼叫者做設定(GameMain),否則將使用系統預設值
         */		
		public function create3d(destPoints:Array,destIndices:Array,tint:uint=0xFFFF00,blend:Number=1.0):void
		{
			if(Triangle.checkIndices(destIndices)===false){return;}
			addVertices(destPoints);
			addIndices(destIndices);
			build();
			color = tint;
			alpha = blend;
 	        //build Triangle			
		    makeTriangles(tint,blend);
		}
		
		protected function makeTriangles(tint:uint,blend:Number):void
		{
 		    var collects:Array, idx:int, shape:Triangle;			
		    for (var i:int = 0; i < indices.length; i += 3) 
			{	
				collects = [];
				collects.push(points[indices[i]]);
				collects.push(points[indices[i+1]]);
				collects.push(points[indices[i+2]]);				
				shape = Triangle.make3d(collects, [0, 1, 2], tint, blend);	
				
			 	if(!checkExist(shape)){
			       faces.push(shape); 
			 	}
		    };		
	  
		}
		
		private function checkExist(shape:Triangle):Boolean
		{
			var found:Boolean = false;
            faces.forEach(function(face:Triangle, index:int, vector:Vector.<Triangle>):void {
				if (Triangle.isEquals(face, shape)) {
					found = true;
					return;
				}					
			});
			return found;
		}
		
		public function setLight(light:Ray3):void
		{
			faces.forEach(function(face:Triangle, index:int, vector:Vector.<Triangle>):void { face.light = light; } );
		}
		
		override protected function draw(context:DisplayObject):void
		{   		
			if (context.hasOwnProperty('graphics'))
			{
				var gs:Graphics;				
				if (context is Sprite)
				{
					gs = Sprite(context).graphics;
				}
				if (context is Shape)
				{
					gs = Shape(context).graphics;
				}	
			    gs.clear();
				
				faces.sort(Triangle.sortDepth);
				
				faces.forEach(function(face:Triangle, index:int, vector:Vector.<Triangle>):void {
		           if (Triangle.backculling) {
				     if(face.isBackface){return;}
			       }
					
				   var tint:uint = face.getAdjustedColor();
					   
				   with (gs)
				   {
					  lineStyle(0.1,tint,face.alpha);					
					  beginFill(tint, face.alpha);
					  drawTriangles(face.vertices,face.indices);
					  endFill();	
				   }
				});
			}
		}
		
	}

}