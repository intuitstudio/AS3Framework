package com.intuitStudio.common.objects
{
	import flash.events.Event;
 
	import com.intuitStudio.common.concretes.LoadImage;
	import com.intuitStudio.images.abstracts.AdvancedImage;

	public class WorldMap extends AdvancedImage
	{
		public function WorldMap(scale:Number=1.0)
		{			
			super (new LoadImage('images/worldMap.jpg'),scale);
		}

	}
}