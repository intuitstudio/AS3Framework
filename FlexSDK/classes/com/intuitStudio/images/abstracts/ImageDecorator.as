package com.intuitStudio.images.abstracts
{	
    /**
     *  ImageDecorator Class
     * @author vanier peng ,2013.4.17
     * purpose : 定義ImageComponent類別的包裝類別，應用於Decorator Pattern，方便動態附加額外的功能和權責而不必衍生新的子類別
     *           例如針對相同影像資料欲套用不同的單一或多個濾鏡效果時
	 * 
    */
	import com.intuitStudio.images.core.BitmapWrapper
	import com.intuitStudio.images.abstracts.ImageComponent;
	
	public class ImageDecorator extends ImageComponent
	{		
		public function ImageDecorator(image:BitmapWrapper)
		{
			super(image);			
		}		

		//Abstract Method
		public function init():void
		{
			
		}
        
		//---- Define Operation methods ----------------
		public function applyShader():void
		{
			
		}
		
		public function getParameter (name:String):Object
		{
			return null;
		}
		
		public function setParameter (name:String,value:Object):Boolean
		{
			return false;
		}

	}
	
}
