package com.intuitStudio.common.objects
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;

	import com.intuitStudio.common.objects.WorldMap;
	import com.intuitStudio.utils.ImageUtils;
	
	import aether.textures.ITexture;
	import aether.utils.Adjustments;
	import aether.effects.adjustments.GradientMapEffect;
	import aether.effects.common.OverlayImageEffect;

	
	public class AtmosphereTexture implements ITexture
	{ 
		protected var _colors:Array;
		protected var _ratios:Array;
		protected var _levels:Array;
		protected var _source:BitmapData;
		
		public function AtmosphereTexture(source:BitmapData,
			colors:Array=null,
			ratios:Array=null,
			levels:Array=null)
		{ 
	        _source = source;
			_colors = colors || [0x344F70, 0x9A7D60, 0x9A7D60, 0x64673E, 0x6D794C, 0xFFFFFF];
			_ratios = ratios || [38, 63, 80, 160, 240, 255];
			_levels = levels || [120, 140, 200];
		}
		
		public function draw():BitmapData
		{
			var baseX:Number = 50;
			var baseY:Number = 50;
			var numOctaves:uint = 5;
			var bitmapData:BitmapData = ImageUtils.make24BitImage(_source.width,_source.height);
			bitmapData.draw(_source);		
			
			var atmosphere:BitmapData = ImageUtils.make32BitImage(_source.width,_source.height);
			atmosphere.perlinNoise(baseX, baseY, numOctaves, int(new Date()), true, true, 1, true);
			Adjustments.setLevels(atmosphere, _levels[0], _levels[1], _levels[2]);
 			new GradientMapEffect(_colors, _ratios,null,.1).apply(atmosphere);
			new OverlayImageEffect(atmosphere,null,BlendMode.SCREEN).apply (bitmapData);
			
			return bitmapData;			
			
		}	
	}
	
	
	
}