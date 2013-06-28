package com.intuitStudio.loaders.core
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	public class OpenLocalFile extends EventDispatcher
	{
		protected var _path:String;
		protected var _file:FileReference;
		protected var _fileFilters:Array;
		protected var _valid:Boolean = true;
		
		public function OpenLocalFile(filePath:String=null)
		{
			_path = filePath;
			init();
		}
		
		protected function init():void
		{
			_valid = true;
			makeFileFilter();
			makeFileReference();			
		}
		
		private function makeFileFilter():void
		{
			doMakeFileFilter();			
		}
		
		private function makeFileReference():void
		{
			_file = new FileReference();
			_file.addEventListener(Event.SELECT,onFileSelect);			
		}
		
		protected function onFileSelect(e:Event):void
		{
			trace ('load file ');
		}
		//overridden by derivative classes 
		protected function doMakeFileFilter():void
		{
			_fileFilters = [ new FileFilter("*","*.*") ];
		}
		
		final public function browse():void
		{
			if(_valid)
			{
				_valid = false;				 
			   _file.browse(_fileFilters);
			}
		}
		
		final public function get file():FileReference
		{
			return _file;
		}
		
		final public function set valid(boolean:Boolean):void
		{
			_valid = boolean;
		}
		
		final public function get valid():Boolean
		{
			return _valid;
		}
		
	}
}