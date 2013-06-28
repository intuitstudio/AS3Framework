package com.intuitStudio.common.objects
{
	import flash.events.Event;
 
	import com.intuitStudio.common.concretes.LoadImage;
	import com.intuitStudio.images.abstracts.AdvancedImage;

	public class LoadTextureMap extends AdvancedImage
	{
		public function LoadTextureMap(path:String,scale:Number=1.0)
		{			
			super (new LoadImage(path),scale);
		}

	}
}