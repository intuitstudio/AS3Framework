package com.intuitStudio.projects.appFramework
{
	/**
	 * Main Class
	 * @author vanier,peng ,2013.5.8
	 * 自訂文件類別，應用程式的進入點
	 * 宣告舞台大小、預載程式以及應用程式主檔所在
	 * 視需要定義全域變數或行為，例如改變滑鼠游標、設定舞台縮放模式...
	 */
	
	//引用應用程式框架	
	import com.intuitStudio.framework.DocumentMain;
	import com.intuitStudio.framework.AppShell;
	import com.intuitStudio.framework.abstracts.GameInstance;
	import com.intuitStudio.framework.factories.abstracts.AbstractGameFactory;
	import com.intuitStudio.framework.managers.classes.*;
	import com.intuitStudio.projects.appFramework.managers.*;
	import com.intuitStudio.projects.appFramework.factories.*;
	
	
	import com.intuitStudio.dataProcess.XML.core.XMLWrapper;
	import com.intuitStudio.dataProcess.XML.abstracts.AbstractXMLParser;
	import com.intuitStudio.projects.appFramework.objects.BookXMLParser;
	
	
	//引用flash顯示元件類別
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.display.StageScaleMode;
	
	[SWF(width="1000",height="700",frameRate="30",backgroundColor="#cccccc")]
	[Frame(factoryClass='com.intuitStudio.projects.appFramework.AppPreloader')] //class name of your preloader
	
	public class Main extends DocumentMain
	{
		
        private var factory : IClassResolverCreator;
		private var classDefines: ClassResolver;         	
		
		override protected function createApp():void
		{
			preDefineClasses();
			
			//視需要採用獨體或者一般物件模式來建構主程式物件
			var mode:String = 'single',coordinate:String='2d';
			
			if (mode === 'single')
			{
				AppShell.setFactory(new AbstractGameFactory(classDefines.getClass('game')));
				myApp = AppShell.getInstance(coordinate) as GameInstance;
			}
			else
			{
				myApp = new GameMain(coordinate); //做為動畫內容時採用
			}
			_stage.addChild(myApp);
		}
		
		/**
		 * 設定舞台基本屬性
		 */
		override protected function setupStage():void
		{
			super.setupStage();
			_stage.scaleMode = StageScaleMode.NO_BORDER;
		}
		
		/**
		 * 登記應用程式中所使用的所有類別；具有類別宣告及實際滙入的作用
		 */
		private function preDefineClasses():void
		{
			ClassResolverSingleton.setFactory(new ClassFrameworkFactory());
			classDefines = ClassResolverSingleton.getInstance();
			classDefines.registerClass(BookXMLParser, 'bookParser');
			
		}
	
	}
}