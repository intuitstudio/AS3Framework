package com.intuitStudio.utils 
{
	import flash.geom.Point;
	/**
	 * MathTools Class
	 * @author vanier peng , 2013.4.17
	 * 定義常用的數學計算公式以及常數
	 */
	public class MathTools 
	{
		public static const PI:Number = 3.1416;
		public static const HALFPI:Number = 1.571;
		public static const TWOPI:Number = 6.2832;
		public static const TORADIAS:Number = 0.01745;
		public static const TODEGREE:Number = 56.296;
		
		
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			return Math.max(min,Math.min(max,value));
		}
		
		public static function sortZ(a:Object, b:Object):Boolean {
			//return (b.z - a.z);
			return false;
		}
		
		/**
		 * 不同的計算隨機數值的方法
		 * @param	{Number} ,value 做為計算用種子
		 * @param	{String} ,mode代表不同的計算方式
		 * @return  {Number}
		 */
		public static function distribution(value:Number, mode:String='square'):Number
		{
			var result:Number = 0;
			if (mode === 'square')
			{
				result = Math.random() * (value<<1) - value;
			}
			if (mode === 'circularX' || mode === 'circularY')
			{
				var radius:Number = Math.sqrt(Math.random()) * value;
				var angle:Number = Math.random() * MathTools.TWOPI;
				var pt:Point = Point.polar(radius,angle);
				result =  (mode === 'circularX')?pt.x:pt.y;
			}
			if (mode === 'bias') {
				var iterations:int = 4;
				var average:Number = 0;
				var i:int = iterations;
				while (i--) {
					average += Math.random() * value;
				}
				result = (average/iterations);				
			}			
			return result;
		}
		/**
		 * 產生隨機座標點位置
		 * @param	{Number} ,boundX = X軸的範圍大小
		 * @param	{Number} ,boundY = Y軸的範圍大小
		 * @param	{Number} ,boundZ = Z軸的範圍大小，若值為0則表示平面的點
		 * @return  {Object} ,回傳物件 {x:Number,y:Number [,z:Number}
		 */
		public static function getRandomPoint(boundX:Number, boundY:Number, boundZ:Number = 0):Object
		{
			var point:Object = (boundZ!=0)?{ x:0, y:0, z:0 }:{x:0,y:0,z:0};
			point.x = Math.round(MathTools.distribution(boundX, 'circularX'));
			point.y = Math.round(MathTools.distribution(boundY, 'circularY'));
			if (boundZ !== 0) {				
				point.z = Math.round(MathTools.distribution(boundZ,'bias'));
			}
			return point;
		}
		
		/**
		 * 計算相對於中心點位置的大小範圍內的隨機點座標位置
		 * @param	{Object} ,margin ={width:Number,height:Number [,depth:Number}
		 * @param	{Object} ,center ={x:Number,y:Number [,z:Number}
		 * @param	{Number} ,radius半徑範圍
		 * @return  {Object} ,回傳物件 {x:Number,y:Number [,z:Number}
		 */
		public static function getAreaRandomPoint(margin:Object, center:Object, radius:Number):Object
		{
			var point:Object = (margin.depth)?{ x:0, y:0, z:0 }:{x:0,y:0};
			var dist:Number = radius;
			while (dist >= radius) {
				point.x = Math.round(MathTools.distribution(margin.width));
				point.y = Math.round(MathTools.distribution(margin.height));
				if (margin.depth) {
					point.z = Math.round(MathTools.distribution(margin.depth));
				    dist = Math.sqrt((point.x - center.x) * (point.x - center.x) + (point.y - center.y) * (point.y - center.y)+ (point.z - center.z) * (point.z - center.z));
				}else{
				    dist = Math.sqrt((point.x - center.x) * (point.x - center.x) + (point.y - center.y) * (point.y - center.y));
				}
			}
            return point;
		}		
		
		
		public static function polar(len:Number, angle:Number, dest:Point = null):Point {
			var target:Point = Point.polar(len, angle);
			if (dest !== null) {
				target = dest.add(target);
			}
			return target;
		}
		
	} //end of Class

}