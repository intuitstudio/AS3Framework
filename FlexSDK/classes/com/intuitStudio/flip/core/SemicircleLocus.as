package com.intuitStudio.flip.core
{
	
	/**
	 * SemicircleLocus class
	 * @author vanier peng,2013.4.23
	 * 半圓運動軌跡物件，提供翻頁運動的參照錨點
	 * 本物件的主要目的是計算半圓運動的相對運動軌跡(其中Y軸值會乘上比例值)，應用時不需要繪製出實際的圖形(僅參考用)
	 */
	
	import com.intuitStudio.biMotion.core.BaseParticle;
	import com.intuitStudio.biMotion.core.Vector2d;
	import com.intuitStudio.biMotion.core.Point2d;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.MathTools;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class SemicircleLocus extends BaseParticle
	{
		private var _range:Number = 0;
		private var _scaleH:Number = 1;
		private var _handleX:Number = 0;
		
		public function SemicircleLocus(rd:Number, scaleH:Number = .5)
		{
			super();
			range = rd;
			scaleY = scaleH;
			handleX = range;		    
		}
		
		/**
		 * 針對y軸的縮放值的存取
		 * y軸的縮放比例會影響翻頁時的頁面的曲折程度：
		 * 當比例接近(或大於)1時，頁面曲折效果減少或者没有，表現出較硬紙質效果，
		 * 反之則頁面曲折大表現出較軟紙效果
		 */
		public function get handleX():Number
		{
			return _handleX;
		}
		
		public function set handleX(value:Number):void
		{
			_handleX = MathTools.clamp(value, -range, range);
			x = handleX;
			//先以餘弦公式取得角度值(角度為負值)，然後再計算出y軸的長度(y方向朝上取負值)
			y = -Math.sin(Math.acos(( -handleX) / range)) * scaleY * range;
		}
		
		public function get range():Number
		{
			return _range;
		}
		
		public function set range(value:Number):void
		{
			_range = value;
		}
		
		public function get scaleY():Number
		{
			return _scaleH;
		}
		
		public function set scaleY(value:Number):void
		{
			_scaleH = value;
		}
		
		public function get locusPath():Vector2d
		{
			return new Vector2d(x, y);
		}
		
		override protected function draw(context:DisplayObject):void
		{
			if (context.hasOwnProperty('graphics'))
			{
				var gs:Graphics;
				if (context is Shape)
				{
					gs = Shape(context).graphics;
				}
				
				if (gs)
				{
					with (gs)
					{
						clear();
						lineStyle(0);
						beginFill(0xFFFF00);
						drawCircle(-10 >> 1, -10 >> 1, 10);
						endFill();
					}
				}
			}
		}
	
	} //end of class

}