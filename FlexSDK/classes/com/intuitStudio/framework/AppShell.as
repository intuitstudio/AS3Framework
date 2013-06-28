package com.intuitStudio.framework
{
	import com.intuitStudio.framework.interfaces.*;
	import com.intuitStudio.framework.abstracts.GameInstance;
	import com.intuitStudio.framework.managers.classes.ClassResolverSingleton;
	import com.intuitStudio.utils.TextFieldUtils;
	

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.geom.Point;

	public class AppShell extends EventDispatcher implements IShell
	{
		static private var _instance:IGame;
		static private var _factory:IGameFactory;

		public function AppShell ()
		{
			if (_instance)
			{
				throw new Error("Access it in getInstance method");
			}
		}

		static public function getInstance (coordinate:String):IGame
		{
			if (! _instance)
			{
				_instance = _factory.makeGame(coordinate);
			}
			return _instance;
		}

		static public function setFactory (gameFactory : IGameFactory):void
		{
			_factory = gameFactory;
		}

		public function dispose ():void
		{
			
		}

		static public function createLoadingIcon (className:String='AniLoading'):Sprite
		{
			var loadingSp:Sprite = new Sprite();			
			if (ClassResolverSingleton.getInstance().classExists(className))
			{
			   var loadingClass:Class = ClassResolverSingleton.getInstance().getClass(className);
			   if (loadingClass)
			   {
			   	  loadingSp.addChildAt (new loadingClass(),0);
				  loadingSp.scaleX = loadingSp.scaleY = 5;
			   }
			}	

            //add percentage text 
			var format:TextFormat = new TextFormat();
			format.color = 0x00AAAA;
			format.size = 8;
			format.align = TextFormatAlign.CENTER;
			var txtField:TextField = TextFieldUtils.createDisplayText("",37,37,new Point(0,12),format);
			txtField.border = false;

			loadingSp.addChild(txtField);

			return loadingSp;
		}
	}
}