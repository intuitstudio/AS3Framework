package com.intuitStudio.utils
{
	import flash.display.Bitmap;
    import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.display.Shader;
	
	import com.intuitStudio.framework.concretes.ImageAssets;
	import com.intuitStudio.framework.concretes.AudioAssets;
	import com.intuitStudio.framework.concretes.SwfAssets;
	import com.intuitStudio.framework.concretes.SwcAssets;
	import com.intuitStudio.framework.concretes.ShaderAssets;
	import com.intuitStudio.framework.concretes.XMLAssets;
	import com.intuitStudio.framework.interfaces.IEmbedAssets;
	
	public class AssetUtils
	{
		private static var _importer:IEmbedAssets;
		private static var _classRefPath:String;
		private static var _imgImporter:ImageAssets = new ImageAssets();
		private static var _swfImporter:SwfAssets = new SwfAssets();
		private static var _swcImporter:SwcAssets = new SwcAssets();
		private static var _shaderImporter:ShaderAssets = new ShaderAssets();
		private static var _soundImporter:AudioAssets = new AudioAssets();
		private static var _xmlImporter:XMLAssets = new XMLAssets();
		
		public static function set importer(value:IEmbedAssets):void
		{
			_importer = value;
		}
		
		public static function get importer():IEmbedAssets
		{
			return _importer;
		}
		
		public static function set classRefPath(value:String):void
		{
			_classRefPath = value;
		}
		
		public static function get classRefPath():String
		{
			return _classRefPath;
		}

		
		public static function getImageByFileName(fileName:String):Bitmap
		{
			//use loading			
			return null;
		}
		
		public static function getImageBySymbol(symbolName:String):Bitmap
		{
			return _imgImporter.getAssetByName(symbolName);
		}
		
		public static function getSwfByFileName(fileName:String):MovieClip
		{
			//use loading			
			return null;
		}
		
		public static function getSwfBySymbol(symbolName:String):MovieClip		
		{
			return _swfImporter.getAssetByName(symbolName);
		}
		
		public static function getSoundByFileName(fileName:String):Bitmap
		{
			//use loading	
			return null;
		}
		
		public static function getSoundBySymbol(symbolName:String):Sound
		{
			return _soundImporter.getAssetByName(symbolName);
		}
		
		public static function getSwcBySymbol(symbolName:String):ByteArray
		{
			return _swcImporter.getAssetByName(symbolName);
		}
		
		public static function getShaderBySymbol(symbolName:String):Shader
		{
			return _shaderImporter.getAssetByName(symbolName);;
		}		

		public static function getXMLBySymbol(symbolName:String):XML
		{
			return _xmlImporter.getAssetByName(symbolName);;
		}		
	}	
}