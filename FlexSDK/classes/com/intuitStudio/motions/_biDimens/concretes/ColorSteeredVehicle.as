package com.intuitStudio.motions.biDimens.concretes
{
	import flash.geom.ColorTransform;
	import com.intuitStudio.utils.ColorUtils;
    import com.intuitStudio.motions.biDimens.abstracts.SteeredVehicle;

	
	public class ColorSteeredVehicle extends SteeredVehicle
	{

		public function ColorSteeredVehicle ()
		{
			super (true);
		}
		
		public function changeColor(color:uint=0xFFFFFF):void
		{			
			this.transform.colorTransform =  ColorUtils.colorTransform(color);
		}
	}
}