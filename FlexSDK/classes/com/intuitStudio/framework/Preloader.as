package com.intuitStudio.framework
{	
	/**
	 * Preloader
	 * @author vanier peng
	 * 定義預載基本動作架構與事件監聽
	 */
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	public class Preloader extends MovieClip 
	{		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
		}
		
		protected function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		protected function progress(e:ProgressEvent):void 
		{
			// TODO update loader
		}
		
		protected function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		protected function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			startup();
		}
		
		protected function startup():void 
		{
			trace('startup must be overridden by subClass!');
		}
		
	}
	
}