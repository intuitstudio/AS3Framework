package com.intuitStudio.utils
{
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.BlendMode;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	import flash.utils.getTimer;
	import flash.utils.Dictionary;
	
	import flash.text.TextField;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.BlurFilter;
	import flash.filters.BevelFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.ColorMatrixFilter;
	
	import com.intuitStudio.utils.TextFieldUtils;
	import com.intuitStudio.utils.FiltersUtils;
	import com.intuitStudio.utils.ColorUtils;
	import com.intuitStudio.utils.VectorUtils;
	import com.intuitStudio.motions.biDimen.core.Vector2D;
	
	import aether.utils.ImageUtil;
	import aether.utils.Adjustments;
	
	public class ImageUtils
	{
		public static const TEXTURE_WRAP:int = 0;
		public static const TEXTURE_GLASS:int = 1;
		
		private static const MAX_SIZE1:Number = 8000;
		private static const MAX_SIZE2:Number = 2000;
		private static const MAX_PIXELS:Number = 16777215;
		
		public static const channels:Vector.<uint> = Vector.<uint>([BitmapDataChannel.RED, BitmapDataChannel.GREEN, BitmapDataChannel.BLUE, BitmapDataChannel.ALPHA]);
		
		public static function clone32BitImage(oriData:BitmapData):BitmapData
		{
			var clone:BitmapData = make32BitImage(oriData.width, oriData.height);
			copyPixels(oriData, clone);
			return clone;
		}
		
		public static function clone24BitImage(oriData:BitmapData):BitmapData
		{
			var clone:BitmapData = make24BitImage(oriData.width, oriData.height);
			copyPixels(oriData, clone);
			return clone;
		}
		
		public static function make32BitImage(w:Number, h:Number):BitmapData
		{
			return doMakeBitmapData(w, h, true, 0);
		}
		
		public static function make24BitImage(w:Number, h:Number):BitmapData
		{
			return doMakeBitmapData(w, h, false, 0);
		}
		
		protected static function doMakeBitmapData(w:Number, h:Number, transparent:Boolean, color:uint):BitmapData
		{
			return new BitmapData(w, h, transparent, color);
		}
		
		public static function makeBitmap(source:BitmapData, destPoint:Point = null, smooth:Boolean = false):Bitmap
		{
			var destination:Bitmap = doMakeBitmap(source, PixelSnapping.AUTO, smooth);
			destPoint = (destPoint == null) ? new Point() : destPoint;
			destination.x = destPoint.x;
			destination.y = destPoint.y;
			return destination;
		}
		
		public static function makeSmoothBitmap(source:BitmapData, destPoint:Point = null):Bitmap
		{
			return makeBitmap(source, destPoint, true);
		}
		
		protected static function doMakeBitmap(data:BitmapData, pixelSnapping:String, smoothing:Boolean):Bitmap
		{
			return new Bitmap(data, pixelSnapping, smoothing);
		}
		
		public static function makeGradientBitmapData(w:Number, h:Number, colors:Array, alphas:Array, ratios:Array, type:String = "linear", rotate:Number = 0, offset:Point = null):BitmapData
		{
			var gradient:BitmapData = make24BitImage(w, h);
			var matrix:Matrix = new Matrix();
			offset = (offset == null) ? new Point() : offset;
			matrix.createGradientBox(gradient.width, gradient.height, rotate, offset.x, offset.y);
			var shape:Shape = new Shape();
			shape.graphics.beginGradientFill(type, colors, alphas, ratios, matrix);
			shape.graphics.drawRect(0, 0, gradient.width, gradient.height);
			shape.graphics.endFill();
			gradient.draw(shape);
			return gradient;
		}
		
		public static function makeNoiseRect(w:Number, h:Number, gray:Boolean = true):BitmapData
		{
			var data:BitmapData = make24BitImage(w, h);
			data.noise(getTimer(), 100, 255, 7, gray);
			return data;
		}
		
		public static function makeBarChartData(sampleH:Number, sampleV:Number, maxV:Number, data:Vector.<Number>, color:uint = 0xFFFFFF):BitmapData
		{
			var chart:BitmapData = make32BitImage(sampleH, sampleH);
			var xpos:Number = 0;
			var ypos:Number = 0;
			
			for (var i:uint = 0; i < data.length; i++)
			{
				xpos = i / data.length * sampleH;
				ypos = (data[i] / maxV) * sampleV;
				chart.fillRect(new Rectangle(xpos, sampleV - ypos, 1, ypos), color);
			}
			return chart;
		}
		
		//-------------------------------------------------------------
		
		public static function makeTextFieldImage(tf:TextField):BitmapData
		{
			var clone:BitmapData = make32BitImage(tf.textWidth, tf.textHeight);
			clone.draw(tf);
			return clone;
		}
		
		// transform textfield to image ,then add some stacked effects to create beveled , glowing text images
		public static function addLayer(source:BitmapData, destination:BitmapData, fillColor:uint, blurAmount:Number, threshold:uint, filters:Vector.<BitmapFilter> = null):void
		{
			var alphas:BitmapData = getChannelData(source, BitmapDataChannel.ALPHA);
			applyFilter(alphas, alphas, new BlurFilter(blurAmount, blurAmount));
			setLevels(alphas, threshold - 20, threshold, threshold + 20);
			applyFilter(alphas, alphas, new BlurFilter(1.5, 1.5));
			//
			var bevel:BitmapData = source.clone();
			bevel.fillRect(bevel.rect, fillColor);
			copyChannel(alphas, bevel, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			for each (var filter:BitmapFilter in filters)
			{
				applyFilter(bevel, bevel, filter);
			}
			destination.draw(bevel);
		}
		
		public static function makeTexturedTextFieldImage(source:BitmapData, text:String, type:int, fontSize:Number = 12, font:String = "_sans"):BitmapData
		{
			var textureData:BitmapData = make32BitImage(source.width, source.height);
			switch (type)
			{
				case TEXTURE_WRAP: 
					makeWrapTexture(source, textureData, text, fontSize, font);
					break;
				case TEXTURE_GLASS: 
					makeGlassTexture(source, textureData, text, fontSize, font);
					break;
			}
			
			return textureData;
		}
		
		private static function makeWrapTexture(source:BitmapData, destination:BitmapData, text:String, fontSize:Number, font:String):void
		{
			var tfData:BitmapData = destination.clone();
			var tf:TextField = TextFieldUtils.makeBevelTextField(text, 0xFFFFFF, 0x000000, fontSize, font);
			var matrix:Matrix = new Matrix();
			matrix.translate((destination.width - tf.width) * .5, (destination.height - tf.height) * .5);
			tfData.draw(tf, matrix);
			
			var displacementFilter:DisplacementMapFilter = new DisplacementMapFilter(tfData, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED, 10, 10);
			
			applyFilter(source, destination, displacementFilter);
			var alphaChannel:uint = BitmapDataChannel.ALPHA;
			copyChannel(tfData, destination, alphaChannel, alphaChannel);
			
			tf = TextFieldUtils.makeBevelTextField(text, 0xFFFFFF, 0x000000, fontSize, font);
			tfData.draw(tf, matrix);
			var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, .3);
			destination.draw(tfData, null, colorTransform, BlendMode.MULTIPLY);
			applyFilter(destination, destination, new DropShadowFilter());
		}
		
		private static function makeGlassTexture(source:BitmapData, destination:BitmapData, text:String, fontSize:Number, font:String):void
		{
			var tfData:BitmapData = destination.clone();
			var tf:TextField = TextFieldUtils.makeGlassTextField(text, 0x808080, 0xFFFFFF, fontSize, font);
			var matrix:Matrix = new Matrix();
			matrix.translate((destination.width - tf.width) * .5, (destination.height - tf.height) * .5);
			tfData.draw(tf, matrix);
			
			var displacementMapFilter:DisplacementMapFilter = new DisplacementMapFilter(tfData, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED, 15, 15);
			
			// displace the texture bitmap using the captured filtered textfield
			applyFilter(source, destination, displacementMapFilter);
			// use the alpha from textfield on the distorted texture
			var alphaChannel:uint = BitmapDataChannel.ALPHA;
			copyChannel(tfData, destination, alphaChannel, alphaChannel);
			// reuse map bitmap data just because it is the same size;
			tfData.draw(tf, matrix);
			// color transform used to draw overlay lighting text onto textured text;
			destination.draw(tfData, null, new ColorTransform(1, 1, 1, 0.6), BlendMode.OVERLAY);
			// additional filters applied to create glass-like lighting
			applyFilter(destination, destination, new DropShadowFilter(1, 45, 0xFFFFFF, 0.8, 2, 2, 2, 1, true));
			applyFilter(destination, destination, new DropShadowFilter(2, 45, 0, 0.5, 3, 3));
		}
		
		public static function maskTo(source:BitmapData, destination:BitmapData):void
		{
			copyChannel(destination, source, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
		}
		
		public static function makeElipseMask(soruceRect:Rectangle, destRect:Rectangle, border:Number, blur:Number = 20):BitmapData
		{
			var bitmapData:BitmapData = make32BitImage(soruceRect.width, soruceRect.height);
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawEllipse(destRect.x + border, destRect.y + border, destRect.width - border * 2, destRect.height - border * 2);
			shape.graphics.endFill();
			shape.filters = [new BlurFilter(blur, blur)];
			bitmapData.draw(shape);
			return bitmapData;
		}
		
		/**
		 * Because The maximum size for a BitmapData object is 8,191 pixels in width or height,
		 * and the total number of pixels cannot exceed 16,777,215 pixels.
		 * So this method is calculate the biggest ,valid scale value in possible ,
		 * and compare to the scale parameter , it is always same or less then the original value.
		 * The final scale value will be replaced with the result value.
		 */
		public static function calculateScale(sourceRect:Rectangle, scale:Number):Number
		{
			var oriV:Vector2D = new Vector2D(sourceRect.width, sourceRect.height);
			var destV:Vector2D = oriV.multiply(scale);
			//calculate maxV
			var angle:Number = oriV.angle;
			var adjacent:Number = (angle < Math.PI * .25) ? MAX_SIZE1 : MAX_SIZE1 / Math.tan(angle);
			var opposite:Number = Math.tan(angle) * adjacent;
			if (adjacent > opposite)
			{
				opposite = Math.min(opposite, MAX_SIZE2);
				adjacent = opposite / Math.tan(angle);
			}
			else
			{
				adjacent = Math.min(adjacent, MAX_SIZE2);
				opposite = adjacent * Math.tan(angle);
			}
			var maxV:Vector2D = new Vector2D(adjacent, opposite);
			
			if (destV.length > maxV.length)
			{
				destV = maxV;
				scale = destV.x / oriV.x;
			}
			
			return scale;
		}
		
		/**
		 * This method is use to create a zoomed bitmapData .
		 * parameter scale is calculated by method calculateScale to make sure be valid.
		 */
		public static function makeMagnifyData(source:BitmapData, scale:Number):BitmapData
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			var zoom:BitmapData = make32BitImage(source.width * scale, source.height * scale);
			zoom.draw(source, matrix);
			return zoom;
		}
		
		/**
		 * This method is optimized to fit to make magnifying animation.
		 * there are duplicate parameters used ,including zoom bitmapData,scale,which area same in animation.
		 * So let them be send by invoker to  omit unnecessay calculation.
		 */
		public static function magnifyByData(source:BitmapData, destination:BitmapData, zoom:BitmapData, centerPoint:Point, diameter:Number, scale:Number):void
		{
			copyPixels(source, destination);
			var dx:Number = Math.max(0, centerPoint.x * scale);
			var dy:Number = Math.max(0, centerPoint.y * scale);
			var rect:Rectangle = new Rectangle(dx - diameter * .5, dy - diameter * .5, diameter, diameter);
			var lens:BitmapData = makeZoomLens(diameter);
			lens.copyPixels(zoom, rect, new Point(), lens);
			//
			dx = dx / scale - diameter * .5;
			dy = dy / scale - diameter * .5;
			var matrix:Matrix = new Matrix();
			matrix.translate(dx, dy);
			destination.draw(lens, matrix);
			lens.dispose();
		}
		
		//this method is used to make mgnifyicaiton once
		public static function magnify(source:BitmapData, destination:BitmapData, centerPoint:Point, diameter:Number, scale:Number):void
		{
			copyPixels(source, destination);
			scale = calculateScale(source.rect, scale);
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			var zoom:BitmapData = make32BitImage(source.width * scale, source.height * scale);
			zoom.draw(source, matrix);
			
			var dx:Number = Math.max(0, centerPoint.x * scale);
			var dy:Number = Math.max(0, centerPoint.y * scale);
			var rect:Rectangle = new Rectangle(dx - diameter * .5, dy - diameter * .5, diameter, diameter);
			var lens:BitmapData = makeZoomLens(diameter);
			
			/*
			   //effect??
			   var displacementMapFilter:DisplacementMapFilter = new DisplacementMapFilter(
			   lens,
			   new Point(dx,dy),
			   BitmapDataChannel.BLUE,
			   BitmapDataChannel.GREEN,
			   diameter,
			   diameter,
			   DisplacementMapFilterMode.CLAMP
			   );
			   //applyFilter (lens,lens,displacementMapFilter);
			 */
			lens.copyPixels(zoom, rect, new Point(), lens);
			//
			dx = dx / scale - diameter * .5;
			dy = dy / scale - diameter * .5;
			matrix = new Matrix();
			matrix.translate(dx, dy);
			destination.draw(lens, matrix);
			
			zoom.dispose();
			lens.dispose();
		}
		
		private static function makeZoomLens(diameter:Number, amount:Number = 2):BitmapData
		{
			var cRect:Rectangle = new Rectangle(0, 0, diameter, diameter);
			var lens:BitmapData = makeElipseMask(cRect, cRect, 4, 4);
			//
			var center:Number = diameter * .5;
			var radius:Number = center;
			
			for (var y:uint = 0; y < diameter; ++y)
			{
				var ycoord:int = y - center;
				for (var x:uint = 0; x < diameter; ++x)
				{
					var xcoord:int = x - center;
					var distance:Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
					if (distance < radius)
					{
						var t:Number = Math.pow(Math.sin(Math.PI / 2 * distance / radius), amount);
						var dx:Number = xcoord * (t - 1) / diameter;
						var dy:Number = ycoord * (t - 1) / diameter;
						var blue:uint = 0x80 + dx * 0xFF;
						var green:uint = 0x80 + dy * 0xFF;
						lens.setPixel(x, y, green << 8 | blue);
					}
				}
			}
			return lens;
		}
		
		public static function adjustBrightness(source:BitmapData, amount:Number):void
		{
			if (amount < 0)
			{
				var bottom:uint = -amount;
				setLevels(source, bottom, bottom + (255 - bottom) * .5, 255);
			}
			else
			{
				var top:uint = 255 - amount;
				setLevels(source, 0, top * .5, top);
			}
		}
		
		public static function adjustContrast(source:BitmapData, amount:Number):void
		{
			amount += 1; //amount between -1.0 ~ 1.0 , -1 is full meidum gray ,1 is identity
			var filter:ColorMatrixFilter = new ColorMatrixFilter([amount, 0, 0, 0, (128 * (1 - amount)), 0, amount, 0, 0, (128 * (1 - amount)), 0, 0, amount, 0, (128 * (1 - amount)), 0, 0, 0, 1, 1]);
			applyFilter(source, source, filter);
		}
		
		public static function fisheye(source:BitmapData, destination:BitmapData, destPoint:Point, diameter:Number, amount:Number = .8):void
		{
			var lens:BitmapData = makeFisheyeLens(diameter, amount);
			var dx:Number = destPoint.x - diameter * .5;
			var dy:Number = destPoint.y - diameter * .5;
			
			var displacementMapFilter:DisplacementMapFilter = new DisplacementMapFilter(lens, new Point(dx, dy), BitmapDataChannel.BLUE, BitmapDataChannel.GREEN, diameter, diameter, DisplacementMapFilterMode.CLAMP);
			// displacement is applied
			applyFilter(source, destination, displacementMapFilter);
		}
		
		private static function makeFisheyeLens(diameter:uint, amount:Number = 0.8):BitmapData
		{
			var lens:BitmapData = make24BitImage(diameter, diameter);
			lens.fillRect(lens.rect, 0x808080);
			var center:Number = diameter / 2;
			var radius:Number = center;
			for (var y:uint = 0; y < diameter; ++y)
			{
				var ycoord:int = y - center;
				for (var x:uint = 0; x < diameter; ++x)
				{
					var xcoord:int = x - center;
					var distance:Number = Math.sqrt(xcoord * xcoord + ycoord * ycoord);
					if (distance < radius)
					{
						var t:Number = Math.pow(Math.sin(Math.PI / 2 * distance / radius), amount);
						var dx:Number = xcoord * (t - 1) / diameter;
						var dy:Number = ycoord * (t - 1) / diameter;
						var blue:uint = 0x80 + dx * 0xFF;
						var green:uint = 0x80 + dy * 0xFF;
						lens.setPixel(x, y, green << 8 | blue);
					}
				}
			}
			return lens;
		}
		
		public static function carving(source:BitmapData, inColor:uint, outColor:uint):void
		{
			var grayscale:BitmapData = clone32BitImage(source);
			desaturate(grayscale);
			source.fillRect(source.rect, 0x00000000);
			threshold(grayscale, source, "<", inColor, outColor, 0xFFFF0000);
			//paint 3D effect 
			applyFilter(source, source, new BlurFilter(1.2, 1.2));
			applyFilter(source, source, new BevelFilter());
			grayscale.dispose();
		}
		
		// source data must be 32-bit 
		public static function chromaKeying(source:BitmapData, keyColor:uint, torance:Number = 12):void
		{
			var isolateData:BitmapData = clone32BitImage(source);
			var chs:Array = ColorUtils.toRGB(keyColor);
			var rangeR:Array = [Math.max(0, chs[0] - torance) << 16, Math.min(255, chs[0] + torance) << 16];
			var rangeG:Array = [Math.max(0, chs[1] - torance) << 8, Math.min(255, chs[1] + torance) << 8];
			var rangeB:Array = [Math.max(0, chs[2] - torance), Math.min(255, chs[2] + torance)];
			//hold the pixels those color are between the torance of keyColor , and the others fill black 
			threshold(source, isolateData, "<", rangeR[0], 0xFF000000, 0x00FF0000);
			threshold(source, isolateData, ">", rangeR[1], 0xFF000000, 0x00FF0000);
			threshold(source, isolateData, "<", rangeG[0], 0xFF000000, 0x0000FF00);
			threshold(source, isolateData, ">", rangeG[1], 0xFF000000, 0x0000FF00);
			threshold(source, isolateData, "<", rangeB[0], 0xFF000000, 0x000000FF);
			threshold(source, isolateData, ">", rangeB[1], 0xFF000000, 0x000000FF);
			applyFilter(isolateData, isolateData, new BlurFilter(2, 2));
			
			//inverse color , so take white area and let others be transparent;
			applyFilter(isolateData, isolateData, FiltersUtils.invertedFilter[0]);
			var marginR:uint = (255 - torance) << 16;
			var marginG:uint = (255 - torance) << 8;
			var marginB:uint = (255 - torance);
			threshold(isolateData, isolateData, "<", marginR, 0x00000000, 0x00FF0000);
			threshold(isolateData, isolateData, "<", marginG, 0x00000000, 0x0000FF00);
			threshold(isolateData, isolateData, "<", marginB, 0x00000000, 0x000000FF);
			
			copyPixels(source, source, isolateData);
		}
		
		public static function desaturate(source:BitmapData):void
		{
			var gradient:BitmapData = makeGradientData([0x000000, 0xFFFFFF], [1, 1], [0, 255]);
			setGradientPaletteMap(source, gradient);
		}
		
		public static function negative(source:BitmapData):void
		{
			var gradient:BitmapData = makeGradientData([0xffffff, 0x000000], [1, 1], [0, 255]);
			setGradientPaletteMap(source, gradient);
		}
		
		public static function setGradientPaletteMap(source:BitmapData, gradient:BitmapData):void
		{
			applyFilter(source, source, FiltersUtils.grayscaleFilter[0]);
			paletteMap(source, source, createGradientPalletMap(gradient));
		}
		
		public static function makeGradientData(colors:Array, alphas:Array, ratios:Array):BitmapData
		{
			return makeGradientBitmapData(256, 1, colors, alphas, ratios);
		}
		
		private static function createGradientPalletMap(gradient:BitmapData):Vector.<Array>
		{
			var channels:Vector.<Array> = Vector.<Array>([[], [], []]);
			for (var i:uint = 0; i < gradient.width; i++)
			{
				channels[0].push(gradient.getPixel(i, 0));
				channels[1].push(0);
				channels[2].push(0);
			}
			return channels;
		}
		
		public static function posterize(source:BitmapData, levels:uint):void
		{
			var isoChannelsData:Vector.<BitmapData> = new Vector.<BitmapData>();
			isoChannelsData.push(makeIsoChannelData(source, BitmapDataChannel.RED));
			isoChannelsData.push(makeIsoChannelData(source, BitmapDataChannel.GREEN));
			isoChannelsData.push(makeIsoChannelData(source, BitmapDataChannel.BLUE));
			//;
			var adjustedChannelsData:Vector.<BitmapData> = new Vector.<BitmapData>();
			var channelData:BitmapData = make32BitImage(source.width, source.height);
			adjustedChannelsData.push(channelData);
			adjustedChannelsData.push(channelData.clone());
			adjustedChannelsData.push(channelData.clone());
			//;
			levels--;
			for (var i:uint = 0; i < levels; i++)
			{
				var threshold:uint = 255 * ((levels - i) / (levels + 1));
				var brightness:uint = 255 * ((levels - i - 1) / levels);
				drawPosterization(isoChannelsData, adjustedChannelsData, threshold, brightness);
			}
			
			copyChannel(adjustedChannelsData[0], source, BitmapDataChannel.RED, BitmapDataChannel.RED);
			copyChannel(adjustedChannelsData[1], source, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
			copyChannel(adjustedChannelsData[2], source, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
		}
		
		private static function drawPosterization(sourceData:Vector.<BitmapData>, destData:Vector.<BitmapData>, threshold:uint, brightness:uint):void
		{
			var colorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, brightness, brightness, brightness);
			for (var i:uint = 0; i < 3; i++)
			{
				var channelData:BitmapData = sourceData[i].clone();
				setLevels(channelData, threshold, threshold, threshold);
				destData[i].draw(channelData, null, colorTransform, BlendMode.MULTIPLY);
			}
		}
		
		public static function setLevels(source:BitmapData, blackPoint:uint = 0, midPoint:uint = 128, whitePoint:uint = 255):void
		{
			var palettes:Vector.<Array> = makeLevelsPalettes(source, blackPoint, midPoint, whitePoint);
			paletteMap(source, source, palettes);
		}
		
		private static function makeLevelsPalettes(source:BitmapData, blackPoint:uint = 0, midPoint:uint = 128, whitePoint:uint = 255):Vector.<Array>
		{
			var palettes:Vector.<Array> = Vector.<Array>([[], [], []]);
			
			//black level
			for (var i:uint = 0; i <= blackPoint; i++)
			{
				appendPaletteMap(0, palettes);
			}
			//middle level
			var range:uint = midPoint - blackPoint;
			var value:uint = 0;
			for (i = blackPoint + 1; i <= midPoint; i++)
			{
				value = (((i - blackPoint) / range) * 127) | 0;
				appendPaletteMap(value, palettes);
			}
			//white level
			range = whitePoint - midPoint;
			for (i = midPoint + 1; i <= whitePoint; i++)
			{
				value = ((((i - midPoint) / range) * 128) | 0) + 127;
				appendPaletteMap(value, palettes);
			}
			for (i = whitePoint + 1; i < 256; i++)
			{
				appendPaletteMap(0xFF, palettes);
			}
			
			return palettes;
		}
		
		private static function appendPaletteMap(value:uint, paletteMap:Vector.<Array>):void
		{
			paletteMap[0].push(value << 16);
			paletteMap[1].push(value << 8);
			paletteMap[2].push(value);
		}
		
		public static function paletteMap(source:BitmapData, destination:BitmapData, paletteMap:Vector.<Array>):void
		{
			var r:Array = paletteMap[0];
			var g:Array = paletteMap[1];
			var b:Array = paletteMap[2];
			destination.paletteMap(source, destination.rect, new Point(), r, g, b);
		}
		
		public static function setChannelLevels(source:BitmapData, destChannel:uint, blackPoint:uint = 0, midPoint:uint = 128, whitePoint:uint = 255):void
		{
			var palettes:Vector.<Array> = makeChannelLevelsPalettes(source, destChannel, blackPoint, midPoint, whitePoint);
			//
			paletteMap(source, source, palettes);
		}
		
		private static function makeChannelLevelsPalettes(source:BitmapData, destChannel:uint, blackPoint:uint, midPoint:uint, whitePoint:uint):Vector.<Array>
		{
			var palettes:Vector.<Array> = Vector.<Array>([[], [], []]);
			var channelPoints:Vector.<Array> = Vector.<Array>([[], [], []]);
			var black:uint = 0;
			var mid:uint = 0;
			var white:uint = 0;
			var range:uint = 0;
			var value:uint = 0;
			var sh:uint = 0;
			var index:uint = 0;
			for each (var channel:uint in channels)
			{
				if (channel != BitmapDataChannel.ALPHA)
				{
					index = channel >> 1;
					var points:Array = (channel != destChannel) ? [0, 128, 255] : [blackPoint, midPoint, whitePoint];
					channelPoints[index] = points;
				}
			}
			
			for (var j:uint = 0; j < channelPoints.length; j++)
			{
				sh = 8 * (2 - j);
				black = channelPoints[j][0];
				value = 0;
				//black
				for (var i:uint = 0; i <= black; i++)
				{
					palettes[j].push(0);
				}
				//middle level
				mid = channelPoints[j][1];
				range = mid - black;
				for (i = black + 1; i <= mid; i++)
				{
					value = (((i - black) / range) * 127) | 0;
					palettes[j].push(value << (sh));
				}
				//white level
				white = channelPoints[j][2];
				range = white - mid;
				for (i = mid + 1; i <= white; i++)
				{
					value = ((((i - mid) / range) * 128) | 0) + 127;
					palettes[j].push(value << (sh));
				}
				for (i = white + 1; i < 256; i++)
				{
					palettes[j].push(0xFF << (sh));
				}
			}
			return palettes;
		}
		
		public static function threshold(source:BitmapData, destination:BitmapData, operation:String, inColor:uint, outColor:uint, mask:uint = 0x00FF0000):void
		{
			destination.threshold(source, destination.rect, new Point(), operation, inColor, outColor, mask, false);
		}
		
		public static function applyFilter(source:BitmapData, destination:BitmapData, filter:*):void
		{
			destination.applyFilter(source, destination.rect, new Point(), filter);
		}
		
		public static function copyChannel(source:BitmapData, destination:BitmapData, channelFrom:uint, channelTo:uint):void
		{
			destination.copyChannel(source, destination.rect, new Point(), channelFrom, channelTo);
		}
		
		public static function copyPixels(source:BitmapData, destination:BitmapData, alphaData:BitmapData = null):void
		{
			destination.copyPixels(source, destination.rect, new Point(), alphaData);
		}
		
		public static function getChannelData(source:BitmapData, destChannel:uint):BitmapData
		{
			return makeIsoChannelData(source, destChannel);
		}
		
		public static function makeIsoChannelData(source:BitmapData, destChannel:uint):BitmapData
		{
			var bitmapData:BitmapData = make24BitImage(source.width, source.height);
			bitmapData.copyChannel(source, source.rect, new Point(), destChannel, BitmapDataChannel.RED);
			bitmapData.copyChannel(source, source.rect, new Point(), destChannel, BitmapDataChannel.GREEN);
			bitmapData.copyChannel(source, source.rect, new Point(), destChannel, BitmapDataChannel.BLUE);
			return bitmapData;
		}
		
		public static function screenCapture(container:DisplayObject, destRect:Rectangle = null, keepTransparency:Boolean = true):BitmapData
		{
			destRect = (destRect == null) ? new Rectangle(0, 0, container.width, container.height) : destRect;
			
			var bitmapData:BitmapData = (keepTransparency) ? make32BitImage(destRect.width, destRect.height) : make24BitImage(destRect.width, destRect.height);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(container.x, container.y);
			bitmapData.draw(container, matrix);
			/*
			   var border:Shape = new Shape();
			   border.graphics.lineStyle(2,0xFF0000);
			   border.graphics.drawRect(0,0,destRect.width-2,destRect.height-2);
			   bitmapData.draw(border);
			 */
			return bitmapData;
		}
		
		public static function getRainTexture(destRect:Rectangle, density:Number):BitmapData
		{
			var noise:BitmapData = make32BitImage(destRect.width, destRect.height);
			var perlin:BitmapData = noise.clone();
			noise.noise(int(new Date()), 0, 255, BitmapDataChannel.RED, true);
			applyFilter(noise, noise, new BlurFilter(2, 2));
			var black:uint = 240 - 127 * density;
			var mid:uint = (240 - black) * .5 + black;
			setLevels(noise, black, mid, 240);
			perlin.perlinNoise(50, 50, 2, Math.random(), false, true, BitmapDataChannel.RED, true);
			noise.draw(perlin, null, null, BlendMode.MULTIPLY);
			applyFilter(noise, noise, new BlurFilter(1, 2));
			perlin.dispose();
			return noise;
		}
		
		public static function getSnowTexture(destRect:Rectangle, density:Number, scale:Number):BitmapData
		{
			var snow:BitmapData = make32BitImage(destRect.width, destRect.height);
			var dissolve:BitmapData = snow.clone();
			// pixel dissolve transparent image to a white color to create white dots
			dissolve.pixelDissolve(dissolve, dissolve.rect, new Point(), int(Math.random() * 255), destRect.width * destRect.height * density, 0xFFFFFFFF);
			// scale up dissolve so that dots become larger and blurred;
			var matrix:Matrix = new Matrix();
			matrix.scale(2 * scale, 2 * scale);
			snow.draw(dissolve, matrix, null, null, null, true);
			applyFilter(snow, snow, new BlurFilter(4, 4));
			return snow;
		}
		
		public static function distressImage(source:BitmapData, amount:Number):void
		{
			distress(source, amount);
			// rotate the image to apply same distortion in opposite directions ;
			rotateImage(source);
			distress(source, amount);
			// rotate image back right side up;
			rotateImage(source);
		}
		
		public static function distress(source:BitmapData, amount:Number):void
		{
			var perlin:BitmapData = make32BitImage(source.width, source.height);
			perlin.perlinNoise(10, 10, 5, Math.random(), true, true, BitmapDataChannel.RED);
			setLevels(perlin, 0, 50, 100);
			var displaceX:Number = amount;
			var displaceY:Number = amount * 3;
			applyFilter(source, source, new DisplacementMapFilter(perlin, new Point(), BitmapDataChannel.RED, BitmapDataChannel.RED, displaceX, displaceY, DisplacementMapFilterMode.WRAP));
			
			var noise:BitmapData = make32BitImage(source.width, source.height);
			noise.noise(Math.random(), 0, 255, BitmapDataChannel.RED, true);
			applyFilter(noise, noise, new BlurFilter(displaceX, displaceY));
			setLevels(noise, 100, 102, 105);
			var alphaData:BitmapData = makeIsoChannelData(source, BitmapDataChannel.ALPHA);
			alphaData.draw(noise, null, new ColorTransform(1, 1, 1, Math.min(1, amount * .2)), BlendMode.MULTIPLY);
			source.copyChannel(alphaData, alphaData.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
		
		}
		
		public static function rotateImage(source:BitmapData):void
		{
			var matrix:Matrix = new Matrix();
			matrix.rotate(Math.PI);
			matrix.translate(source.width, source.height);
			var rotated:BitmapData = ImageUtils.make32BitImage(source.width, source.height);
			rotated.draw(source, matrix);
			source.copyPixels(rotated, rotated.rect, new Point());
		}
		
		// purple tint to apply
		public static function tint(source:BitmapData, color:uint = 0xFF00CC):void
		{
			// amount to apply
			var percent:Number = .5;
			var r:uint = color >> 16 & 0xFF;
			var g:uint = color >> 8 & 0xFF;
			var b:uint = color & 0xFF;
			var matrix:Array = [r / 255, 0.59, 0.11, 0, 0, g / 255, 0.59, 0.11, 0, 0, b / 255, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			applyColorMatrix(source, matrix);
		}
		
		public static function sepiaTone(source:BitmapData):void
		{
			var matrix:Array = [.5, 0.59, 0.11, 0, 0, .4, 0.59, 0.11, 0, 0, .16, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0];
			applyColorMatrix(source, matrix);
		 
		}
		
		private static function applyColorMatrix(source:BitmapData, matrix:Array):void
		{
			var bitmap:Bitmap = new Bitmap(source);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			bitmap.filters = [filter];
			var bitmapData:BitmapData = ImageUtils.make32BitImage(source.width, source.height);
			bitmapData.draw(bitmap);	 
			source.copyPixels(bitmapData, source.rect, new Point());
		}
		
		
	}

}