package com.intuitStudio.common.concretes
{
	import flash.media.Sound;
	import com.intuitStudio.audios.core.AudioController

	public class LoadAudio extends AudioController
	{
		public  function LoadAudio(pathOrClass:Object,loops:int=0)
		{
			super(pathOrClass,loops);
		}
		
		override protected function makeSoundByFactory (assetName:String):Sound
		{			
			return null;
		}
	}
}