package com.intuitStudio.biMotion.core
{
	/**
	 * Class Vector2d
	 * @author vanier peng , 2013.04.17
	 * 原始程式碼來源 : Keith Peters
	 * purpose: Vector tool for calculate motions in two dimensions world
	 *          提供平面向量的運算工具
	 */
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Vector2d 
	{		
		private var _point:Point2d;
		public function Vector2d(x:Number = 0, y:Number = 0)
		{
			_point = new Point2d(x, y);
		}
				
		public function get x():Number
		{
			return _point.x;
		}
		
		public function set x(value:Number):void
		{
			_point.x = value;
		}
		
		public function get y():Number
		{
			return _point.y;
		}
		
		public function set y(value:Number):void
		{
			_point.y = value;
		}
		
		/**
		 * 複製向量
		 * @return {Vector2d}
		 */
		public function clone():Vector2d
		{
			return new Vector2d(x, y);
		}
		
		public function zero():Vector2d
		{
			x = y = 0;
			return this;
		}
		
		public function get isZero():Boolean
		{
			return (x == 0 && y == 0);
		}
		
		public function get length():Number
		{
			return Math.sqrt(lengthSQ);
		}
		
		public function get lengthSQ():Number
		{
			return (x * x + y * y);
		}
		
		/**
		 * 改變向量長度，但其角度不受影響
		 * @param {value} 數值
		 */
		public function set length(value:Number):void
		{
			var a:Number = angle;			
			x = Math.cos(a) * value;
			y = Math.sin(a) * value;
		}
		
		/**
		 * 利用反餘弦公式求取向量角度
		 */
		public function get angle():Number
		{
			return Math.atan2(y, x);
		}
		
		/**
		 * 改變向量角度，但其長度不受影響
		 * @param {radian} 徑度
		 */
		public function set angle(radian:Number):void
		{
			var magnitude:Number = length;
			x = Math.cos(radian) * magnitude;
			y = Math.sin(radian) * magnitude;
		}
		
		/**
		 * 計算單位向量
		 * @return {Vector2d}
		 */
		public function normalize():Vector2d
		{
			if (length == 0)
			{
				x = 1;
			}
			else
			{
				var magnitude:Number = length;
				x /= magnitude;
				y /= magnitude;
			}
			return this;
		}
		
		public function isNormalized():Boolean
		{
			return (length == 1.0);
		}
		
		/**
		 * 截取指定長度大小的角量
		 * @param	{max} , 新的長度
		 * @return  {Vector2d}
		 */
		public function truncate(max:Number):Vector2d
		{
			length = Math.min(max, length);
			return this;
		}
		
		/**
		 * 向量反轉
		 * @return {Vector2d}
		 */
		public function reverse():Vector2d
		{
			x *= -1;
			y *= -1;
			return this;
		}
		
		/**
		 * 向量內積
		 * @param	{v2} , 作用的另一個向量
		 * @return  {Number}
		 */
		public function dotProd(v2:Vector2d):Number
		{
			return x * v2.x + y * v2.y;
		}
		
		/**
		 * 向量外積
		 * @param	{v2} ,作用的另一個向量
		 * @return  {Number}
		 */
		public function crossProd(v2:Vector2d):Number
		{
			return x * v2.y - y * v2.x;
		}
		
		/**
		 * 利用法向量與目標向量的內積值，判斷本向量是否位於目標向量的右手邊
		 * @param	{v2 } 目標向量
		 * @return  {int} -1表示左側,1表示右側
		 */
		public function sign(v2:Vector2d):int
		{
			return perp.dotProd(v2) < 0 ? -1 : 1;
		}
		
		/**
		 * 求取原向量的法向量，兩者的內積值為零
		 * 法向量經常用來求得點到平面(線)之間的距離
		 */
		public function get perp():Vector2d
		{
			return new Vector2d(-y, x);
		}
		
		/**
		 * 求取兩個向量之間的距離
		 * @param	v2
		 * @return
		 */
		public function distance(v2:Vector2d):Number
		{
			return Math.sqrt(distanceSQ(v2));
		}
		
		public function distanceSQ(v2:Vector2d):Number
		{
			var dx:Number = v2.x - x;
			var dy:Number = v2.y - y;
			return dx * dx + dy * dy;
		}
		
		/**
		 * 計算向量相加
		 * @param	{v2}
		 * @return  {Vector2d}
		 */
		public function add(v2:Vector2d):Vector2d
		{
			return new Vector2d(x + v2.x, y + v2.y);
		}
		
		/**
		 * 計算向量相減
		 * @param	v2
		 * @return  {Vector2d}
		 */
		public function subtract(v2:Vector2d):Vector2d
		{
			return new Vector2d(x - v2.x, y - v2.y);
		}
		
		/**
		 * 計算向量乘上一個純量
		 * @param	{value}
		 * @return   {Vector2d}
		 */
		public function multiply(value:Number):Vector2d
		{
			return new Vector2d(x * value, y * value);
		}
		
		/**
		 * 計算向量除以一個純量
		 * @param	{value}
		 * @return  {Vector2d}
		 */
		public function divide(value:Number):Vector2d
		{
			return new Vector2d(x / value, y / value);
		}
		
		/**
		 * 檢查兩個向量是否相等
		 * @param	v2
		 * @return
		 */
		public function equals(v2:Vector2d):Boolean
		{
			return (x == v2.x && y == v2.y);
		}
		
		/**
		 * 類別函式，計算兩個向量之角的夾角
		 * @param	{v1,v2} 兩個獨立的向量
		 * @return  {Number} 徑度
		 */
		public static function angleBetween(v1:Vector2d, v2:Vector2d):Number
		{
			if (!v1.isNormalized())
			{
				v1 = v1.clone().normalize();
			}
			if (!v2.isNormalized())
			{
				v2 = v2.clone().normalize();
			}
			return Math.acos(v1.dotProd(v2));
		}
		
		/**
		 * 將平面的點轉換成向量物件
		 * @param	{point}
		 * @return
		 */
		public static function toVector(pt:Point):Vector2d
		{
			return new Vector2d(pt.x, pt.y);
		}
		
		/**
		 * 顯示向量內容
		 * @return {String}
		 */
		public function toString():String
		{
			return "[ Vector2d : x: " + x + " y: " + y + " ]";
		}
		
		public function rendering(context:DisplayObject):void
		{
			draw(context);
		}
		
		/**
		 * 繪製向量的示意圖
		 * @param	context
		 */
		private function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
               var gs:Graphics = (context is Sprite)?Sprite(context).graphics:
				                 (context is Shape)?Shape(context).graphics:null;
				 
				with (gs)
				{
					clear();
					lineStyle(0, 0xFF0000);
					moveTo(0, 0);
					lineTo(x, y);
				}
			}
		}
	
	}
}