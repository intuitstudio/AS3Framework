package com.intuitStudio.images.core
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.errors.IllegalOperationError;

	import com.intuitStudio.loaders.concretes.ImageLoader;

	public class BitmapWrapper extends EventDispatcher
	{
		protected var _loader:ImageLoader;//used  for loading shader file
		protected var _bitmap:Bitmap;
		protected var _bitmapData:BitmapData;
		protected var _valid:Boolean = false;

        /**
        *  Constructure , there are three ways to manufacture wrapper : 
        * with Class Object embed , create shader object directly
        * with Class Name definded , create shader object by other asset factory class
        * with file path , loading external image file ,such as jpg,gif,png
        */
		public function BitmapWrapper (pathOrClass:Object=null)
		{
			_bitmapData = new BitmapData(1,1);
			_bitmap = new Bitmap(_bitmapData);
			if (pathOrClass != null)
			{
				init (pathOrClass);
			}
		}

		protected function init (pathOrClass:Object = null):void
		{
			addEventListener (Event.COMPLETE,onImageReady);
			makeImage (pathOrClass);
		}

		/**
		 * 建立影像內容
		 * @param {Object} , 指定影像的路徑或者參照的類別名稱
		 *  根據輸入的參數自動建立影像的資料，分為三類 :
		 *  1.使用內嵌或者定義的Class
		 *  2.呼叫工廠方法實作影像
		 *  3.呼叫loader下載影像檔案
		 */
		protected function makeImage (pathOrClass:Object):void
		{
			var classRef:Class = pathOrClass as Class;
			if (classRef != null)
			{
				makeImageByClass (classRef);
			}
			else
			{
				var source:Bitmap = makeImageByFactory(pathOrClass as String);
				if (source != null)
				{
					bitmap = source;
					dispatchEvent (new Event(Event.COMPLETE));
				}
				else if ( (pathOrClass as String ) != null)
				{
					makeImageByLoadFile (pathOrClass as String);
				}
				else
				{
					throw new IllegalOperationError('Invalid object passed to ImageWrapper !');
				}
			}
		}
		
		/**
		 * 定義內嵌影像類別的實做方法 
		 *  @param {Class} , 內嵌或定義的影像參考類別名稱
		 *  派送訊息Event.COMPLETE表示完成
		 */
		private function makeImageByClass (classRef:Class):void
		{
			bitmap = new classRef() as Bitmap;
			dispatchEvent (new Event(Event.COMPLETE));
		}
        
		/**
		 * 定義工廠方法實做影像內容的抽象方法 
		 *  @param {String} , 指定影像的參考類別名稱
		 *  @return {Bitmap}
		 *  由繼承的衍生子類別負責實做的內容
		 */
		protected function makeImageByFactory (assetName:String):Bitmap
		{
			throw new IllegalOperationError('makeImageByFactory must be overridden by derivative classes !');
			return null;
		}
		
		/**
		 * 定義下載影像檔案的函式方法，透過自訂的ImageLoader物件載入指定的檔案路徑
		 * @param {String} , 指定影像檔案的路徑或網址
		 * loader完成下載動作將派送Event.COMPLETE事件，可觸發onImageLoaded()函式 
		 */
		protected function makeImageByLoadFile (url:String):void
		{
			if (_loader == null)
			{
				_loader = new ImageLoader();
				_loader.addEventListener (Event.COMPLETE,onImageLoaded);
			}
			_loader.load (url);
		}

		/**
		 * Event.COMPLETE事件的內定監聽器
		 * @param {Event} , Event.COMPLETE
		 * 宣告本身可用並且派送Event.RENDER事件，通知關連物件進行繪製動作
		 */
		protected function onImageReady (e:Event):void
		{
			removeEventListener (Event.COMPLETE,onImageReady);
			valid = true;
			dispatchEvent (new Event(Event.RENDER));
		}

		/**
		 * 監聽loader的下載完成事件 
		 * @param	{ Event }  Event.COMPLETE
		 */
		private function onImageLoaded (e:Event):void
		{
			bitmap = _loader.image;
			dispatchEvent (e);
			_loader.removeEventListener (Event.COMPLETE,onImageLoaded);
			_loader = null;
		}

		//--------------- Setters / Getters ------------------------
		public function set bitmap (image:Bitmap):void
		{
			bitmapData = image.bitmapData;
		}

		public function get bitmap ():Bitmap
		{
			return _bitmap;
		}

		public function set bitmapData (data:BitmapData):void
		{
			_bitmapData = data;
			_bitmap.bitmapData = _bitmapData;
		}

		public function get bitmapData ():BitmapData
		{
			return _bitmapData;
		}

		public function set valid (value:Boolean):void
		{
			_valid = value;
		}

		public function get valid ():Boolean
		{
			return _valid;
		}
		
		//--------  public interfaces and methods --------------------

		public function clone ():BitmapWrapper
		{
			var wrapper:BitmapWrapper = new BitmapWrapper();
			wrapper.bitmap = new Bitmap(bitmapData.clone());
			wrapper.valid = valid;
			return wrapper;
		}

		public function dispose ():void
		{
			_bitmapData.dispose ();
			_bitmapData = null;
			_bitmap = null;
			if (_loader)
			{
				_loader.removeEventListener (Event.COMPLETE,onImageLoaded);
				_loader = null;
			}
		}

	}//end of class

}