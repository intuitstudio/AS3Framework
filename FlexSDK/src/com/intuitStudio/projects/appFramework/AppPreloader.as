package com.intuitStudio.projects.appFramework
{
	/**
	 * AppPreloader Class
	 * @author vanier peng
	 * 實做應用程式預載動作
	 */	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;	
	import com.intuitStudio.framework.Preloader	

	public class AppPreloader extends Preloader 
	{		
		private var appClass:String = "com.intuitStudio.projects.appFramework.Main"; 
		
		public function AppPreloader() 
		{
			super();			
		}
			
		override protected function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			var percent:Number = Math.round(e.bytesLoaded / e.bytesTotal * 100);
			trace(percent);
		}
		
		override protected function startup():void 
		{			 
			var mainClass:Class = getDefinitionByName(appClass) as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}