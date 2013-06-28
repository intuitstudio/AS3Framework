/*
   Assets Class inherit AssetsFB Class , define custom project asset resource.

 */
package com.intuitStudio.projects.appFramework.factories
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.display.Shader;
	import flash.utils.Dictionary;
	
	import com.intuitStudio.framework.managers.classes.ClassResolverSingleton;
	import com.intuitStudio.framework.managers.classes.ClassResolver;
	import com.intuitStudio.common.factories.abstracts.AssetsFB;
	import com.intuitStudio.utils.AssetUtils;
	
	public class Assets extends AssetsFB
	{
		//asset drcription format : TYPE_LABEL		
		public static const IMAGE_COVER_LEFT:String = 'coverLeft';
		public static const IMAGE_COVER_RIGHT:String = 'coverRight';
		public static const IMAGE_ANT_LEFT:String = 'antLeft';
		public static const IMAGE_ANT_RIGHT:String = 'antRight';
		public static const IMAGE_FLOWER_LEFT:String = 'flowerLeft';
		public static const IMAGE_FLOWER_RIGHT:String = 'flowerRight';
		public static const IMAGE_SUN_LEFT:String = 'sunLeft';
		public static const IMAGE_SUN_RIGHT:String = 'sunRight';
		public static const IMAGE_MOON_LEFT:String = 'moonLeft';
		public static const IMAGE_MOON_RIGHT:String = 'moonRight';
		//-------------definition embed aseet resources ----------------------------
		
		//bitmap images
		[Embed(source='./../../../../../assets/images/cover_lt.jpg')]
		private static var CoverLeft:Class;
		[Embed(source='./../../../../../assets/images/cover_rt.jpg')]
		private static var CoverRight:Class;
		
		[Embed(source='./../../../../../assets/images/ant_lt.jpg')]
		private static var AntLeft:Class;
		[Embed(source='./../../../../../assets/images/ant_rt.jpg')]
		private static var AntRight:Class;
		
		[Embed(source='./../../../../../assets/images/flower_lt.jpg')]
		private static var FlowerLeft:Class;
		[Embed(source='./../../../../../assets/images/flower_rt.jpg')]
		private static var FlowerRight:Class;
		
		[Embed(source='./../../../../../assets/images/sun_lt.jpg')]
		private static var SunLeft:Class;
		[Embed(source='./../../../../../assets/images/sun_rt.jpg')]
		private static var SunRight:Class;
		
		[Embed(source='./../../../../../assets/images/moon_lt.jpg')]
		private static var MoonLeft:Class;
		[Embed(source='./../../../../../assets/images/moon_rt.jpg')]
		private static var MoonRight:Class;
		
		private static var _classPath:String = "com.intuitStudio.projects.appFramework.factories";
		
		private static var classLibs:Vector.<Object>;
		
		public static function register():void
		{
			classLibs = new Vector.<Object>();
			registClass(CoverLeft, 'cover_L', MIMETYPE_IMAGE);
			registClass(CoverRight, 'cover_R', MIMETYPE_IMAGE);
			registClass(AntLeft, 'page0_L', MIMETYPE_IMAGE);
			registClass(AntRight, 'page0_R', MIMETYPE_IMAGE);
			registClass(FlowerLeft, 'page1_L', MIMETYPE_IMAGE);
			registClass(FlowerRight, 'page1_R', MIMETYPE_IMAGE);
			registClass(SunLeft, 'page2_L', MIMETYPE_IMAGE);
			registClass(SunRight, 'page2_R', MIMETYPE_IMAGE);
			registClass(MoonLeft, 'page3_L', MIMETYPE_IMAGE);
			registClass(MoonRight, 'page3_R', MIMETYPE_IMAGE);
		}
		
		private static function registClass(theClass:Class, assetId:String, assetType:int):void
		{
			 
			ClassResolverSingleton.getInstance().registerClass(theClass,assetId);
			
			classLibs.push({id: assetId, type: assetType});
		}
		
		private static function getClassTypeById(id:String):int
		{
			for each (var obj:Object in classLibs)
			{
				if (obj.id === id)
				{
					return obj.type;
				}
			}
			return -1;
		}
		
		public static function getAssetById(id:String):*
		{
			if (ClassResolverSingleton.getInstance().classExists(id))
			{
				var classRef:Class = ClassResolverSingleton.getInstance().getClass(id);
				var type:int = getClassTypeById(id);
				switch (type)
				{
					case AssetsFB.MIMETYPE_IMAGE: 
						return new classRef() as Bitmap;
						break;
					case AssetsFB.MIMETYPE_SWF: 
						return new classRef() as MovieClip;
						break;
					case AssetsFB.MIMETYPE_BYTES: 
						return new classRef() as ByteArray;
						break;
					case AssetsFB.MIMETYPE_SOUND: 
						return new classRef() as Sound;
						break;
					case AssetsFB.MIMETYPE_SHADER: 
						return new classRef() as Shader;
						break;
					default:
						return new classRef();
				}			
			}
			else
			{
				return null;
			}
		}
		
		public static function getInstanceByClass(theClass:Class):*
		{
		
		}
		
		public static function getAsset(assetName:String):*
		{
			AssetsFB.setFactory(new Assets());
			var type:int = getClassTypeById(assetName);
			return AssetsFB.getEmbedAssetByName(assetName,type);
			
		}
		
		override protected function doMakeAsset(id:String, type:int):*
		{
			return makeAssetInstance(id, type);
			switch (assetName)
			{
				case IMAGE_PORTRAIT: 
					return makeAssetInstance(getClassName(LogoImage), MIMETYPE_IMAGE);
					break;
				case IMAGE_GIRL: 
					//return makeAssetInstance(getClassName(BeautyImage),MIMETYPE_IMAGE);
					break;
				case IMAGE_ANGELGIRL: 
					//return makeAssetInstance(getClassName(AngelGirlImage),MIMETYPE_IMAGE);
					break;
				case IMAGE_WORLDMAP: 
					//return makeAssetInstance(getClassName(WorldMapImage),MIMETYPE_IMAGE);
					break;
				case SOUND_GAMETRACK: 
					//return makeAssetInstance(getClassName(GameTrack),MIMETYPE_SOUND);
					break;
				case IMAGE_FOLDER: 
					//return makeAssetInstance(getClassName(FolderImage),MIMETYPE_IMAGE);
					break;
				case IMAGE_OPENFOLDER: 
					//return makeAssetInstance(getClassName(OpenFolderImage),MIMETYPE_IMAGE);
					break;
			
			/*
			   case SHADER_HORIZONTALLINES :
			   return makeAssetInstance(getClassName(HorizontalLinesShader),MIMETYPE_SHADER);
			   break;
			   case SHADER_TWIRL :
			   //return makeAssetInstance(getClassName(TwirlShader),MIMETYPE_SHADER);
			   break;
			   case SHADER_BLEND :
			   //return makeAssetInstance(getClassName(BlendShader),MIMETYPE_SHADER);
			   break;
			   case SHADER_DESATURATE:
			   return makeAssetInstance(getClassName(DesaturateShader),MIMETYPE_SHADER);
			   break;
			 */
			}
			return null;
		}
		
		override protected function makeAssetInstance(symbolName:String, type:int):*
		{
			symbolName = _classPath + "." + symbolName;
			
			switch (type)
			{
				case AssetsFB.MIMETYPE_IMAGE: 
					return AssetUtils.getImageBySymbol(symbolName) as Bitmap;
					break;
				case AssetsFB.MIMETYPE_SWF: 
					return AssetUtils.getSwfBySymbol(symbolName) as MovieClip;
					break;
				case AssetsFB.MIMETYPE_BYTES: 
					return AssetUtils.getSwcBySymbol(symbolName) as ByteArray;
					break;
				case AssetsFB.MIMETYPE_SOUND: 
					return AssetUtils.getSoundBySymbol(symbolName) as Sound;
					break;
				case AssetsFB.MIMETYPE_SHADER: 
					return AssetUtils.getShaderBySymbol(symbolName) as Shader;
					break;
			}
			return null;
		}
	
	}

}