package com.intuitStudio.flash3D.core
{
  /**
  * Class Triangle
  * @author vanier peng , 2003.4.20
  * 三角形物件定義 : 雖然三角形的繪製方法和基本頂點資料主要以平面為基礎，但是這裏同時也引入了基礎的3D空間概念的應用
  * @params: {Vector.<Number>,Vector.<int>[,color,alpha]} vertices頂點的x,y座標陣列 ,indices為串連的頂點索引陣列 , 填色color(選用),alpha透明度(選用)
  * 基本上三角形的構成及繪製屬於2D平面的應用，但是若結合3D空間概念亦可表現出空間的立體感
  */
  
	import flash.display.Graphics;	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Vector3D;
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.MathTools;
	import com.intuitStudio.triMotion.core.*;

	public class Triangle
	{
		public static var backculling:Boolean = true;
		private var _vertices:Vector.<Number> = new Vector.<Number>() ;//pairs of (x,y)
		private var _indices:Vector.<int> = new Vector.<int>();
		private var _points:Vector.<Point3d> = new Vector.<Point3d>();//3d points ,(x,y,z)
		private var _color:uint = 0x000000;
		private var _alpha:Number = 1.0;
		private var _light:Ray3 = null;
		
		public function Triangle (tint:uint=0xFFFF00,blend:Number=1.0)
		{
 			_vertices = new Vector.<Number>();
			_indices = new Vector.<int>();
			_points = new Vector.<Point3d>();			
			
			color = tint;
			alpha = blend;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}

		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}

		public function get light():Ray3
		{
			return _light;
		}
		
		public function set light(value:Ray3):void
		{
			_light = value;
		}
		
		public function get vertices():Vector.<Number>
		{
			return _vertices;
		}
		
		public function get indices():Vector.<int>
		{
			return _indices;
		}
		
		public function get points():Vector.<Point3d>
		{
			return _points;
		}
		
		public function build():void
		{	
			//2D
            if (points.length === 0) {
				 var pointA:Point3d = new Point3d(vertices[0],vertices[1],0);
				 var pointB:Point3d = new Point3d(vertices[2],vertices[3],0);
				 var pointC:Point3d = new Point3d(vertices[4],vertices[5],0);
				 addVertices([pointA,pointB,pointC]);				 
			}
			//3D
			if (vertices.length === 0) {				
				var collects:Array = pointToVertices(VectorUtils.vector2Array(points));
				addPoints(collects);
			}
		}
	
		/**
		 * 加入頂點座標(平面的點座標 x,y 數值)
		 * @param	{Array} , 每次加入座標軸數值陣列，預設每次加入3組數據，即3個頂點的x,y軸座標，共6個數值
		 */
        public function addPoints(collects:Array):void
		{	
		   _vertices = Vector.<Number>(VectorUtils.vector2Array(_vertices).concat(collects));
		}	
		
		
		/**
		 * 加入頂點索引陣列
		 * @param	{Array} , 每次加入頂點索引值陣列，每3個數值代表一個三角形
		 */
        public function addIndices(indices:Array):void
		{
		   _indices = Vector.<int>(VectorUtils.vector2Array(_indices).concat(indices));
		}
		
	    /**
		* 檢查是否為三角形的背面；
		* 這裏使用螢幕的平面向量來簡化計算，
		* 其原理是利用向量外積求得三角平面的法向量，假設眼睛位於Z軸的正方向往負方向看過去，
		* 則若平面法向量的Z分量為正，表示平面朝向眼睛，為可視平面，若Z分量為負，表示平面朝另一面，平面不可見。
		*/
		public function get isBackface():Boolean 
		{			
		   var pointA:Point3d = points[0];
		   var pointB:Point3d = points[1];
		   var pointC:Point3d = points[2];
		   var vCA:Vector2d = new Vector2d(pointC.screenX - pointA.screenX, pointC.screenY - pointA.screenY);
		   var vBC:Vector2d = new Vector2d(pointB.screenX - pointC.screenX, pointB.screenY - pointC.screenY);
		   return (vCA.x*vBC.y > vCA.y*vBC.x);
	    } 	
		
		//------ these methods are ussed to 3D application ---------------
		/**
		 * 加入3D空間的頂點座標數據
		 * @param	{Array} , points表示3個空間的頂點
		 */
		public function addVertices(collects:Array):void
		{
			for each(var point:Point3d in collects) 
			{
				if (points.indexOf(point) === -1)
				{
					points.push(point);
				}
			}			
		}
		
		/**
		 * 將3D空間的點座標轉換成螢幕2D平面的座標數據
		 * @param	{Array} 3D頂點
		 * @return  {Array} 2D頂點 
		 */
		public function pointToVertices(collects:Array):Array
		{
			var result:Array = [];
			for (var i:int = 0; i < collects.length; i++) {
				var point:Point3d = collects[i];
				result.push(point.screenX);
				result.push(point.screenY);
			}
			
			return result;
		}
	
		public function get depth():Number
		{
	    	return Math.min(points[0].z,points[1].z,points[2].z);	
		}
				
	    public function getAdjustedColor():uint{
		    if(light===null) return color;
		
		    var rgb:Array = ColorUtils.toRGB(color);
		    var lightFactor:Number = getLightFactor();
 
			var red:Number = rgb[0] * lightFactor;
			var green:Number = rgb[1] * lightFactor;
			var blue:Number = rgb[2] * lightFactor;
		    return ColorUtils.rgb(red,green,blue); 		
	    }
		
		private function getLightFactor():Number
		{
			var vAB:Vector3D = new Vector3D(points[0].x-points[1].x,points[0].y-points[1].y,points[0].z-points[1].z); 
			var vBC:Vector3D = new Vector3D(points[1].x-points[2].x,points[1].y-points[2].y,points[1].z-points[2].z); 

			var norm:Vector3D = vAB.crossProduct(vBC);
			norm.normalize();
			var normMag:Number = norm.length;
			var vlight:Vector3D = light.origin;
			vlight.normalize();
			var lightMag:Number = vlight.length;
			var dotProd:Number = norm.dotProduct(vlight);		
			//return ( Math.acos( dotProd / (normMag * lightMag)) / MathTools.PI) * light.brightness ;
			return ( Math.acos(dotProd)/MathTools.PI)*light.brightness ;
		}
		
		public static function sortDepth(a:Triangle, b:Triangle):Number
		{
			return (b.depth - a.depth);
		}
		
		//-----------------------------------------------------
		
		public function rendering(context:DisplayObject=null):void
		{
			draw(context);
		}
		
		protected function draw (context:DisplayObject):void
		{
		    if (Triangle.backculling) {
				if(isBackface){return;}
			}
		   		
			if (context.hasOwnProperty('graphics'))
			{
				var gs:Graphics;	
				var tint:uint = getAdjustedColor();
				if (context is Sprite)
				{
					gs = Sprite(context).graphics;
				}
				if (context is Shape)
				{
					gs = Shape(context).graphics;
				}				 
				with (gs)
				{
					clear();					
					lineStyle(0.1,tint,alpha);					
					beginFill(tint, alpha);
					drawTriangles(vertices,indices);
					endFill();
				}
			}
		}
		
  	    /**
	    * 查驗索引值數目是否為3的倍數
	    */
		public static function checkIndices(collects:*):Boolean{
	        var res:Boolean = (collects.length%3===0);
	        if(!res){
		        trace('Warning : 發現索引值數目不符，請重新檢查確認！');
	        }
	        return res;
	    }		
	
		public static function make2d(theVertices:Array, theIndices:Array, tint:uint = 0xFFFF00, blend:Number = 1.0):Triangle
		{
			var shape:Triangle = new Triangle(tint, blend);
			shape.addPoints(theVertices);
			shape.addIndices(theIndices);
			shape.build();
			return shape;
		}
		
		public static function make3d(thePoints:Array, theIndices:Array, tint:uint = 0xFFFF00, blend:Number = 1.0):Triangle
		{
			var shape:Triangle = new Triangle(tint, blend);
			shape.addVertices(thePoints);
			shape.addIndices(theIndices);
			shape.build();
			return shape;
		}		
		
		public static function isEquals(shapeA:Triangle, shapeB:Triangle):Boolean 
		{
			return ( shapeA.points[0].equals(shapeB.points[0]) &&
			         shapeA.points[1].equals(shapeB.points[1]) &&
			         shapeA.points[2].equals(shapeB.points[2]));
		}
		
	}//end of class
}