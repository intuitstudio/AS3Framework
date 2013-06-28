package com.fr.kikko.lab
{
	import flash.events.ProgressEvent;
	import cmodule.shine.CLibInit;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;

/**
* @author kikko.fr - 2010
*/
	public class ShineMP3Encoder extends EventDispatcher
	{

		public var wavData:ByteArray;
		public var mp3Data:ByteArray;

		private var cshine:*;
		public var initObj:*;
		private var timer:Timer;
		private var initTime:uint;

		public function ShineMP3Encoder (wavData:ByteArray)
		{
			this.wavData = wavData;						
		}

		public function start ():void
		{
			initTime = getTimer();

			mp3Data = new ByteArray();

			timer = new Timer(175);
			timer.addEventListener (TimerEvent.TIMER, update);
			//timer = new Timer(1000 / 30);
			//timer.addEventListener (TimerEvent.TIMER,update);

			cshine = (new CLibInit()).init();

			cshine.init (this,wavData,mp3Data);

			if (timer)
			{
				timer.start ();
			}
		}

		public function shineError (message:String):void
		{
			trace ('shineError ');
			timer.stop ();
			timer.removeEventListener (TimerEvent.TIMER,update);
			timer = null;

			dispatchEvent (new ErrorEvent(ErrorEvent.ERROR,false,false,message));
		}

		public function saveAs (filename:String=".mp3"):void
		{
			var file:FileReference = new FileReference();
			file.save (mp3Data,filename);
			//new FileReference  .save (mp3Data,filename);
		}

		private function update (event:TimerEvent):void
		{
			trace ('update',cshine);
			try
			{
				//loose the percent INT type and replace it by *
				var percent:* = cshine.update();
			}
			catch (e:Error)
			{
				trace ("ShineMP3Encoder::update : cshine.update() error:" + e.message);
			}

			//
			dispatchEvent (new ProgressEvent(ProgressEvent.PROGRESS,false,false,percent,100));

			trace ("encoding mp3...",percent + "%");

			if (percent == 100)
			{

				trace ("Done in",getTimer() - initTime * 0.001 + "s");

				timer.stop ();
				timer.removeEventListener (TimerEvent.TIMER,update);
				timer = null;

				dispatchEvent (new Event(Event.COMPLETE));
			}
		}
	}
}