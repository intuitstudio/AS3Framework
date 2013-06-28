package com.intuitStudio.utils
{
	
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	public class FiltersUtils
	{
	
		public static function get grayscaleFilter ():Array
		{
			return saturationFilter(0);
		}

		public static function get invertedFilter ():Array
		{
			var matrix:Array = [
				-1,  0,  0, 0, 255,
				 0, -1,  0, 0, 255,
				 0,  0, -1, 0, 255,
				 0,  0,  0, 1, 0
			];
			return [makeColorFilter(matrix)];
		}

		public static function getTineToneFilter (tint:uint):Array
		{
			var r:uint = tint >> 16 & 0xFF;
			var g:uint = tint >> 8 & 0xFF;
			var b:uint = tint & 0xFF;
			var matrix:Array = [
				r/255, .59, .11, 0, 0,
				g/255, .59, .11, 0, 0,
				b/255, .59, .11, 0, 0,
				    0,   0,   0, 1, 0
			];
			
			return [makeColorFilter(matrix)];
		}
		
		//top-left direction emboss
		public static function getEmbossingFilter(size:Number=5 ):Array
		{
			
			var matrix:Array = (size==3)?[
				-2, -1, 0,
				-1,  0, 1,
				 0,  1, 2	
			   ]:[
				-1, -1, -1, -1, -1,
				-1, -1, -1, -1, -1,
				-1, -1, 24, -1, -1,
				-1, -1, -1, -1, -1,
				-1, -1, -1, -1, -1
		       ];
			var divisor:Number = calculateDivisor(matrix);		
			return [makeConvoluteFilter(size,size,matrix,divisor)];
		}		
		
		public static function get outlitingFilter():Array
		{
			var matrix:Array = [
				 0, -1,  0,
				-1,  4, -1,
				 0, -1,  0								
		    ];
			var divisor:Number = calculateDivisor(matrix);		
			var filters:Array = [];
			filters.push(makeConvoluteFilter(3,3,matrix,divisor));
			filters.push(invertedFilter);
			return filters;
		}
 
        public static function saturationFilter(amount:Number=2.2):Array
		{
			var rgb:Vector.<Number> = Vector.<Number>([.3,.59,.11]);
			var inverse:Number = 1-amount;
			var matrix:Array = [
				inverse*rgb[0]+amount , inverse*rgb[1]	     , inverse*rgb[2]        ,	0 , 0,
				inverse*rgb[0]        , inverse*rgb[1]+amount, inverse*rgb[2]        ,	0 , 0,
				inverse*rgb[0]        , inverse*rgb[1]	     , inverse*rgb[2]+amount ,	0 , 0,
				            0         ,             0	     ,             0         ,	1 , 0
			];
			
			return [makeColorFilter(matrix)];
		}

		private static function makeColorFilter (matrix:Array):ColorMatrixFilter
		{
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			return filter;
		}
		
		private static function makeConvoluteFilter (x:Number,y:Number,matrix:Array,divisor:Number):ConvolutionFilter
		{
			var filter:ConvolutionFilter = new ConvolutionFilter();
			filter.matrixX = x;
			filter.matrixY = y;
			filter.matrix = matrix;
			filter.divisor = divisor;
			filter.bias = 0;
			return filter;
		}
		
		private static function calculateDivisor(matrix:Array):Number
		{
			var divisor:Number = 0;
			for each(var index:Number in matrix)
			{
				divisor += index;
			}
			return divisor;
		}
	}
	
}