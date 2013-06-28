package com.intuitStudio.utils
{
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.display.DisplayObjectContainer;

	import flash.geom.Point;

	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterQuality;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TextFieldUtils
	{
		public static const SENSITIVE_NONE:int = 0;
		public static const SENSITIVE_CAPITAL:int = 1;
		public static const SENSITIVE_LOWERCASE:int = 2;

		//public static function makeTextField (size:Number=12,color:uint=0,fontFamily:String='_sans',align:String=TextFormatAlign.CENTER,auto:String = TextFieldAutoSize.LEFT):TextField
        public static function makeTextField(size:Number=12,color:uint=0,fontFamily:String='_sans',bold:Boolean=false,align:String='left',autoSize:String='left',space:int=0):TextField
        {
			var tf:TextField = new TextField();
			tf.multiline = true;
			tf.wordWrap = false;
			tf.border = false;
			tf.selectable = false;
			tf.autoSize = autoSize;
			var format:TextFormat = new TextFormat(fontFamily,size,color);
			format.align = align;
			format.letterSpacing = space;
			tf.defaultTextFormat = format;
			return tf;
		}

		public static function randomAsciiChar (sensitive:int=0):String
		{
			var codes:Vector.<int >  = Vector.<int > ([0,65,97]);
			var startCode:int = codes[sensitive];
			var charSum:int = 26;

			if (startCode == 0)
			{
				startCode = (Math.random()>.5) ?codes[1]:codes[2];
			}
			return makeRamdonChar(startCode, charSum-1);
		}

		public static function makeRamdonChar (startCode:int,sum:int):String
		{
			return String.fromCharCode(startCode + Math.floor(Math.random() * (sum-1)));
		}

		public static function makeTextFieldSpreadChars (w:Number,h:Number,chars:int,format:TextFormat=null):TextField
		{
			var tf:TextField = new TextField();
			tf.width = w;
			tf.height = h;
			tf.wordWrap = true;
			tf.multiline = true;
			tf.border = true;
			tf.defaultTextFormat = (format==null)?new TextFormat('Arial',24):format;
			for (var i:uint=0; i<chars; i++)
			{
				tf.appendText (randomAsciiChar());
			}
			return tf;
		}

		static public function disableTextFields (displayObject:DisplayObjectContainer):void
		{
			for (var i:int = 0; i < displayObject.numChildren; i++)
			{
				if (displayObject.getChildAt(i) is TextField)
				{
					var tf:TextField = displayObject.getChildAt(i) as TextField;
					if (tf.type == TextFieldType.DYNAMIC)
					{
						tf.mouseEnabled = false;
						tf.tabEnabled = false;
					}
				}
			}
		}

		static public function createDisplayText (text:String, w:Number, h:Number,location:Point,textFormat:TextFormat=null,filters:Array=null):TextField
		{
			var displayText:TextField = new TextField();
			displayText.y = location.y;
			displayText.x = location.x;
			displayText.width = w;
			displayText.height = h;
			displayText.multiline = true;
			displayText.autoSize = TextFieldAutoSize.NONE;
			if (textFormat)
			{
				displayText.defaultTextFormat = textFormat;
			}
			displayText.selectable = false;
			displayText.text = text;
			if (filters)
			{
				displayText.filters = filters;
			}

			return displayText;
		}


		public static function makeBevelTextField (text:String,textColor:uint,highlightColor:uint,fontSize:Number,font:String="Impact"):TextField
		{
			var textfield:TextField = new TextField();
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.multiline = true;
			//textfield.wordWrap = true;
			// change font face if Impact is not installed
			var textFormat:TextFormat = new TextFormat(font,fontSize,textColor);
			textFormat.align = TextFormatAlign.CENTER;
			textfield.defaultTextFormat = textFormat;
			textfield.text = text;
			var bevelFilter:BevelFilter = new BevelFilter(8,225);
			bevelFilter.highlightColor = highlightColor;
			bevelFilter.strength = 4;
			bevelFilter.blurX = bevelFilter.blurY = 2;
			bevelFilter.quality = BitmapFilterQuality.HIGH;
			textfield.filters = [bevelFilter];
			return textfield;
		}

		public static function makeGlassTextField (text:String,textColor:uint,highlightColor:uint,fontSize:Number,font:String="Impact"):TextField
		{
			var textfield:TextField = new TextField();
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.multiline = true;
			// change font face if Impact is not installed
			var textFormat:TextFormat = new TextFormat(font,fontSize,textColor);
			textFormat.align = TextFormatAlign.CENTER;
			textfield.defaultTextFormat = textFormat;
			textfield.text = text;
			var bevelFilter:BevelFilter = new BevelFilter(5,45);
			bevelFilter.highlightColor = highlightColor;
			bevelFilter.blurX = bevelFilter.blurY = 7;
			textfield.filters = [bevelFilter];
			return textfield;
		}

	}//endOfClass
}//endOfPackage