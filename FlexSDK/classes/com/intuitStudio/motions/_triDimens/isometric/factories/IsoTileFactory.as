package com.intuitStudio.motions.triDimens.isometric.factories
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import com.intuitStudio.motions.triDimens.isometric.core.IsoObject;
	import com.intuitStudio.motions.triDimens.isometric.concretes.IsoWorld;
	
	public class IsoTileFactory
	{
		
		public function makeTileObject(def:Dictionary):IsoObject
		{
			return doMakeTileObject(def);
		}
		
		protected function doMakeTileObject(def:Dictionary):IsoObject
		{
			throw new IllegalOperationError('doMakeTileOjbect must be overrided by subClass');
			return null;
		}
		
	}	
	
}